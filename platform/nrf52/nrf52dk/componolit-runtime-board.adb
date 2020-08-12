
with Componolit.Runtime.Drivers.Power;
with Componolit.Runtime.Drivers.Serial;

package body Componolit.Runtime.Board is

   package Serial renames Componolit.Runtime.Drivers.Serial;

   procedure Initialize
   is
   begin
      Serial.Initialize;
   end Initialize;

   procedure Log (S : String)
   is
   begin
      Serial.Print (S);
   end Log;

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
