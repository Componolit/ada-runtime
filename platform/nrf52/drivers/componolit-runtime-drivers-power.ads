
package Componolit.Runtime.Drivers.Power is

   procedure Off;

private

   Systemoff_Reg : constant SSE.Integer_Address := 16#500#;
   type Systemoff is range 1 .. 1 with
      Size => 32;

end Componolit.Runtime.Drivers.Power;
