
with Componolit.Runtime.Drivers.GPIO;
with Componolit.Runtime.Drivers.Power;

package body Componolit.Runtime.Board is

   LED : constant Drivers.GPIO.Pin := 7;

   procedure Initialize is
   begin
      Drivers.GPIO.Configure (LED, Drivers.GPIO.Port_Out);
      Drivers.GPIO.Write (LED, Drivers.GPIO.Low);
   end Initialize;

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
