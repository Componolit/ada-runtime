--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Interfaces;

package Componolit.Runtime.Conversions with
SPARK_Mode
is
   pragma Pure;

   use type Interfaces.Integer_64;
   use type Interfaces.Unsigned_64;

   subtype Int64 is Interfaces.Integer_64;
   subtype Uns64 is Interfaces.Unsigned_64;

   function "abs" (X : Int64) return Uns64 is
     (if X = Int64'First then 2**63 else Uns64 (Int64'(abs X)));
   --  Convert absolute value of X to unsigned. Note that we can't just use
   --  the expression of the Else, because it overflows for X = Int64'First.

   function To_Int (U : Uns64) return Int64 with
      Inline,
      Annotate => (GNATprove, Terminating),
      Contract_Cases => (U <= Uns64 (Int64'Last) =>
                               To_Int'Result = Int64 (U),
                         U > Uns64 (Int64'Last) =>
                               To_Int'Result = -Int64 (Uns64'Last - U) - 1);

   function To_Uns (I : Int64) return Uns64 with
      Inline,
      Annotate => (GNATprove, Terminating),
      Contract_Cases => (I >= 0 => To_Uns'Result = Uns64 (I),
                         I < 0 => To_Uns'Result =
                            Uns64'Last - (abs (I) - Uns64'(1)));

   procedure Lemma_Identity (I : Int64; U : Uns64) with
      --  Ghost, --  This should be Ghost but the FSF GNAT crashes here
      Post => I = To_Int (To_Uns (I))
              and U = To_Uns (To_Int (U));

   procedure Lemma_Uns_Associativity_Add (X, Y : Int64) with
      --  Ghost, --  This should be Ghost but the FSF GNAT crashes here
      Pre      => (if X < 0 and Y <= 0 then Int64'First - X < Y)
                  and (if X >= 0 and Y >= 0 then Int64'Last - X >= Y),
      Post     => X + Y = To_Int (To_Uns (X) + To_Uns (Y));

   procedure Lemma_Uns_Associativity_Sub (X, Y : Int64) with
      --  Ghost, --  This should be Ghost but the FSF GNAT crashes here
      Pre      => (if X >= 0 and Y <= 0 then Y > Int64'First
                      and then Int64'Last - X >= abs (Y))
                   and (if X < 0 and Y > 0 then Y < Int64'First - X),
      Post     => X - Y = To_Int (To_Uns (X) - To_Uns (Y));

end Componolit.Runtime.Conversions;
