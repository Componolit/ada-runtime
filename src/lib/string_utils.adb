--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body String_Utils
with SPARK_Mode
is

   ------------
   -- Length --
   ------------

   function Length (C_Str      : System.Address;
                    Max_Length : Natural := Natural'Last) return Integer
   is
      L    : Integer := 0;
      Ptr  : Pointer := To_Pointer (C_Str);
      Char : Character;
   begin
      if Ptr /= Null_Pointer and Ptr < Pointer'Last then
         Char := Get_Char (Ptr);
         while
           Char /= Character'Val (0) and
           L < Max_Length and
           Ptr + 1 < Pointer'Last and
           Ptr < Pointer'Last
         loop
            pragma Loop_Invariant (Ptr /= Null_Pointer and L >= 0);
            pragma Loop_Variant (Increases => L);
            Ptr := Incr (Ptr);
            Char := Get_Char (Ptr);
            L := L + 1;
         end loop;
      end if;
      return L;
   end Length;

   --------------------
   -- Convert_To_Ada --
   --------------------

   function Convert_To_Ada (C_Str      : System.Address;
                            Default    : String;
                            Max_Length : Natural := Natural'Last) return String
   is
      L   : constant Integer := Length (C_Str, Max_Length);
      Str : String (1 .. L) := (others => ' ');
      Cursor : Pointer := To_Pointer (C_Str);
   begin
      if L > 0 then
         for C in Str'Range loop
            pragma Loop_Invariant (Cursor /= Null_Pointer);
            Str (C) := Get_Char (Cursor);
            exit when Cursor = Pointer'Last;
            Cursor := Incr (Cursor);
         end loop;
         return Str;
      else
         return Default;
      end if;
   end Convert_To_Ada;

   --------------
   -- Get_Char --
   --------------

   function Get_Char (Ptr : Pointer) return Character
     with SPARK_Mode => Off
   is
      Char : Character
        with Address => To_Address (Ptr);
   begin
      return Char;
   end Get_Char;

   ----------
   -- Incr --
   ----------

   function Incr (Ptr : Pointer) return Pointer
   is
      Next : constant Pointer := Ptr + 1;
   begin
      if Next = Null_Pointer then
         raise Constraint_Error;
      end if;
      return Next;
   end Incr;

   ----------------
   -- To_Address --
   ----------------

   function To_Address (Value : Pointer) return System.Address
     with SPARK_Mode => Off
   is
   begin
      return SSE.To_Address (Value);
   end To_Address;

   ----------------
   -- To_Pointer --
   ----------------

   function To_Pointer (Addr : System.Address) return Pointer
     with SPARK_Mode =>  Off
   is
   begin
      return SSE.To_Integer (Addr);
   end To_Pointer;

end String_Utils;
