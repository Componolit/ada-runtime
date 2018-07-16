with Aunit.Assertions;
with System.Storage_Elements;

package body Ss_Utils.Tests is

   package SSE renames System.Storage_Elements;
   Alloc_Success : Boolean := False;
   Valid_Thread : Thread := Thread (SSE.To_Address (16#1000#));
   Valid_Stack : System.Address := SSE.To_Address (16#ffffffff#);

   ---------------------------
   -- Test helper functions --
   ---------------------------

   function C_Alloc (T    : Thread;
                     Size : SSE.Storage_Count) return System.Address
     with
       Export,
       Convention => C,
       External_Name => "allocate_secondary_stack";

   function C_Alloc (T : Thread;
                     Size : SSE.Storage_Count) return System.Address
   is
   begin
      if Alloc_Success then
         return Valid_Stack;
      else
         return System.Null_Address;
      end if;
   end C_Alloc;

   procedure Get_Mark_Full_Registry
   is
      E : Mark;
      R : Registry := Null_Registry;
      T : constant Thread :=  Thread (System.Storage_Elements.To_Address (42));
   begin
      for I in R'Range loop
         R (I).Id := Valid_Thread;
      end loop;
      Get_Mark (T, R, E);
   end Get_Mark_Full_Registry;

   procedure Get_Mark_Invalid_Thread
   is
      E : Mark;
      R : Registry := Null_Registry;
   begin
      Get_Mark (Invalid_Thread, R, E);
   end Get_Mark_Invalid_Thread;

   procedure Set_Mark_Unknown_Thread
   is
      T : Thread := Valid_Thread;
      R : Registry := Null_Registry;
      M : Mark := (Base  => System.Storage_Elements.To_Address (42),
                   Top   => 8);
   begin
      Set_Mark (T, M, R);
   end Set_Mark_Unknown_Thread;

   procedure Set_Mark_Invalid_Thread
   is
      T : Thread := Invalid_Thread;
      R : Registry := Null_Registry;
      M : Mark := (Base  => System.Storage_Elements.To_Address (42),
                            Top   => 8);
   begin
      Set_Mark (T, M, R);
   end Set_Mark_Invalid_Thread;

   procedure Set_Mark_Invalid_Stack
   is
      T : Thread := Valid_Thread;
      R : Registry := Null_Registry;
      M : Mark := (Base  => System.Null_Address,
                   Top   => 0);
   begin
      R (0).Id := T;
      R (0).Data := M;
      R (0).Data.Base := System.Storage_Elements.To_Address (42);
      Set_Mark (T, M, R);
   end Set_Mark_Invalid_Stack;

   procedure Alloc_Stack_With_Null_Ptr
   is
      Ptr : System.Address;
   begin
      Alloc_Success := False;
      Ptr := Allocate_Stack (Valid_Thread, 0);
   end Alloc_Stack_With_Null_Ptr;

   procedure Alloc_Stack_With_Invalid_Thread
   is
      Ptr : System.Address;
   begin
      Alloc_Success := True;
      Ptr := Allocate_Stack (Invalid_Thread, 0);
   end Alloc_Stack_With_Invalid_Thread;

   procedure S_Allocate_Stack_Overflow_1
   is
      T : Thread := Valid_Thread;
      Reg : Registry := Null_Registry;
      Stack_Ptr : System.Address;
   begin
      S_Allocate (Stack_Ptr, Secondary_Stack_Size * 2, Reg, T);
   end S_Allocate_Stack_Overflow_1;

   procedure S_Allocate_Stack_Overflow_2
   is
      T : Thread := Valid_Thread;
      Reg : Registry := Null_Registry;
      Stack_Ptr : System.Address;
   begin
      for I in 0 .. 1024 loop
         S_Allocate (Stack_Ptr, SSE.Storage_Offset (1024), Reg, T);
      end loop;
   end S_Allocate_Stack_Overflow_2;

   procedure S_Release_High_Mark
   is
      T : Thread := Valid_Thread;
      Reg : Registry := Null_Registry;
      Mark_Id : SSE.Storage_Count;
      Mark_Base : System.Address;
      Stack_Ptr : System.Address;
   begin
      S_Allocate (Stack_Ptr, 8, Reg, T);
      S_Mark (Mark_Base, Mark_Id, Reg, T);
      S_Release (Mark_Base, Mark_Id + 1, Reg, T);
   end S_Release_High_Mark;

   -------------------
   -- Test routines --
   -------------------

   procedure Test_Get_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      T1 : Thread := Thread (System.Storage_Elements.To_Address (1));
      T2 : Thread := Thread (System.Storage_Elements.To_Address (2));
      Reg : Registry := Null_Registry;
      Test_Mark : Mark;
      T1_Mark : Mark := (Base => System.Null_Address,
                         Top   => 0);
      T2_Mark : Mark := (Base => System.Storage_Elements.To_Address (42),
                         Top   => 4);
   begin
      Alloc_Success := True;
      AUnit.Assertions.Assert_Exception (Get_Mark_Invalid_Thread'Access,
                                         "Get mark with invalid thread failed");
      AUnit.Assertions.Assert_Exception (Get_Mark_Full_Registry'Access,
                                         "Get mark with full registry failed");

      Get_Mark (T1, Reg, Test_Mark);
      AUnit.Assertions.Assert (Test_Mark.Base /= System.Null_Address,
                               "Stack not initialized");
      AUnit.Assertions.Assert (Test_Mark.Top = 0,
                               "Top not null after initialization");

      Get_Mark (T1, Reg, T1_Mark);
      AUnit.Assertions.Assert (Test_Mark = T1_Mark,
                               "Failed to get T1 mark");

      Reg (2).Id := T2;
      Reg (2).Data := T2_Mark;

      Get_Mark (T2, Reg, Test_Mark);
      AUnit.Assertions.Assert (Test_Mark = T2_Mark,
                               "Failed to get T2 mark");
   end Test_Get_Mark;

   procedure Test_Set_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Reg : Registry := Null_Registry;
      E1 : Mark;
      E2 : Mark;
      Td   : Thread := Valid_Thread;
   begin
      AUnit.Assertions.Assert_Exception (Set_Mark_Unknown_Thread'Access,
                                         "Set mark on unknown thread failed");
      AUnit.Assertions.Assert_Exception (Set_Mark_Invalid_Thread'Access,
                                         "Set mark on invalid thread failed");
      AUnit.Assertions.Assert_Exception (Set_Mark_Invalid_Stack'Access,
                                         "Set mark on invalid stack failed");

      Get_Mark (Td, Reg, E1);
      E1.Top := 42;
      Set_Mark (Td, E1, Reg);
      Get_Mark (Td, Reg, E2);
      AUnit.Assertions.Assert (E1 = E2,
                               "Storing mark failed");
   end Test_Set_Mark;

   procedure Test_Allocate_Stack (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Alloc_Success := True;
      AUnit.Assertions.Assert (Allocate_Stack (Valid_Thread, 0) /= System.Null_Address,
                               "Allocate stack failed");
      AUnit.Assertions.Assert_Exception (Alloc_Stack_With_Null_Ptr'Access,
                                         "Allocate stack with null failed");
      AUnit.Assertions.Assert_Exception (Alloc_Stack_With_Invalid_Thread'Access,
                                         "Allocate stack with invalid thread failed");
   end Test_Allocate_Stack;

   procedure Test_S_Allocate (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Reg : Registry := Null_Registry;
      M : Mark;
      Vt : Thread := Valid_Thread;
      Stack_Base : System.Address;
      Stack_Ptr  : System.Address;
   begin
      Alloc_Success := True;

      Get_Mark (Vt, Reg, M);
      AUnit.Assertions.Assert (M.Base /= System.Null_Address,
                               "Base allocation failed");
      AUnit.Assertions.Assert (M.Top = 0,
                               "Top not initialized with 0");

      Stack_Base := M.Base;
      S_Allocate (Stack_Ptr, 8, Reg, Vt);
      AUnit.Assertions.Assert (Stack_Base - 8 = Stack_Ptr,
                        "Invalid base move");
      Get_Mark (Vt, Reg, M);
      AUnit.Assertions.Assert (M.Top = 8,
                               "Unmodified top");

      S_Allocate (Stack_Ptr, 8, Reg, Vt);
      AUnit.Assertions.Assert (Stack_Base - 16 = Stack_Ptr,
                               "Invalid stack ptr");
      Get_Mark (Vt, Reg, M);
      AUnit.Assertions.Assert (M.Top = 16,
                               "Invalid top");

      Reg := Null_Registry;
      S_Allocate (Stack_Ptr, 8, Reg, Vt);
      Get_Mark (Vt, Reg, M);

      AUnit.Assertions.Assert (Stack_Ptr /= System.Null_Address,
                              "Initial Base allocation failed");
      AUnit.Assertions.Assert (M.Base - 8 = Stack_Ptr,
                               "Invalid Stack initialization");
      AUnit.Assertions.Assert (M.Top = 8,
                               "Top not set correctly");

      AUnit.Assertions.Assert_Exception (S_Allocate_Stack_Overflow_1'Access,
                                         "Failed to detect stack overflow 1");
      AUnit.Assertions.Assert_Exception (S_Allocate_Stack_Overflow_2'Access,
                                         "Failed to detect stack overflow 2");
   end Test_S_Allocate;

   procedure Test_S_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Reg : Registry := Null_Registry;
      M : Mark;
      S_Addr : System.Address;
      S_Pos : SSE.Storage_Count;
      Vt : Thread := Valid_Thread;
      Stack_Ptr : System.Address;
   begin
      S_Allocate (Stack_Ptr, 8, Reg, Vt);
      S_Mark (S_Addr, S_Pos, Reg, Vt);
      Get_Mark (Vt, Reg, M);
      AUnit.Assertions.Assert (S_Pos = M.Top and S_Pos = 8 and S_Addr = M.Base,
                               "Invalid mark location");

      Reg := Null_Registry;
      S_Mark (S_Addr, S_Pos, Reg, Vt);
      Get_Mark (Vt, Reg, M);
      AUnit.Assertions.Assert (S_Addr = M.Base,
                               "Mark did not initialize stack");
      AUnit.Assertions.Assert (M.Top = 0 and S_Pos = 0,
                               "Mark did not initialize top");
   end Test_S_Mark;

   procedure Test_S_Release (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Reg : Registry := Null_Registry;
      M : Mark;
      Stack_Ptr : System.Address;
      Mark_Id : System.Address;
      Mark_Pos : SSE.Storage_Count;
      Vt        : Thread := Valid_Thread;
   begin
      AUnit.Assertions.Assert_Exception (S_Release_High_Mark'Access,
                                         "Invalid stack release");

      S_Allocate (Stack_Ptr, 8, Reg, Vt);
      S_Mark (Mark_Id, Mark_Pos, Reg, Vt);
      S_Allocate (Stack_Ptr, 4, Reg, Vt);
      S_Allocate (Stack_Ptr, 4, Reg, Vt);
      Get_Mark (Vt, Reg, M);

      AUnit.Assertions.Assert (M.Top = 16,
                               "Top not initialized correctly");
      AUnit.Assertions.Assert (Stack_Ptr /= Mark_Id - Mark_Pos,
                               "Mark not set correctly");

      S_Release (Mark_Id, Mark_Pos, Reg, Vt);
      Get_Mark (Vt, Reg, M);
      AUnit.Assertions.Assert (M.Top = 8,
                               "Top not reset correctly");
      AUnit.Assertions.Assert (M.Top = Mark_Pos,
                               "Invalid mark id");
      S_Allocate (Stack_Ptr, 8, Reg, Vt);
      AUnit.Assertions.Assert (Mark_Id - Mark_Pos = Stack_Ptr + 8,
                               "Invalid stack ptr location");
   end Test_S_Release;

   procedure Test_C_Alloc (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
   begin
      Alloc_Success := True;
      AUnit.Assertions.Assert (C_Alloc (Invalid_Thread, 0) /= System.Null_Address,
                               "Alloc test failed");
      Alloc_Success := False;
      AUnit.Assertions.Assert (C_Alloc (Invalid_Thread, 0) = System.Null_Address,
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
