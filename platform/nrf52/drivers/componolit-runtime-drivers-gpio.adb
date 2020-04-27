
package body Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode,
   Refined_State => (GPIO_Configuration => Direction,
                     GPIO_State         => (Outset,
                                            Outclr,
                                            Outreg,
                                            Inreg))
is
   use type SSE.Integer_Address;

   Direction : Pin_Modes with
      Address => SSE.To_Address (AHB_Base + DIR_Offset),
      Import;

   Outset : Pin_Values with
      Address => SSE.To_Address (AHB_Base + OUTSET_Offset),
      Import,
      Volatile,
      Async_Readers,
      Effective_Writes;

   Outclr : Pin_Values with
      Address => SSE.To_Address (AHB_Base + OUTCLR_Offset),
      Import,
      Volatile,
      Async_Readers,
      Effective_Writes;

   Outreg : Pin_Values with
      Address => SSE.To_Address (AHB_Base + OUT_Offset),
      Import,
      Volatile,
      Async_Writers;

   Inreg : Pin_Values with
      Address => SSE.To_Address (AHB_Base + IN_Offset),
      Import,
      Volatile,
      Async_Writers;

   function Convert (P : Pin_Value) return Value is
      (case P is
         when 0 => Low,
         when 1 => High);

   procedure Configure (P : Pin; M : Mode)
   is
   begin
      Direction (P) := M;
   end Configure;

   function Pin_Mode (P : Pin) return Mode
   is
   begin
      return Direction (P);
   end Pin_Mode;

   procedure Write (P : Pin; V : Value)
   is
      Enable : Pin_Values := (others => 0);
   begin
      Enable (P) := 1;
      case V is
         when Low =>
            Outclr := Enable;
         when High =>
            Outset := Enable;
      end case;
   end Write;

   procedure Read (P : Pin; V : out Value)
   is
      In_Value  : constant Pin_Value := Inreg (P);
      Out_Value : constant Pin_Value := Outreg (P);
   begin
      case Pin_Mode (P) is
         when Port_In =>
            V := Convert (In_Value);
         when Port_Out =>
            V := Convert (Out_Value);
      end case;
   end Read;

end Componolit.Runtime.Drivers.GPIO;
