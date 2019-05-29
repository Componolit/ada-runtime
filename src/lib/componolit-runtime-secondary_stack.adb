--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Componolit.Runtime.Platform;

package body Componolit.Runtime.Secondary_Stack with
   SPARK_Mode
is

   procedure Check_Mark (E : in out Mark)
   is
   begin
      if E.Base = Null_Address then
         E.Top := 0;
         C_Alloc (Secondary_Stack_Size, E.Base);
      end if;
      if E.Base = Null_Address then
         Componolit.Runtime.Platform.Terminate_Message
            ("Secondary stack allocation failed");
      end if;
   end Check_Mark;

   procedure S_Allocate (Stack_Mark   : in out Mark;
                         Address      :    out SSE.Integer_Address;
                         Storage_Size :        SSE.Storage_Count)
   is
   begin
      Check_Mark (Stack_Mark);

      if
         Stack_Mark.Top < Secondary_Stack_Size
         and then Storage_Size < Secondary_Stack_Size
         and then Storage_Size + Stack_Mark.Top < Secondary_Stack_Size
         and then SSE.Integer_Address (Storage_Size + Stack_Mark.Top)
                  < Stack_Mark.Base
      then
         Stack_Mark.Top := Stack_Mark.Top + Storage_Size;
         Address := Stack_Mark.Base - SSE.Integer_Address (Stack_Mark.Top);
      else
         Componolit.Runtime.Platform.Terminate_Message
            ("Secondary stack overflowed");
      end if;
   end S_Allocate;

   procedure S_Mark (Stack_Mark : in out Mark;
                     Stack_Base :    out SSE.Integer_Address;
                     Stack_Ptr  :    out SSE.Storage_Count)
   is
   begin
      Check_Mark (Stack_Mark);
      Stack_Base := Stack_Mark.Base;
      Stack_Ptr  := Stack_Mark.Top;
   end S_Mark;

   procedure S_Release (Stack_Mark : in out Mark;
                        Stack_Base :        SSE.Integer_Address;
                        Stack_Ptr  :        SSE.Storage_Count)
   is
   begin
      if Stack_Ptr > Stack_Mark.Top or Stack_Base /= Stack_Mark.Base
      then
         Componolit.Runtime.Platform.Terminate_Message
            ("Secondary stack underflowed");
      end if;
      Stack_Mark.Top := Stack_Ptr;
   end S_Release;

end Componolit.Runtime.Secondary_Stack;
