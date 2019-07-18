with AUnit.Assertions;

package body Componolit.Runtime.Conversions.Tests is

   procedure Test_Uns (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      I_First : constant Uns64 := Uns64 (Int64'Last) + 1;
   begin
      Aunit.Assertions.Assert (Uns64'Last'Img, To_Uns (-1)'Img, "-1 is not Uns64'Last");
      AUnit.Assertions.Assert (Uns64'First'Img, To_Uns (0)'Img, "0 is not Uns64'First");
      Aunit.Assertions.Assert (Uns64 (Int64'Last)'Img, To_Uns (Int64'Last)'Img, "Int64'Last is not Int64'Last");
      AUnit.Assertions.Assert (I_First'Img, To_Uns (Int64'First)'Img, "Int64'First is not Int64'Last + 1");
      Aunit.Assertions.Assert (" 100", To_Uns (100)'Img, "100 is not 100");
      Aunit.Assertions.Assert (" 18446744073709551516", To_Uns (-100)'Img, "100 is not 18446744073709551516");
   end Test_Uns;
   
   procedure Test_Int (T : in out AUnit.Test_Cases.Test_Case'Class)
   is
      I_First  : constant Uns64 := Uns64 (Int64'Last) + 1;
   begin
      AUnit.Assertions.Assert ("-1", To_Int (Uns64'Last)'Img, "Uns64'Last is not -1");
      AUnit.Assertions.Assert (" 0", To_Int (Uns64'First)'Img, "0 is not Uns64'First");
      AUnit.Assertions.Assert (Int64'First'Img, To_Int (I_First)'Img, "Uns64 (Int64'First) is not Int64'First");
      AUnit.Assertions.Assert (Int64'Last'Img, To_Int (Uns64 (Int64'Last))'Img, "Int64'First + 1 is not Int64'Last");
      AUnit.Assertions.Assert ("-100", To_Int (18446744073709551516)'Img, "18446744073709551516 is not -100");
      AUnit.Assertions.Assert (" 100", To_Int (100)'Img, "100 is not 100");
   end Test_Int;
   
   procedure Test_Identity (T : in out AUnit.Test_Cases.Test_Case'Class)
   is
   begin
      for I in Int64 range Int64'First .. Int64'First + 20 loop
         AUnit.Assertions.Assert (I'Img, To_Int (To_Uns (I))'Img, "Int64'First .. Int64'First + 20");
      end loop;
      for I in Int64 range -10 .. 10 loop
         Aunit.Assertions.Assert (I'Img, To_Int (To_Uns (I))'Img, "-10 .. 10");
      end loop;
      for I in Int64 range Int64'Last - 20 .. Int64'Last loop
         AUnit.Assertions.Assert (I'Img, To_Int (To_Uns (I))'Img, "Int64'Last - 20 .. Int64'Last");
      end loop;
      for U in Uns64 range Uns64'First .. Uns64'First + 20 loop
         Aunit.Assertions.Assert (U'Img, To_Uns (To_Int (U))'Img, "Uns64'First .. Uns64'First + 20");
      end loop;
      for U in Uns64 range Uns64 (Int64'Last) - 10 .. Uns64 (Int64'Last) + 10 loop
         AUnit.Assertions.Assert (U'Img, To_Uns (To_Int (U))'Img, "Uns64 (Int64'Last) - 10 .. Uns64 (Int64'Last) + 10");
      end loop;
      for U in Uns64 range Uns64'Last - 10 .. Uns64'Last loop
         AUnit.Assertions.Assert (U'Img, To_Uns (To_Int (U))'Img, "Uns64'Last - 10 .. Uns64'Last");
      end loop;
   end Test_Identity;
   
   procedure Test_Lemma_Add (T : in out AUnit.Test_Cases.Test_Case'Class)
   is
      K          : Int64;
      Test_First : Boolean := False;
      Test_Last  : Boolean := False;
   begin
      for I in Int64 range -10 .. 10 loop
         for J in Int64 range Int64'First + 10 .. Int64'First + 20 loop
            K := I + J;
            if K = Int64'First then
               Test_First := True;
            end if;
            AUnit.Assertions.Assert (K'Img, To_Int (To_Uns (I) + To_Uns (J))'Img, "Int64'First + 10 .. Int64'First + 20");
         end loop;
         for J in Int64 range -10 .. 10 loop
            K := I + J;
            AUnit.Assertions.Assert (K'Img, To_Int (To_Uns (I) + To_Uns (J))'Img, "-10 .. 10");
         end loop;
         for J in Int64 range Int64'Last - 20 .. Int64'Last - 10 loop
            K := I + J;
            if K = Int64'Last then
               Test_Last := True;
            end if;
            Aunit.Assertions.Assert (K'Img, To_Int (To_Uns (I) + To_Uns (J))'Img, "Int64'Last - 20 .. Int64'Last + 10");
         end loop;
      end loop;
      AUnit.Assertions.Assert (Test_First, "Int64'First result not tested");
      AUnit.Assertions.Assert (Test_Last, "Int64'Last result not tested");
   end Test_Lemma_Add;
   
   procedure Test_Lemma_Sub (T : in out AUnit.Test_Cases.Test_Case'Class)
   is
      K          : Int64;
      Test_First : Boolean := False;
      Test_Last  : Boolean := False;
   begin
      for I in Int64 range -10 .. 10 loop
         for J in Int64 range Int64'First + 10 .. Int64'First + 20 loop
            K := J - I;
            if K = Int64'First then
               Test_First := True;
            end if;
            AUnit.Assertions.Assert (K'Img, To_Int (To_Uns (J) - To_Uns (I))'Img, "Int64'First + 10 .. Int64'First + 20");
         end loop;
         for J in Int64 range -10 .. 10 loop
            K := J - I;
            AUnit.Assertions.Assert (K'Img, To_Int (To_Uns (J) - To_Uns (I))'Img, "-10 .. 10");
         end loop;
         for J in Int64 range Int64'Last - 20 .. Int64'Last - 10 loop
            K := J - I;
            if K = Int64'Last then
               Test_Last := True;
            end if;
            Aunit.Assertions.Assert (K'Img, To_Int (To_Uns (J) - To_Uns (I))'Img, "Int64'Last - 20 .. Int64'Last + 10");
         end loop;
      end loop;
      AUnit.Assertions.Assert (Test_First, "Int64'First result not tested");
      AUnit.Assertions.Assert (Test_Last, "Int64'Last result not tested");
   end Test_Lemma_Sub;
   
   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Uns'Access, "Test To_Uns");
      Register_Routine (T, Test_Int'Access, "Test To_Int");
      Register_Routine (T, Test_Identity'Access, "Test Identity");
      Register_Routine (T, Test_Lemma_Add'Access, "Test Add Lemma");
      Register_Routine (T, Test_Lemma_Sub'Access, "Test Sub Lemma");
   end Register_Tests;

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return Aunit.Message_String is
   begin
      return Aunit.Format ("Componolit.Runtime.Conversions");
   end Name;


end Componolit.Runtime.Conversions.Tests;
