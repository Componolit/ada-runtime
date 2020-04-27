
package Componolit.Runtime.Drivers.Power with
SPARK_Mode,
   Abstract_State => (Power_State with External => (Async_Readers,
                                                    Effective_Writes))
is

   procedure Off with
      Global => (Output => Power_State);

private

   Systemoff_Reg : constant SSE.Integer_Address := 16#500#;
   type Systemoff is range 1 .. 1 with
      Size => 32;

end Componolit.Runtime.Drivers.Power;
