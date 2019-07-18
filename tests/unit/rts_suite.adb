with Componolit.Runtime.Strings.Tests;
with Componolit.Runtime.Conversions.Tests;

package body Rts_Suite is
   use Aunit.Test_Suites;

   Result : aliased Test_Suite;

   Strings_Case     : aliased Componolit.Runtime.Strings.Tests.Test_Case;
   Conversions_Case : aliased Componolit.Runtime.Conversions.Tests.Test_Case;

   -----------
   -- Suite --
   -----------

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin
      Result.Add_Test (Strings_Case'Access);
      Result.Add_Test (Conversions_Case'Access);
      return Result'Access;
   end Suite;

end Rts_Suite;
