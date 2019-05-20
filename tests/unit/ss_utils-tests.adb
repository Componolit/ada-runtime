with Aunit.Assertions;
with System.Storage_Elements;

package body Ss_Utils.Tests is

   package SSE renames System.Storage_Elements;
   Alloc_Success : Boolean := False;
   Valid_Stack : System.Address := SSE.To_Address (16#ffffffff#);

   ---------------------------
   -- Test helper functions --
   ---------------------------

   function C_Alloc (Size : SSE.Storage_Count) return System.Address
     with
       Export,
       Convention => C,
       External_Name => "allocate_secondary_stack";

   function C_Alloc (Size : SSE.Storage_Count) return System.Address
   is
   begin
      if Alloc_Success then
         return Valid_Stack;
      else
         return System.Null_Address;
      end if;
   end C_Alloc;

   procedure Set_Mark_Invalid_Stack
   is
      M : Mark := (Base  => System.Null_Address,
                   Top   => 0);
   begin
      M.Base := System.Storage_Elements.To_Address (42);
      Set_Mark (M);
   end Set_Mark_Invalid_Stack;

   procedure Alloc_Stack_With_Null_Ptr
   is
      Ptr : System.Address;
   begin
      Alloc_Success := False;
      Ptr := Allocate_Stack (0);
   end Alloc_Stack_With_Null_Ptr;

   procedure S_Allocate_Stack_Overflow_1
   is
      Stack_Ptr : System.Address;
   begin
      S_Allocate (Stack_Ptr, Secondary_Stack_Size * 2);
   end S_Allocate_Stack_Overflow_1;

   procedure S_Allocate_Stack_Overflow_2
   is
      Stack_Ptr : System.Address;
   begin
      for I in 0 .. 1024 loop
         S_Allocate (Stack_Ptr, SSE.Storage_Offset (1024));
      end loop;
   end S_Allocate_Stack_Overflow_2;

   procedure S_Release_High_Mark
   is
      Mark_Id : SSE.Storage_Count;
      Mark_Base : System.Address;
      Stack_Ptr : System.Address;
   begin
      S_Allocate (Stack_Ptr, 8);
      S_Mark (Mark_Base, Mark_Id);
      S_Release (Mark_Base, Mark_Id + 1);
   end S_Release_High_Mark;

   -------------------
   -- Test routines --
   -------------------

   procedure Test_Get_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Test_Mark : Mark;
      T1_Mark : Mark := (Base => System.Null_Address,
                         Top   => 0);
   begin
      Alloc_Success := True;
      Get_Mark (Test_Mark);
      AUnit.Assertions.Assert (Test_Mark.Base /= System.Null_Address,
                               "Stack not initialized");
      AUnit.Assertions.Assert (Test_Mark.Top = 0,
                               "Top not null after initialization");

      Get_Mark (T1_Mark);
      AUnit.Assertions.Assert (Test_Mark = T1_Mark,
                               "Failed to get T1 mark");
   end Test_Get_Mark;

   procedure Test_Set_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      E1 : Mark;
      E2 : Mark;
   begin
      AUnit.Assertions.Assert_Exception (Set_Mark_Invalid_Stack'Access,
                                         "Set mark on invalid stack failed");

      Get_Mark (E1);
      E1.Top := 42;
      Set_Mark (E1);
      Get_Mark (E2);
      AUnit.Assertions.Assert (E1 = E2,
                               "Storing mark failed");
   end Test_Set_Mark;

   procedure Test_Allocate_Stack (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Alloc_Success := True;
      AUnit.Assertions.Assert (Allocate_Stack (0) /= System.Null_Address,
                               "Allocate stack failed");
      AUnit.Assertions.Assert_Exception (Alloc_Stack_With_Null_Ptr'Access,
                                         "Allocate stack with null failed");
   end Test_Allocate_Stack;

   procedure Test_S_Allocate (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      M : Mark;
      Stack_Base : System.Address;
      Stack_Ptr  : System.Address;
   begin
      Alloc_Success := True;

      Get_Mark (M);
      AUnit.Assertions.Assert (M.Base /= System.Null_Address,
                               "Base allocation failed");
      AUnit.Assertions.Assert (M.Top = 0,
                               "Top not initialized with 0");

      Stack_Base := M.Base;
      S_Allocate (Stack_Ptr, 8);
      AUnit.Assertions.Assert (Stack_Base - 8 = Stack_Ptr,
                        "Invalid base move");
      Get_Mark (M);
      AUnit.Assertions.Assert (M.Top = 8,
                               "Unmodified top");

      S_Allocate (Stack_Ptr, 8);
      AUnit.Assertions.Assert (Stack_Base - 16 = Stack_Ptr,
                               "Invalid stack ptr");
      Get_Mark (M);
      AUnit.Assertions.Assert (M.Top = 16,
                               "Invalid top");

      AUnit.Assertions.Assert_Exception (S_Allocate_Stack_Overflow_1'Access,
                                         "Failed to detect stack overflow 1");
      AUnit.Assertions.Assert_Exception (S_Allocate_Stack_Overflow_2'Access,
                                         "Failed to detect stack overflow 2");
   end Test_S_Allocate;

   procedure Test_S_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      M : Mark;
      S_Addr : System.Address;
      S_Pos : SSE.Storage_Count;
      Stack_Ptr : System.Address;
   begin
      S_Allocate (Stack_Ptr, 8);
      S_Mark (S_Addr, S_Pos);
      Get_Mark (M);
      AUnit.Assertions.Assert (S_Pos = M.Top and S_Pos = 8 and S_Addr = M.Base,
                               "Invalid mark location");
   end Test_S_Mark;

   procedure Test_S_Release (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      M : Mark;
      Stack_Ptr : System.Address;
      Mark_Id : System.Address;
      Mark_Pos : SSE.Storage_Count;
   begin
      AUnit.Assertions.Assert_Exception (S_Release_High_Mark'Access,
                                         "Invalid stack release");

      S_Allocate (Stack_Ptr, 8);
      S_Mark (Mark_Id, Mark_Pos);
      S_Allocate (Stack_Ptr, 4);
      S_Allocate (Stack_Ptr, 4);
      Get_Mark (M);

      AUnit.Assertions.Assert (M.Top = 16,
                               "Top not initialized correctly");
      AUnit.Assertions.Assert (Stack_Ptr /= Mark_Id - Mark_Pos,
                               "Mark not set correctly");

      S_Release (Mark_Id, Mark_Pos);
      Get_Mark (M);
      AUnit.Assertions.Assert (M.Top = 8,
                               "Top not reset correctly");
      AUnit.Assertions.Assert (M.Top = Mark_Pos,
                               "Invalid mark id");
      S_Allocate (Stack_Ptr, 8);
      AUnit.Assertions.Assert (Mark_Id - Mark_Pos = Stack_Ptr + 8,
                               "Invalid stack ptr location");
   end Test_S_Release;

   procedure Test_C_Alloc (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Alloc_Success := True;
      AUnit.Assertions.Assert (C_Alloc (0) /= System.Null_Address,
                               "Alloc test failed");
      Alloc_Success := False;
      AUnit.Assertions.Assert (C_Alloc (0) = System.Null_Address,
                               "Null Address test failed");
   end Test_C_Alloc;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Get_Mark'Access, "Test Get_Mark");
      Register_Routine (T, Test_Set_Mark'Access, "Test Set_Mark");
      Register_Routine (T, Test_Allocate_Stack'Access, "Test Allocate_Stack");
      Register_Routine (T, Test_S_Allocate'Access, "Test S_Allocate");
      Register_Routine (T, Test_S_Mark'Access, "Test S_Mark");
      Register_Routine (T, Test_S_Release'Access, "Test S_Release");
      Register_Routine (T, Test_C_Alloc'Access, "Test C_Alloc");
   end Register_Tests;

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return Aunit.Message_String is
   begin
      return Aunit.Format ("Ss_Utils");
   end Name;

end Ss_Utils.Tests;
