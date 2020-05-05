with Componolit.Runtime.Drivers.GPIO;

procedure Main with
   SPARK_Mode
is
   package GPIO renames Componolit.Runtime.Drivers.GPIO;
   use type GPIO.Mode;
begin
   GPIO.Initialize;
   GPIO.Configure (GPIO.PC8, GPIO.Port_Out);
   GPIO.Configure (GPIO.PC9, GPIO.Port_Out);
   pragma Assert (GPIO.Pin_Mode (GPIO.PC8) = GPIO.Port_Out);
   pragma Assert (GPIO.Pin_Mode (GPIO.PC9) = GPIO.Port_Out);
end Main;
