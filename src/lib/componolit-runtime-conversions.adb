
with Ada.Unchecked_Conversion;

package body Componolit.Runtime.Conversions with
SPARK_Mode
is

   function To_Uns_Unchecked is new Ada.Unchecked_Conversion (Int64, Uns64);
   function To_Int_Unchecked is new Ada.Unchecked_Conversion (Uns64, Int64);

   function To_Int (U : Uns64) return Int64 with
      SPARK_Mode => Off
   is
   begin
      return To_Int_Unchecked (U);
   end To_Int;

   function To_Uns (I : Int64) return Uns64 with
      SPARK_Mode => Off
   is
   begin
      return To_Uns_Unchecked (I);
   end To_Uns;

   procedure Lemma_Identity (I : Int64; U : Uns64) is null;

   procedure Lemma_Uns_Associativity_Add (X, Y : Int64) is null;

   procedure Lemma_Uns_Associativity_Sub (X, Y : Int64) is null;

end Componolit.Runtime.Conversions;
