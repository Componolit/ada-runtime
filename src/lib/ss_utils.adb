package body Ss_Utils
  with SPARK_Mode
is

   procedure Get_Mark (T               : Thread;
                       Thread_Registry : in out Registry;
                       M               : out Mark)
   is
      Thread_Entry     : Registry_Index := Invalid_Index;
      First_Free_Entry : Registry_Index := Invalid_Index;
   begin

      Search :
      for E in Thread_Registry'Range loop
         pragma Loop_Invariant
           ((if First_Free_Entry = Invalid_Index then
                (for Some F of Thread_Registry (E .. Thread_Registry'Last) =>
                       F.Id = Invalid_Thread)));
         pragma Loop_Invariant (Thread_Entry = Invalid_Index);

         if First_Free_Entry = Invalid_Index and then
           Thread_Registry (E).Id = Invalid_Thread
         then
            First_Free_Entry := E;
         end if;

         if T = Thread_Registry (E).Id then
            Thread_Entry := E;
            exit Search;
         end if;
      end loop Search;

      pragma Assert
        (if Thread_Entry = Invalid_Index then
            First_Free_Entry /= Invalid_Index);

      if Thread_Entry = Invalid_Index then
         if First_Free_Entry /= Invalid_Index then
            Thread_Registry (First_Free_Entry).Id := T;
            Thread_Registry (First_Free_Entry).Data := Invalid_Mark;
            Thread_Entry := First_Free_Entry;
         else
            raise Constraint_Error;
         end if;
      end if;

      if Thread_Registry (Thread_Entry).Data.Base = System.Null_Address then
         Thread_Registry (Thread_Entry).Data :=
           (Base  => Allocate_Stack (T, Secondary_Stack_Size),
            Top   => 0);
      end if;

      M := Thread_Registry (Thread_Entry).Data;
   end Get_Mark;

   function Get_Mark (T               : Thread;
                      Thread_Registry : Registry) return Mark
   is
      M : Mark := Invalid_Mark;
   begin
      Search:
      for E in Thread_Registry'Range loop
         pragma Loop_Invariant (for Some F of Thread_Registry
                                (E .. Thread_Registry'Last) => F.Id = T);
         if Thread_Registry (E).Id = T then
            M := Thread_Registry (E).Data;
            exit Search;
         end if;
      end loop Search;
      pragma Assert (M.Base /= System.Null_Address);
      return M;
   end Get_Mark;

   procedure Set_Mark (T               : Thread;
                       M               : Mark;
                       Thread_Registry : in out Registry)
   is
      Thread_Entry : Registry_Index := Invalid_Index;
   begin
      if T = Invalid_Thread then
         raise Constraint_Error;
      end if;
      if M.Base = System.Null_Address then
         raise Constraint_Error;
      end if;



      Search :
      for E in Thread_Registry'Range loop
         pragma Loop_Invariant
           (for Some F of Thread_Registry (E .. Thread_Registry'Last) =>
                F.Id = T);
         if T = Thread_Registry (E).Id then
            Thread_Entry := E;
            exit Search;
         end if;
      end loop Search;

      if Thread_Entry = Invalid_Index then
         raise Constraint_Error;
      end if;

      Thread_Registry (Thread_Entry).Data := M;
   end Set_Mark;

   function Allocate_Stack (T    : Thread;
                            Size : SSE.Storage_Count) return System.Address
   is
      Stack : System.Address;
   begin
      if T = Invalid_Thread then
         raise Constraint_Error;
      end if;
      Stack := C_Alloc (T, Size);
      if Stack = System.Null_Address then
         raise Storage_Error;
      end if;
      return Stack;
   end Allocate_Stack;

   procedure S_Allocate (Address      : out System.Address;
                         Storage_Size : SSE.Storage_Count;
                         Reg          : in out Registry;
                         T            : Thread)
   is
      M         : Mark;
   begin
      Get_Mark (T, Reg, M);
      if M.Top < Secondary_Stack_Size and then
        Storage_Size < Secondary_Stack_Size and then
        Storage_Size + M.Top < Secondary_Stack_Size
      then
         M.Top := M.Top + Storage_Size;
         Address := M.Base - M.Top;
      else
         raise Storage_Error;
      end if;

      Set_Mark (T, M, Reg);
   end S_Allocate;

   procedure S_Mark (Stack_Base : out System.Address;
                     Stack_Ptr  : out SSE.Storage_Count;
                     Reg        : in out Registry;
                     T          : Thread)
   is
      M : Mark;
   begin
      Get_Mark (T, Reg, M);

      Stack_Base := M.Base;
      Stack_Ptr := M.Top;
   end S_Mark;

   procedure S_Release (Stack_Base : System.Address;
                        Stack_Ptr  : SSE.Storage_Count;
                        Reg        : in out Registry;
                        T          : Thread)
   is
      LM : Mark;
   begin
      Get_Mark (T, Reg, LM);

      if Stack_Ptr > LM.Top or Stack_Base /= LM.Base
      then
         raise Program_Error;
      end if;

      LM.Top := Stack_Ptr;

      Set_Mark (T, LM, Reg);
   end S_Release;

end Ss_Utils;
