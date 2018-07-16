with Ss_Utils.Tests;
with String_Utils.Tests;

package body Rts_Suite is
   use Aunit.Test_Suites;

   Result : aliased Test_Suite;

   Ss_Utils_Case : aliased Ss_Utils.Tests.Test_Case;
   String_Utils_Case : aliased String_Utils.Tests.Test_Case;

   -----------
   -- Suite --
   -----------

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin
      Result.Add_Test (Ss_Utils_Case'Access);
      Result.Add_Test (String_Utils_Case'Access);
      return Result'Access;
   end Suite;

end Rts_Suite;
