
package Componolit.Runtime.Drivers.RCC with
   SPARK_Mode,
   Abstract_State => RCC_State,
   Initializes    => RCC_State
is

   type Clock is (IOPA, IOPB, IOPC, IOPD, IOPF);

   procedure Set (Clk    : Clock;
                  Enable : Boolean) with
      Global => (In_Out => RCC_State);

   function Enabled (Clk : Clock) return Boolean with
      Global => (Input => RCC_State);

private

   RCC_Base      : constant SSE.Integer_Address := 16#4002_1000#;
   AHB_EN_Offset : constant SSE.Integer_Address := 16#14#;

   for Clock use (IOPA => 17, IOPB => 18, IOPC => 19, IOPD => 20, IOPF => 22);

   function Clock_Bit (C : Clock) return Natural is
      (case C is
          when IOPA => 17,
          when IOPB => 18,
          when IOPC => 19,
          when IOPD => 20,
          when IOPF => 22);

   type Bit is range 0 .. 1 with
      Size => 1;

   type Register is array (0 .. 31) of Bit with
      Size => 32,
      Pack;

end Componolit.Runtime.Drivers.RCC;
