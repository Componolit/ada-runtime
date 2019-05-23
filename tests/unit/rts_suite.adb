with Runtime_Lib.Secondary_Stack.Tests;
with Runtime_Lib.Strings.Tests;

package body Rts_Suite is
   use Aunit.Test_Suites;

   Result : aliased Test_Suite;

   Secondary_Stack_Case : aliased Runtime_Lib.Secondary_Stack.Tests.Test_Case;
   Strings_Case : aliased Runtime_Lib.Strings.Tests.Test_Case;

   -----------
   -- Suite --
   -----------

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin
      Result.Add_Test (Secondary_Stack_Case'Access);
      Result.Add_Test (Strings_Case'Access);
      return Result'Access;
   end Suite;

end Rts_Suite;
