--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Componolit.Runtime.Platform;

package body System.Secondary_Stack is

   procedure SS_Allocate (Address      : out SSE.Integer_Address;
                          Storage_Size :     SSE.Storage_Count)
   is
   begin
      CRS.S_Allocate (Stack_Mark, Address, Storage_Size);
   end SS_Allocate;

   function SS_Mark return Mark_Id
   is
      M : Mark_Id;
   begin
      CRS.S_Mark (Stack_Mark, M.Sstk, SSE.Storage_Count (M.Sptr));
      return M;
   end SS_Mark;

   procedure SS_Release (M : Mark_Id)
   is
   begin
      CRS.S_Release (Stack_Mark, M.Sstk, SSE.Storage_Count (M.Sptr));
   end SS_Release;

   use type SSE.Integer_Address;
begin
   if Stack_Count = 1 then
      Stack_Mark.Base :=
         SSE.To_Integer (Stack_Pool_Address)
         + SSE.Integer_Address (Stack_Size);
   else
      Componolit.Runtime.Platform.Terminate_Message
         ("Invalid secondary stack count");
   end if;
   CRS.Secondary_Stack_Size := SSE.Storage_Count (Stack_Size);
end System.Secondary_Stack;
