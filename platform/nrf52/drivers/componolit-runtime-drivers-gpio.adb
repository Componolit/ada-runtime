
package body Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode,
   Refined_State => (Shadow_GPIO_Configuration => (Shadow_DIR_Reg, Pins),
                     GPIO_Configuration        => DIR_Reg,
                     GPIO_State                => (OUTSET_Reg,
                                                   OUTCLR_Reg,
                                                   OUT_Reg,
                                                   IN_Reg))
is
   use type SSE.Integer_Address;

   DIR_Reg : Pin_Modes with
      Address => SSE.To_Address (AHB_Base + DIR_Offset),
      Import,
      Volatile,
      Async_Readers,
      Effective_Writes;

   OUTSET_Reg : Pin_Values with
      Address => SSE.To_Address (AHB_Base + OUTSET_Offset),
      Import,
      Volatile,
      Async_Readers,
      Effective_Writes;

   OUTCLR_Reg : Pin_Values with
      Address => SSE.To_Address (AHB_Base + OUTCLR_Offset),
      Import,
      Volatile,
      Async_Readers,
      Effective_Writes;

   OUT_Reg : Pin_Values with
      Address => SSE.To_Address (AHB_Base + OUT_Offset),
      Import,
      Volatile,
      Async_Writers;

   IN_Reg : Pin_Values with
      Address => SSE.To_Address (AHB_Base + IN_Offset),
      Import,
      Volatile,
      Async_Writers;

   Shadow_DIR_Reg : Pin_Modes := DIR_Reg;

   Pins : Configured_Pins := (others => False);

   function Pins_Configured return Configured_Pins is (Pins);

   function Configured (P : Pin) return Boolean is (Pins (P));

   function Convert (P : Pin_Value) return Value is
      (case P is
         when 0 => Low,
         when 1 => High);

   procedure Configure (P : Pin; M : Mode)
   is
   begin
      Shadow_DIR_Reg (P) := M;
      DIR_Reg            := Shadow_DIR_Reg;
      Pins (P)           := True;
   end Configure;

   function Pin_Mode (P : Pin) return Mode is
      (Shadow_DIR_Reg (P));

   procedure Write (P : Pin; V : Value)
   is
      Enable : Pin_Values := (others => 0);
   begin
      Enable (P) := 1;
      case V is
         when Low =>
            OUTCLR_Reg := Enable;
         when High =>
            OUTSET_Reg := Enable;
      end case;
   end Write;

   procedure Read (P : Pin; V : out Value)
   is
      In_Value  : constant Pin_Value := IN_Reg (P);
      Out_Value : constant Pin_Value := OUT_Reg (P);
   begin
      case DIR_Reg (P) is
         when Port_In =>
            V := Convert (In_Value);
         when Port_Out =>
            V := Convert (Out_Value);
      end case;
   end Read;

   function Proof_Modes return Pin_Modes is (Shadow_DIR_Reg);

end Componolit.Runtime.Drivers.GPIO;
