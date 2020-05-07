
package Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode,
   Abstract_State => (Shadow_GPIO_Configuration,
                      (GPIO_Configuration with External => (Async_Readers,
                                                            Effective_Writes)),
                      (GPIO_State with External => (Async_Readers,
                                                    Async_Writers,
                                                    Effective_Writes))),
   Initializes    => (Shadow_GPIO_Configuration,
                      GPIO_Configuration,
                      GPIO_State)
is

   pragma Unevaluated_Use_Of_Old (Allow);

   type Pin is range 0 .. 31;

   type Mode is (Port_In, Port_Out) with
      Size => 1;

   type Value is (Low, High);

   type Pin_Modes is array (Pin'Range) of Mode with
      Size => 32,
      Pack;

   type Configured_Pins is array (Pin'Range) of Boolean;

   function Pins_Configured return Configured_Pins with
      Ghost,
      Global => (Input => Shadow_GPIO_Configuration);

   function Configured (P : Pin) return Boolean with
      Ghost,
      Post   => Configured'Result = Pins_Configured (P),
      Global => (Input => Shadow_GPIO_Configuration);

   function Proof_Modes return Pin_Modes with
      Ghost,
      Global => (Input => Shadow_GPIO_Configuration);

   procedure Configure (P : Pin; M : Mode) with
      Post   => Configured (P)
                and then Pin_Mode (P) = M
                and then (for all Pn in Pin =>
                             (if Pn /= P then Proof_Modes (Pn) =
                                    Proof_Modes'Old (Pn)))
                and then (for all Pn in Pin =>
                             (if Pn /= P then Pins_Configured (Pn) =
                                    Pins_Configured'Old (Pn))),
      Global => (In_Out => Shadow_GPIO_Configuration,
                 Output => GPIO_Configuration);

   function Pin_Mode (P : Pin) return Mode with
      Pre    => Configured (P),
      Post   => Pin_Mode'Result = Proof_Modes (P),
      Global => (Input => Shadow_GPIO_Configuration),
      Ghost;

   procedure Write (P : Pin; V : Value) with
      Pre    => Configured (P)
                and then Pin_Mode (P) = Port_Out,
      Global => (In_Out    => GPIO_State,
                 Proof_In  => Shadow_GPIO_Configuration);

   procedure Read (P : Pin; V : out Value) with
      Pre    => Configured (P)
                and then Pin_Mode (P) in Port_In | Port_Out,
      Global => (Input    => (GPIO_Configuration, GPIO_State),
                 Proof_In => Shadow_GPIO_Configuration);

private

   for Mode use (Port_In => 0, Port_Out => 1);

   type Pin_Value is range 0 .. 1 with
      Size => 1;

   type Pin_Values is array (Pin'Range) of Pin_Value with
      Size => 32,
      Pack;

   OUT_Offset    : constant SSE.Integer_Address := 16#504#;
   OUTSET_Offset : constant SSE.Integer_Address := 16#508#;
   OUTCLR_Offset : constant SSE.Integer_Address := 16#50C#;
   IN_Offset     : constant SSE.Integer_Address := 16#510#;
   DIR_Offset    : constant SSE.Integer_Address := 16#514#;

end Componolit.Runtime.Drivers.GPIO;
