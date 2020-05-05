with Componolit.Runtime.Drivers.GPIO;

procedure Main with
   SPARK_Mode
is
   package GPIO renames Componolit.Runtime.Drivers.GPIO;
   use type GPIO.Mode;
begin
   GPIO.Configure (15, GPIO.Port_In);
   pragma Assert (GPIO.Pin_Mode (15) = GPIO.Port_In);
   GPIO.Configure (16, GPIO.Port_In);
   pragma Assert (GPIO.Pin_Mode (15) = GPIO.Port_In);
   pragma Assert (GPIO.Pin_Mode (16) = GPIO.Port_In);
end Main;
