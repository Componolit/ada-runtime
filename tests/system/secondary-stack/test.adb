procedure Test is

   S99 : String (1 .. 99 * 1024) := (others => Character'First);
   S49 : String (1 .. 49 * 1024) := (others => Character'First);
   S01 : String (1 .. 1024)      := (others => Character'First);

   function Str (I : String) return String is
   begin
      return I;
   end Str;

   S : String := Str ("Test");

begin
   declare
      S : String := Str (S99);
   begin
      null;
   end;
   declare
      S1 : String := Str (S49);
      S2 : String := Str (S49);
      S3 : String := Str (S01);
   begin
      null;
   end;
   declare
      S : String := Str (S01);
   begin
      null;
   end;
end Test;
