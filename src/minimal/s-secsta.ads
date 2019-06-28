--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System.Parameters;
with System.Storage_Elements;
with Componolit.Runtime.Secondary_Stack;

package System.Secondary_Stack is

   package SP renames System.Parameters;
   package SSE renames System.Storage_Elements;
   package CRS renames Componolit.Runtime.Secondary_Stack;

   type SS_Stack (Size : SP.Size_Type) is private;

   type Mark_Id is private;

   procedure SS_Allocate (Address      : out SSE.Integer_Address;
                          Storage_Size :     SSE.Storage_Count);

   function SS_Mark return Mark_Id;

   procedure SS_Release (M : Mark_Id);

private

   SS_Pool : Integer;

   subtype SS_Ptr is SP.Size_Type;

   type Memory is array (SS_Ptr range <>) of SSE.Storage_Element;
   for Memory'Alignment use Standard'Maximum_Alignment;

   type SS_Stack (Size : SP.Size_Type) is record
      Stack_Space : Memory (1 .. Size);
   end record;

   type Mark_Id is record
      Sstk : SSE.Integer_Address;
      Sptr : SSE.Integer_Address;
   end record;

   Stack_Size : SP.Size_Type with
      Export,
      Convention => Ada,
      External_Name => "__gnat_default_ss_size";

   Stack_Count : Natural with
      Export,
      Convention => Ada,
      External_Name => "__gnat_binder_ss_count";

   Stack_Pool_Address : System.Address with
      Export,
      Convention => Ada,
      External_Name => "__gnat_default_ss_pool";

   Stack_Mark : CRS.Mark;

end System.Secondary_Stack;
