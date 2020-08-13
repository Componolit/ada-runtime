with Componolit.Runtime.Drivers.GPIO;
with System;

package Componolit.Runtime.Drivers.Serial with
SPARK_Mode,
  Abstract_State => ((Start_End_State with External => (Async_Readers,
                                                        Async_Writers,
                                                        Effective_Reads,
                                                        Effective_Writes)),
                     (Register_State with External => (Async_Readers,
                                                       Effective_Writes)),
                     Buffer_State),
  Initializes => (Buffer_State, Register_State)
is

   package GPIO renames Componolit.Runtime.Drivers.GPIO;
   procedure Initialize (Pin : GPIO.Pin) with
     Global => (Output => (GPIO.GPIO_Configuration),
                In_Out => (GPIO.Shadow_GPIO_Configuration, GPIO.GPIO_State, Register_State));
   procedure Print (Str : String) with
     Global => (In_Out => (Start_End_State,
                           Register_State,
                           Buffer_State));
   procedure Send with
     Global => (In_Out => (Start_End_State,
                           Register_State),
                Input => Buffer_State);

private

   function String_Address (S : String) return System.Address;

   type CONFIG_Parity is (Excluded, Included) with
     Size => 3,
     Object_Size => 8;

   for CONFIG_Parity use (Excluded => 0,
                          Included => 7);

   type Reg_CONFIG is record
      HWFC   : Boolean;
      PARITY : CONFIG_Parity;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_CONFIG use record
      HWFC at 0 range 0 .. 0;
      PARITY at 0 range 1 .. 3;
   end record;

   type PSEL_TXD_Connect is (Connected, Disconnected) with
     Size => 1,
     Object_Size => 8;

   for PSEL_TXD_Connect use (Connected    => 0,
                             Disconnected => 1);
   --  UARTE
   type Reg_PSELTXD is record
      PIN : GPIO.Pin;
   end record with
     Size => 32,
     Object_Size => 32;

   --  UARTE
   for Reg_PSELTXD use record
      PIN at 0 range 0 .. 4;
   end record;

   type Reg_PSEL_TXD is record
      PIN     : GPIO.Pin;
      CONNECT : PSEL_TXD_Connect;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_PSEL_TXD use record
      PIN at 0 range 0 .. 4;
      CONNECT at 0 range 31 .. 31;
   end record;

   type ENABLE_Enable is (Disabled, Enabled_UART, Enabled_UARTE) with
     Size => 4,
     Object_Size => 8;

   for ENABLE_Enable use (Disabled => 0,
                          Enabled_UART  => 4,
                          Enabled_UARTE => 8);

   type Reg_ENABLE is record
      ENABLE : ENABLE_Enable;
   end record;

   for Reg_ENABLE use record
      ENABLE at 0 range 0 .. 3;
   end record;

   type Reg_TXD_PTR is record
      PTR : System.Address;
   end record with
     Size => 32,
     Object_Size => 32;

   type Count is range 0 .. 255 with
     Size => 8,
     Object_Size => 8;

   type Reg_TXD_MAXCNT is record
      MAXCNT : Count;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_TXD_MAXCNT use record
      MAXCNT at 0 range 0 .. 7;
   end record;

   type Reg_TXD_AMOUNT is record
      AMOUNT : Count;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_TXD_AMOUNT use record
      AMOUNT at 0 range 0 .. 7;
   end record;

   type EVENT_Event is (Clear, Set) with
     Size => 1,
     Object_Size => 8;

   for EVENT_Event use (Clear => 0,
                        Set   => 1);

   type Reg_EVENT is record
      EVENT : EVENT_Event;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_EVENT use record
      EVENT at 0 range 0 .. 0;
   end record;

   type TASK_Trigger is (Trigger) with
     Size => 1,
     Object_Size => 8;

   for TASK_Trigger use (Trigger => 1);

   type Reg_TASK is record
      TSK : TASK_Trigger;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_TASK use record
      TSK at 0 range 0 .. 0;
   end record;

   type BAUDRATE_Rate is (Baud1200, Baud2400, Baud4800, Baud9600,
                          Baud14400, Baud19200, Baud28800, Baud38400,
                          Baud57600, Baud76800, Baud115200, Baud230400,
                          Baud250000, Baud460800, Baud921600, Baud1M) with
     Size => 32,
     Object_Size => 32;

   for BAUDRATE_Rate use (Baud1200   => 16#0004F000#,
                          Baud2400   => 16#0009D000#,
                          Baud4800   => 16#0013B000#,
                          Baud9600   => 16#00275000#,
                          Baud14400  => 16#003AF000#,
                          Baud19200  => 16#004EA000#,
                          Baud28800  => 16#0075C000#,
                          Baud38400  => 16#009D0000#,
                          Baud57600  => 16#00EB0000#,
                          Baud76800  => 16#013A9000#,
                          Baud115200 => 16#01D60000#,
                          Baud230400 => 16#03B00000#,
                          Baud250000 => 16#04000000#,
                          Baud460800 => 16#07400000#,
                          Baud921600 => 16#0F000000#,
                          Baud1M     => 16#10000000#);

   type Reg_BAUDRATE is record
      BAUDRATE : BAUDRATE_Rate;
   end record with
     Size => 32,
     Object_Size => 32;

   type Reg_TXD is record
      TXD : Character;
   end record with
     Size => 32,
     Object_Size => 32;

   for Reg_TXD use record
      TXD at 0 range 0 .. 7;
   end record;

end Componolit.Runtime.Drivers.Serial;
