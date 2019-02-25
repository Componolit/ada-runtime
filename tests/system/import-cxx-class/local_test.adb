package body Local_Test is

   procedure Test is
      type Class is limited record
         I : Integer;
      end record
      with Import, Convention => CPP;
      function Constructor return Class;
      pragma Cpp_Constructor (Constructor, "_ZN9Cxx_ClassC1Ev");
      type Vr (Has_Item : Boolean) is record
         case Has_Item is
            when True => Item : Integer;
            when False => null;
         end case;
      end record;
      function Create_Record return Vr
      is
      begin
         return Vr' (Has_Item => True, Item => 0);
      end Create_Record;
      C : Class := Constructor;
   begin
      declare
         V : Vr := Create_Record;
      begin
         null;
      end;
   end Test;

end Local_Test;
