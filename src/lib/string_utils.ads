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
use all type System.Storage_Elements.Integer_Address;

package String_Utils with
   SPARK_Mode
is

   pragma Preelaborate;

   function Length (C_Str      : System.Address;
                    Max_Length : Natural := Natural'Last) return Integer with
      Post => Length'Result <= Max_Length,
      Contract_Cases =>
         (C_Str = System.Null_Address  => Length'Result <= 0,
          C_Str /= System.Null_Address => Length'Result >= 0);
   pragma Annotate (GNATprove, Terminating, Length);

   function Convert_To_Ada (C_Str      : System.Address;
                            Default    : String;
                            Max_Length : Natural := Natural'Last)
                            return String with
      Contract_Cases =>
         (C_Str = System.Null_Address => Convert_To_Ada'Result = Default,
          C_Str /= System.Null_Address => True);
   pragma Annotate (GNATprove, Terminating, Convert_To_Ada);

private

   package SSE renames System.Storage_Elements;

   subtype Pointer is SSE.Integer_Address;

   Null_Pointer : constant Pointer := 0;

   subtype Valid_Pointer is Pointer
     with
       Static_Predicate => Valid_Pointer /= Null_Pointer;

   function Get_Char (Ptr : Valid_Pointer) return Character;
   pragma Annotate (GNATprove, Terminating, Get_Char);

   function Incr (Ptr : Valid_Pointer) return Valid_Pointer with
      Pre => Ptr < Pointer'Last,
      Post => Incr'Result = Ptr + 1;
   pragma Annotate (GNATprove, Terminating, Incr);

   function To_Address (Value : Pointer) return System.Address with
      Inline,
      Contract_Cases =>
         (Value = Null_Pointer  => To_Address'Result = System.Null_Address,
          Value /= Null_Pointer => To_Address'Result /= System.Null_Address);
   pragma Annotate (GNATprove, Terminating, To_Address);

   function To_Pointer (Addr : System.Address) return Pointer with
      Inline,
      Contract_Cases =>
         (Addr = System.Null_Address  => To_Pointer'Result = Null_Pointer,
          Addr /= System.Null_Address => To_Pointer'Result /= Null_Pointer);
   pragma Annotate (GNATprove, Terminating, To_Pointer);

end String_Utils;
