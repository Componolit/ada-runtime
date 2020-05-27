
package body Componolit.Runtime.Drivers.Power with
SPARK_Mode,
   Refined_State => (Power_State => Reg)
is

   use type SSE.Integer_Address;

   Reg : Systemoff_Register with
      Import,
      Address => SSE.To_Address (APB_Base + Systemoff_Reg),
      Volatile,
      Async_Readers,
      Effective_Writes;

   procedure Off
   is
   begin
      Reg := (S => Systemoff'(1),
              P => 0);
   end Off;

end Componolit.Runtime.Drivers.Power;
