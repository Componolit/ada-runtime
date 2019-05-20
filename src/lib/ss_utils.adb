--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body Ss_Utils with
   SPARK_Mode
is

   procedure Get_Mark (E : out Mark)
   is
   begin
      if Secondary_Stack_Mark.Base = System.Null_Address then
         Secondary_Stack_Mark :=
            (Base => Allocate_Stack (Secondary_Stack_Size),
             Top  => 0);
      end if;
      E := Secondary_Stack_Mark;
   end Get_Mark;

   procedure Set_Mark (M : Mark)
   is
   begin
      if M.Base = System.Null_Address then
         raise Constraint_Error;
      end if;
      Secondary_Stack_Mark := M;
   end Set_Mark;

   function Allocate_Stack (Size : SSE.Storage_Count) return System.Address
   is
      Stack : System.Address;
   begin
      Stack := C_Alloc (Size);
      if Stack = System.Null_Address then
         raise Storage_Error;
      end if;
      return Stack;
   end Allocate_Stack;

   procedure S_Allocate (Address      : out System.Address;
                         Storage_Size : SSE.Storage_Count)
   is
      M         : Mark;
   begin
      Get_Mark (M);
      if M.Top < Secondary_Stack_Size and then
        Storage_Size < Secondary_Stack_Size and then
        Storage_Size + M.Top < Secondary_Stack_Size
      then
         M.Top := M.Top + Storage_Size;
         Address := M.Base - M.Top;
      else
         raise Storage_Error;
      end if;

      Set_Mark (M);
   end S_Allocate;

   procedure S_Mark (Stack_Base : out System.Address;
                     Stack_Ptr  : out SSE.Storage_Count)
   is
      M : Mark;
   begin
      Get_Mark (M);

      Stack_Base := M.Base;
      Stack_Ptr := M.Top;
   end S_Mark;

   procedure S_Release (Stack_Base : System.Address;
                        Stack_Ptr  : SSE.Storage_Count)
   is
      LM : Mark;
   begin
      Get_Mark (LM);

      if Stack_Ptr > LM.Top or Stack_Base /= LM.Base
      then
         raise Program_Error;
      end if;

      LM.Top := Stack_Ptr;

      Set_Mark (LM);
   end S_Release;

end Ss_Utils;
