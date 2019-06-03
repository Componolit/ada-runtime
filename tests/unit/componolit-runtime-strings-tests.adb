with System;
with Aunit.Assertions;

package body Componolit.Runtime.Strings.Tests is

   -------------------
   -- Test routines --
   -------------------

   procedure Test_Length (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Ada_String : String := "Hello world!";
      C_String : String := Ada_String & Character'Val (0);
      Null_String : System.Address := System.Null_Address;
   begin
      Aunit.Assertions.Assert (Length (C_String'Address) = Ada_String'Length,
                               "Length test failed");
      Aunit.Assertions.Assert (Length (C_String'Address, 5) = 5,
                               "Maximum length test failed");
      Aunit.Assertions.Assert (Length (Null_String) = 0,
                               "Null pointer length test failed");
   end Test_Length;

   procedure Test_Convert_To_Ada (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      Ada_String : String := "Hello world!";
      C_String : String := Ada_String & Character'Val (0);
      Null_String : System.Address := System.Null_Address;
      Default_String : String := "Default";
   begin
      Aunit.Assertions.Assert (Convert_To_Ada (C_String'Address, "") = Ada_String,
                               "String conversion test failed");
      Aunit.Assertions.Assert (Convert_To_Ada (C_String'Address, "", 5) = "Hello",
                               "String conversion with maximum length test failed");
      Aunit.Assertions.Assert (Convert_To_Ada (Null_String, Default_String) =
                                 Default_String,
                               "String conversion with null pointer test failed");
   end Test_Convert_To_Ada;

   procedure Test_Image (T : in out Aunit.Test_Cases.Test_Case'Class)
   is
      pragma Unreferenced (T);
      S_Null  : constant String := "0";
      S_Minus : constant String := "-1";
      S_First : constant String := "-2147483648";
      S_Last  : constant String := "2147483647";
      I_Null  : constant String := Image (0);
      I_Minus : constant String := Image (-1);
      I_First : constant String := Image (Integer'First);
      I_Last  : constant String := Image (Integer'Last);
   begin
      Aunit.Assertions.Assert (I_Null, S_Null, "Image S_Null failed");
      Aunit.Assertions.Assert (I_Minus, S_Minus, "Image S_Minus failed");
      Aunit.Assertions.Assert (I_First, S_First, "Image S_First failed");
      Aunit.Assertions.Assert (I_Last, S_Last, "Image S_Last failed");
   end Test_Image;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Length'Access, "Test Length");
      Register_Routine (T, Test_Convert_To_Ada'Access,
                        "Test Convert_To_Ada");
      Register_Routine (T, Test_Image'Access, "Test Image");
   end Register_Tests;

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return Aunit.Message_String is
   begin
      return Aunit.Format ("Componolit.Runtime.Strings");
   end Name;

end Componolit.Runtime.Strings.Tests;
