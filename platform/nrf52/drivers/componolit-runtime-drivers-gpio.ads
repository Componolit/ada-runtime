
package Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode,
   Abstract_State => (GPIO_Configuration,
                      (GPIO_State with External => (Async_Readers,
                                                   Async_Writers,
                                                   Effective_Reads,
                                                   Effective_Writes))),
   Initializes    => (GPIO_Configuration, GPIO_State)
is

   type Pin is range 0 .. 31;

   type Mode is (Port_In, Port_Out) with
      Size => 1;

   type Value is (Low, High);

   procedure Configure (P : Pin; M : Mode) with
      Global => (In_Out => GPIO_Configuration);

   function Pin_Mode (P : Pin) return Mode with
      Global => (Input => GPIO_Configuration);

   procedure Write (P : Pin; V : Value) with
      Pre    => Pin_Mode (P) = Port_Out,
      Global => (In_Out    => GPIO_State,
                 Proof_In  => GPIO_Configuration);

   procedure Read (P : Pin; V : out Value) with
      Global => (Input  => (GPIO_Configuration, GPIO_State));

private

   for Mode use (Port_In => 0, Port_Out => 1);

   type Pin_Value is range 0 .. 1 with
      Size => 1;

   type Pin_Values is array (Pin'Range) of Pin_Value with
      Size => 32,
      Pack;

   type Pin_Modes is array (Pin'Range) of Mode with
      Size => 32,
      Pack;

   OUT_Offset    : constant SSE.Integer_Address := 16#504#;
   OUTSET_Offset : constant SSE.Integer_Address := 16#508#;
   OUTCLR_Offset : constant SSE.Integer_Address := 16#50C#;
   IN_Offset     : constant SSE.Integer_Address := 16#510#;
   DIR_Offset    : constant SSE.Integer_Address := 16#514#;

end Componolit.Runtime.Drivers.GPIO;
