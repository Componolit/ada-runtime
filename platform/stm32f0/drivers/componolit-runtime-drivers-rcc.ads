
package Componolit.Runtime.Drivers.RCC with
   SPARK_Mode
is

   type Clock is (IOPA, IOPB, IOPC, IOPD);

   procedure Set (Clk    : Clock;
                  Enable : Boolean);
   function Enabled (Clk : Clock) return Boolean;

private

   RCC_Base      : constant SSE.Integer_Address := 16#4002_1000#;
   AHB_EN_Offset : constant SSE.Integer_Address := 16#14#;

   for Clock use (IOPA => 17, IOPB => 18, IOPC => 19, IOPD => 20);

   type Bit is range 0 .. 1 with
      Size => 1;

   type Register is array (0 .. 31) of Bit with
      Size => 32,
      Pack;

end Componolit.Runtime.Drivers.RCC;
