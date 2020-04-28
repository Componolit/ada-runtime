
package body Componolit.Runtime.Drivers.RCC with
   SPARK_Mode,
   Refined_State => (RCC_State => Reg)
is

   use type SSE.Integer_Address;

   Reg : Register with
      Address => SSE.To_Address (RCC_Base + AHB_EN_Offset),
      Import;

   procedure Set (Clk    : Clock;
                  Enable : Boolean)
   is
   begin
      Reg (Clock_Bit (Clk)) := (if Enable then 1 else 0);
   end Set;

   function Enabled (Clk : Clock) return Boolean
   is
   begin
      return Reg (Clock_Bit (Clk)) = 1;
   end Enabled;

end Componolit.Runtime.Drivers.RCC;
