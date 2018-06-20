procedure Test is

   function Str (I : String) return String is
   begin
      return I;
   end Str;

   S : String := Str("Test");

begin

   null;

end Test;
