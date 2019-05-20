--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System;
with System.Storage_Elements;
use all type System.Address;
use all type System.Storage_Elements.Storage_Offset;

package Ss_Utils
  with SPARK_Mode
is

   package SSE renames System.Storage_Elements;

   type Mark is
      record
         Base  : System.Address;
         Top   : SSE.Storage_Count;
      end record;

   Secondary_Stack_Size : constant SSE.Storage_Count := 768 * 1024;

   procedure Get_Mark (E               : out Mark)
     with
       Post => (E.Base /= System.Null_Address);

   procedure Set_Mark (M               : Mark)
     with
       Pre => M.Base /= System.Null_Address;

   function Allocate_Stack (
                            Size : SSE.Storage_Count
                           ) return System.Address
     with
       Post => Allocate_Stack'Result /= System.Null_Address;

   procedure S_Allocate (Address      : out System.Address;
                         Storage_Size : SSE.Storage_Count);

   procedure S_Mark (Stack_Base : out System.Address;
                     Stack_Ptr  : out SSE.Storage_Count);

   procedure S_Release (Stack_Base : System.Address;
                        Stack_Ptr  : SSE.Storage_Count);

   function C_Alloc (Size : SSE.Storage_Count) return System.Address
     with
       Import,
       Convention => C,
       External_Name => "allocate_secondary_stack",
       Post => C_Alloc'Result /= System.Null_Address,
       Global => null;

private

   Secondary_Stack_Mark : Mark := (Base => System.Null_Address, Top => 0);

end Ss_Utils;
