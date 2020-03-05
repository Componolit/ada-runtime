
with Componolit.Runtime.Drivers.Power;

package body Componolit.Runtime.Board is

   procedure Initialize is null;

   procedure Log (S : String) is null;

   procedure Halt_On_Error
   is
   begin
      Drivers.Power.Off;
   end Halt_On_Error;

   procedure Poweroff
   is
   begin
      Drivers.Power.Off;
   end Poweroff;

end Componolit.Runtime.Board;
