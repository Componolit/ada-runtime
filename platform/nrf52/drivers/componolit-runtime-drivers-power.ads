
package Componolit.Runtime.Drivers.Power with
   SPARK_Mode,
   Abstract_State => (Power_State with External => (Async_Readers,
                                                    Effective_Writes))
is

   procedure Off with
      Global => (Output => Power_State);

private

   Systemoff_Reg : constant SSE.Integer_Address := 16#500#;
   type Systemoff is range 0 .. 1 with
      Size => 1,
      Object_Size => 8;

   type Padding is mod 2 ** 31 with
      Size => 31;

   type Systemoff_Register is record
      S : Systemoff;
      P : Padding;
   end record with
      Size => 32,
      Object_Size => 32;

   for Systemoff_Register use record
      S at 0 range 0 .. 0;
      P at 0 range 1 .. 31;
   end record;

end Componolit.Runtime.Drivers.Power;
