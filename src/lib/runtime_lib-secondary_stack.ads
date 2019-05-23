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

package Runtime_Lib.Secondary_Stack
  with SPARK_Mode
is
   package SSE renames System.Storage_Elements;
   use type SSE.Integer_Address;
   use type System.Storage_Elements.Storage_Offset;

   type Mark is record
      Base  : SSE.Integer_Address;
      Top   : SSE.Storage_Count;
   end record;

   Null_Address : constant SSE.Integer_Address := 0;
   Null_Mark    : constant Mark := (Base => Null_Address, Top => 0);

   Secondary_Stack_Size : constant SSE.Storage_Count := 768 * 1024;

   procedure Check_Mark (E : in out Mark) with
      Contract_Cases => (E.Base = Null_Address =>
                            (E.Base /= Null_Address
                             and E.Top = 0),
                         E.Base /= Null_Address =>
                            (E.Base = E.Base'Old
                             and E.Top = E.Top'Old));

   procedure S_Allocate (Stack_Mark   : in out Mark;
                         Address      :    out SSE.Integer_Address;
                         Storage_Size :        SSE.Storage_Count) with
      Pre  => Stack_Mark.Top < Secondary_Stack_Size
              and then Storage_Size < Secondary_Stack_Size
              and then Storage_Size + Stack_Mark.Top < Secondary_Stack_Size
              and then SSE.Integer_Address (Storage_Size + Stack_Mark.Top)
                       < Stack_Mark.Base,
      Post => Stack_Mark.Base /= Null_Address and Address /= Null_Address;

   procedure S_Mark (Stack_Mark : in out Mark;
                     Stack_Base :    out SSE.Integer_Address;
                     Stack_Ptr  :    out SSE.Storage_Count) with
      Post => Stack_Mark.Base /= Null_Address
              and Stack_Base /= Null_Address
              and Stack_Base = Stack_Mark.Base;

   procedure S_Release (Stack_Mark : in out Mark;
                        Stack_Base :        SSE.Integer_Address;
                        Stack_Ptr  :        SSE.Storage_Count) with
      Pre  => Stack_Base /= Null_Address
              and then Stack_Mark.Base = Stack_Base
              and then Stack_Ptr <= Stack_Mark.Top,
      Post => Stack_Mark.Base /= Null_Address;

   procedure C_Alloc (Size    :     SSE.Storage_Count;
                      Address : out SSE.Integer_Address) with
      Import,
      Convention => C,
      External_Name => "allocate_secondary_stack",
      Post => Address /= Null_Address,
      Global => null;

end Runtime_Lib.Secondary_Stack;
