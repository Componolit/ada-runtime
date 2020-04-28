
package Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode,
   Abstract_State => (Configuration_State,
                      (GPIO_State with External => (Async_Writers,
                                                    Async_Readers,
                                                    Effective_Writes))),
   Initializes    => (Configuration_State, GPIO_State)
is

   type Pin is (PA0, PA1, PA2, PA3, PA4, PA5, PA6, PA7,
                PA8, PA9, PA10, PA11, PA12, PA13, PA14, PA15,
                PB0, PB1, PB2, PB3, PB4, PB5, PB6, PB7,
                PB8, PB9, PB10, PB11, PB12, PB13, PB14, PB15,
                PC0, PC1, PC2, PC3, PC4, PC5, PC6, PC7,
                PC8, PC9, PC10, PC11, PC12, PC13, PC14, PC15,
                PD0, PD1, PD2, PD3, PD4, PD5, PD6, PD7,
                PD8, PD9, PD10, PD11, PD12, PD13, PD14, PD15,
                PF0, PF1, PF2, PF3, PF4, PF5, PF6, PF7,
                PF8, PF9, PF10, PF11, PF12, PF13, PF14, PF15);

   type Mode is (Port_In, Port_Out) with
      Size => 2;
   type Value is (Low, High);
   for Value use (Low => 0, High => 1);

   procedure Configure (P : Pin;
                        M : Mode;
                        D : Value := Low) with
      Global => (In_Out => Configuration_State);

   function Pin_Mode (P : Pin) return Mode with
      Global => (Input => Configuration_State);

   procedure Write (P : Pin;
                    V : Value) with
      Global => (In_Out => GPIO_State);

   procedure Read (P :     Pin;
                   V : out Value) with
      Global => (Input => GPIO_State);

private

   type Bank_Id is (A, B, C, D, E, F);

   for Mode use (Port_In => 0, Port_Out => 1);

   type Pull is (Pull_None, Up, Down, Pull_Reserved) with
      Size => 2;
   for Pull use (Pull_None => 0, Up => 1, Down => 2, Pull_Reserved => 3);

   type Bit is range 0 .. 1 with
      Size => 1;

   type Pin_Index is mod 16;

   Mode_Offset  : constant SSE.Integer_Address := 16#00#;
   Pull_Offset  : constant SSE.Integer_Address := 16#0C#;
   Input_Offset : constant SSE.Integer_Address := 16#10#;
   SR_Offset    : constant SSE.Integer_Address := 16#18#;

   function Bank_Select (P : Pin) return Bank_Id with
      Post => Bank_Select'Result /= E;

   function Pin_Offset (P : Pin) return Pin_Index;

   type Mode_Register is array (Pin_Index'Range) of Mode with
      Size => 32,
      Pack;

   type Bit_Register is array (Pin_Index'Range) of Bit with
      Size => 16,
      Pack;

   type Set_Reset_Register is record
      Set   : Bit_Register := (others => 0);
      Reset : Bit_Register := (others => 0);
   end record with
      Size => 32;

   type Input_Register is record
      Data : Bit_Register := (others => 0);
   end record with
      Size => 32;

   for Input_Register use record
      Data at 0 range 0 .. 15;
   end record;

   type Pull_Register is array (Pin_Index'Range) of Pull with
      Size => 32,
      Pack;

   pragma Warnings (Off, "* bits of * unused");
   type Bank_Config is record
      Port_Mode : Mode_Register;
      Pull_Mode : Pull_Register;
   end record with
      Size => 1024 * 8;

   for Bank_Config use record
      Port_Mode at  0 range 0 .. 31;
      Pull_Mode at 12 range 0 .. 31;
   end record;

   type Bank_IO is record
      Input     : Input_Register;
      Set_Reset : Set_Reset_Register;
   end record with
      Size => 1024 * 8;

   for Bank_IO use record
      Input     at 16 range 0 .. 31;
      Set_Reset at 24 range 0 .. 31;
   end record;
   pragma Warnings (On, "* bits of * unused");

   type Configuration is array (Bank_Id'Range) of Bank_Config with
      Size => 6 * 1024 * 8,
      Pack;

   type Input_Output is array (Bank_Id'Range) of Bank_IO with
      Size => 6 * 1024 * 8,
      Pack;

end Componolit.Runtime.Drivers.GPIO;
