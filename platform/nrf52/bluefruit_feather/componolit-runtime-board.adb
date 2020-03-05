
with Componolit.Runtime.Drivers.Power;
with Componolit.Runtime.Drivers.GPIO;

package body Componolit.Runtime.Board is

   Red  : constant Drivers.GPIO.Pin := 17;
   Blue : constant Drivers.GPIO.Pin := 19;

   procedure Initialize
   is
   begin
      Drivers.GPIO.Configure (Blue, Drivers.GPIO.Port_Out);
      Drivers.GPIO.Write (Blue, Drivers.GPIO.High);
   end Initialize;

   procedure Log (S : String) is null;

   procedure Halt_On_Error
   is
      procedure Wait;
      procedure Wait
      is
      begin
         for I in Integer range 0 .. 1000000 loop
            null;
         end loop;
      end Wait;
   begin
      Drivers.GPIO.Configure (Red, Drivers.GPIO.Port_Out);
      loop
         Drivers.GPIO.Write (Red, Drivers.GPIO.High);
         Wait;
         Drivers.GPIO.Write (Red, Drivers.GPIO.Low);
         Wait;
      end loop;
   end Halt_On_Error;

   procedure Poweroff
   is
   begin
      Drivers.Power.Off;
   end Poweroff;

end Componolit.Runtime.Board;
