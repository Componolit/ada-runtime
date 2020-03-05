
package Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode
is

   type Pin is range 0 .. 31;
   type Mode is (Port_In, Port_Out) with
      Size => 1;
   type Value is (Low, High);

   procedure Configure (P : Pin; M : Mode);
   function Pin_Mode (P : Pin) return Mode;
   procedure Write (P : Pin; V : Value) with
      Pre => Pin_Mode (P) = Port_Out;
   procedure Read (P : Pin; V : out Value);

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
