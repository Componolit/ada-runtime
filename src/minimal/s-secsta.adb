--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Componolit.Runtime.Platform;

package body System.Secondary_Stack with
   SPARK_Mode,
   Refined_State => (Stack_State  => Stack,
                     Binder_State => (Stack_Size,
                                      Stack_Count,
                                      Stack_Pool_Address,
                                      SS_Pool))
is

   procedure SS_Allocate (Address      : out SSE.Integer_Address;
                          Storage_Size :     SSE.Storage_Count)
   is
   begin
      if Sufficient_Stack_Space (Storage_Size) then
         Stack.Top := Stack.Top + Storage_Size;
         Address   := Stack.Base - SSE.Integer_Address (Stack.Top);
      else
         Componolit.Runtime.Platform.Terminate_Message
            ("Secondary stack overflowed");
      end if;
   end SS_Allocate;

   function SS_Mark return Mark_Id
   is
   begin
      return Mark_Id'(Sstk => Stack.Base,
                      Sptr => SSE.Integer_Address (Stack.Top));
   end SS_Mark;

   procedure SS_Release (M : Mark_Id)
   is
   begin
      if SSE.Storage_Count (M.Sptr) > Stack.Top or M.Sstk /= Stack.Base
      then
         Componolit.Runtime.Platform.Terminate_Message
            ("Secondary stack underflowed");
      end if;
      Stack.Top := SSE.Storage_Count (M.Sptr);
   end SS_Release;

begin
   if Stack_Count = 1 then
      Stack.Base :=
         SSE.To_Integer (Stack_Pool_Address)
         + SSE.Integer_Address (Stack_Size);
   else
      Componolit.Runtime.Platform.Terminate_Message
         ("Invalid secondary stack count");
   end if;
end System.Secondary_Stack;
