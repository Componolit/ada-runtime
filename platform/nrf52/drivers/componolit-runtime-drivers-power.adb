
package body Componolit.Runtime.Drivers.Power is

   use type SSE.Integer_Address;

   Reg : Systemoff with
      Import,
      Address => SSE.To_Address (APB_Base + Systemoff_Reg),
      Volatile,
      Async_Readers,
      Effective_Writes;

   procedure Off
   is
   begin
      Reg := Systemoff'(1);
   end Off;

end Componolit.Runtime.Drivers.Power;
