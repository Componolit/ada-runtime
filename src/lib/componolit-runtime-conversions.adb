
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

   procedure Lemma_Uns_Associativity_Add (X, Y : Int64)
   is
   begin
      if X < 0 and Y < 0 then
         if X = Int64'First and Y = Int64'First then
            pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
         elsif X = Int64'First then
            pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
         elsif Y = Int64'First then
            pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
         else
            declare
               Sum_Int : constant Int64 :=
                  To_Int (To_Uns (X)) + To_Int (To_Uns (Y));
               Sum_Uns : constant Int64 := To_Int (To_Uns (X) + To_Uns (Y));
            begin
               pragma Assert (To_Uns (X) = -Uns64 (-X));
               pragma Assert (To_Uns (Y) = -Uns64 (-Y));
               pragma Assert (-Uns64 (-X) - Uns64 (-Y) = -Uns64 (-X - Y));
               pragma Assert (-Uns64 (-X - Y) > Uns64 (Int64'Last));
               pragma Assert (Sum_Uns = To_Int (-Uns64 (-X) - Uns64 (-Y)));
               pragma Assert (Sum_Uns = To_Int (-Uns64 (-X - Y)));
               pragma Assert (Sum_Uns = -Int64 (Uns64'Last +
                                                Uns64 (-X - Y)) - 1);
               pragma Assert (Uns64'Last + Uns64 (-X - Y) =
                                 Uns64 (-X - Y - 1));
               pragma Assert (Sum_Uns = -Int64 (-X - Y - 1) - 1);
               pragma Assert (Sum_Uns = X + Y);
               pragma Assert (Sum_Int = Sum_Uns);
            end;
         end if;
      elsif X >= 0 and Y >= 0 then
         pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
      elsif X >= 0 and Y < 0 then
         if Y = Int64'First then
            pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
         else
            declare
               Sum_Int : constant Int64 :=
                  To_Int (To_Uns (X)) + To_Int (To_Uns (Y));
               Sum_Uns : constant Int64 := To_Int (To_Uns (X) + To_Uns (Y));
            begin
               pragma Assert (To_Uns (Y) = -Uns64 (-Y));
               pragma Assert (To_Uns (X) = Uns64 (X));
               pragma Assert (Sum_Uns = To_Int (Uns64 (X) - Uns64 (-Y)));
               pragma Assert (Sum_Int = Sum_Uns);
               pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
            end;
         end if;
      elsif X < 0 and Y >= 0 then
         if X = Int64'First then
            pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
         else
            declare
               Sum_Int : constant Int64 :=
                  To_Int (To_Uns (Y)) + To_Int (To_Uns (X));
               Sum_Uns : constant Int64 := To_Int (To_Uns (Y) + To_Uns (X));
            begin
               pragma Assert (To_Uns (X) = -Uns64 (-X));
               pragma Assert (To_Uns (Y) = Uns64 (Y));
               pragma Assert (Sum_Uns = To_Int (Uns64 (Y) - Uns64 (-X)));
               pragma Assert (To_Uns (X) + To_Uns (Y) =
                                 To_Uns (Y) + To_Uns (X));
               pragma Assert (To_Int (To_Uns (Y)) + To_Int (To_Uns (X)) =
                                 To_Int (To_Uns (Y) + To_Uns (X)));
               pragma Assert (Sum_Int = Sum_Uns);
               pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
            end;
         end if;
      else
         pragma Assert (X + Y = To_Int (To_Uns (X) + To_Uns (Y)));
      end if;
   end Lemma_Uns_Associativity_Add;

   procedure Lemma_Uns_Associativity_Sub (X, Y : Int64) is null;

end Componolit.Runtime.Conversions;
