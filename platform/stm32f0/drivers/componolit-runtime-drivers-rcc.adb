
package body Componolit.Runtime.Drivers.RCC with
   SPARK_Mode
is
   use type SSE.Integer_Address;

   procedure Set (Clk    : Clock;
                  Enable : Boolean)
   is
      Reg :   Register with
         Address => SSE.To_Address (RCC_Base + AHB_EN_Offset),
         Import;
      Cache : Register := Reg;
   begin
      Cache (Clk'Enum_Rep) := (if Enable then 1 else 0);
      Reg := Cache;
   end Set;

   function Enabled (Clk : Clock) return Boolean
   is
      Reg : Register with
         Address => SSE.To_Address (RCC_Base + AHB_EN_Offset),
         Import;
   begin
      return Reg (Clk'Enum_Rep) = 1;
   end Enabled;

end Componolit.Runtime.Drivers.RCC;
