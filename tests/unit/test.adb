with Ada.Command_Line;
with Aunit;
with Aunit.Reporter.Text;
with Aunit.Run;
use all type Aunit.Status;

with Rts_Suite;

procedure Test
is
   function Run is new Aunit.Run.Test_Runner_With_Status (Rts_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
   S : Aunit.Status := Run (Reporter);
begin
   if S = Aunit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
   else
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Test;
