with Aunit.Assertions;
with System;
with System.Storage_Elements;
with Ada.Text_IO;

package body Componolit.Runtime.Secondary_Stack.Tests is

   package SSE renames System.Storage_Elements;
   Alloc_Success : Boolean := False;
   Valid_Stack : SSE.Integer_Address := 16#ffffffff#;

   ---------------------------
   -- Test helper functions --
   ---------------------------

   procedure C_Alloc (Size    :     SSE.Storage_Count;
                      Address : out SSE.Integer_Address)
     with
       Export,
       Convention => C,
       External_Name => "componolit_runtime_allocate_secondary_stack";

   procedure C_Alloc (Size    :     SSE.Storage_Count;
                      Address : out SSE.Integer_Address)
   is
   begin
      if Alloc_Success then
         Address := Valid_Stack;
      else
         Address := Null_Address;
      end if;
   end C_Alloc;

   function Strlen (S : System.Address) return Integer
   is
      Ptr : SSE.Integer_Address := SSE.To_Integer (S);
   begin
      loop
         declare
            C : Character with Address => SSE.To_Address (Ptr);
         begin
            exit when C = Character'First;
            Ptr := Ptr + 1;
         end;
      end loop;
      return Integer (Ptr - SSE.To_Integer (S));
   end Strlen;

   procedure Log_Debug (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_debug";

   procedure Log_Warning (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_warning";

   procedure Log_Error (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_error";

   procedure Log_Debug (S : System.Address)
   is
      Msg : String (1 .. Strlen (S)) with Address => S;
   begin
      Ada.Text_IO.Put_Line ("Info: " & Msg);
   end Log_Debug;

   procedure Log_Warning (S : System.Address)
   is
      Msg : String (1 .. Strlen (S)) with Address => S;
   begin
      Ada.Text_IO.Put_Line ("Warning: " & Msg);
   end Log_Warning;

   procedure Log_Error (S : System.Address)
   is
      Msg : String (1 .. Strlen (S)) with Address => S;
   begin
      Ada.Text_IO.Put_Line ("Error: " & Msg);
   end Log_Error;

   procedure Raise_Ada_Exception (T : Integer;
                                  N : System.Address;
                                  M : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_raise_ada_exception";

   procedure Raise_Ada_Exception (T : Integer;
                                  N : System.Address;
                                  M : System.Address)
   is
   begin
      raise Program_Error;
   end Raise_Ada_Exception;

   -------------------
   -- Test routines --
   -------------------

   procedure Test_Check_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Test_Mark : Mark := (Base => Null_Address,
                           Top  => 0);
      T1_Mark : Mark;
   begin
      Alloc_Success := True;
      Check_Mark (Test_Mark);
      AUnit.Assertions.Assert (Test_Mark.Base /= Null_Address,
                               "Stack not initialized");
      AUnit.Assertions.Assert (Test_Mark.Top = 0,
                               "Top not null after initialization");
      T1_Mark := Test_Mark;
      Check_Mark (Test_Mark);
      AUnit.Assertions.Assert (Test_Mark = T1_Mark,
                               "Initialized mark altered in check");
   end Test_Check_Mark;

   procedure Test_S_Allocate (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      M : Mark := Null_Mark;
      Stack_Base : SSE.Integer_Address;
      Stack_Ptr  : SSE.Integer_Address;
   begin
      Alloc_Success := True;

      Check_Mark (M);
      AUnit.Assertions.Assert (M.Base /= Null_Address,
                               "Base allocation failed");
      AUnit.Assertions.Assert (M.Top = 0,
                               "Top not initialized with 0");

      Stack_Base := M.Base;
      S_Allocate (M, Stack_Ptr, 8);
      AUnit.Assertions.Assert (Stack_Base - 8 = Stack_Ptr,
                        "Invalid base move");
      AUnit.Assertions.Assert (M.Top = 8,
                               "Unmodified top");

      S_Allocate (M, Stack_Ptr, 8);
      AUnit.Assertions.Assert (Stack_Base - 16 = Stack_Ptr,
                               "Invalid stack ptr");
      AUnit.Assertions.Assert (M.Top = 16,
                               "Invalid top");

   end Test_S_Allocate;

   procedure Test_S_Mark (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      M : Mark := Null_Mark;
      S_Addr : SSE.Integer_Address;
      S_Pos : SSE.Storage_Count;
      Stack_Ptr : SSE.Integer_Address;
   begin
      S_Allocate (M, Stack_Ptr, 8);
      S_Mark (M, S_Addr, S_Pos);
      AUnit.Assertions.Assert (S_Pos = M.Top and S_Pos = 8 and S_Addr = M.Base,
                               "Invalid mark location");
   end Test_S_Mark;

   procedure Test_S_Release (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      M : Mark := Null_Mark;
      Stack_Ptr : SSE.Integer_Address;
      Mark_Id : SSE.Integer_Address;
      Mark_Pos : SSE.Storage_Count;
   begin
      S_Allocate (M, Stack_Ptr, 8);
      S_Mark (M, Mark_Id, Mark_Pos);
      S_Allocate (M, Stack_Ptr, 4);
      S_Allocate (M, Stack_Ptr, 4);

      AUnit.Assertions.Assert (M.Top = 16,
                               "Top not initialized correctly");
      AUnit.Assertions.Assert (Stack_Ptr /= Mark_Id - SSE.Integer_Address (Mark_Pos),
                               "Mark not set correctly");
      S_Release (M, Mark_Id, Mark_Pos);
      AUnit.Assertions.Assert (M.Top = 8,
                               "Top not reset correctly");
      AUnit.Assertions.Assert (M.Top = Mark_Pos,
                               "Invalid mark id");
      S_Allocate (M, Stack_Ptr, 8);
      AUnit.Assertions.Assert (Mark_Id - SSE.Integer_Address (Mark_Pos) = Stack_Ptr + 8,
                               "Invalid stack ptr location");
   end Test_S_Release;

   procedure Test_C_Alloc (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Address : SSE.Integer_Address;
   begin
      Alloc_Success := True;
      C_Alloc (0, Address);
      AUnit.Assertions.Assert (Address /= Null_Address,
                               "Alloc test failed");
      Alloc_Success := False;
      C_Alloc (0, Address);
      AUnit.Assertions.Assert (Address = Null_Address,
                               "Null Address test failed");
   end Test_C_Alloc;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Check_Mark'Access, "Test Check_Mark");
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
      return Aunit.Format ("Componolit.Runtime.Secondary_Stack");
   end Name;

end Componolit.Runtime.Secondary_Stack.Tests;
