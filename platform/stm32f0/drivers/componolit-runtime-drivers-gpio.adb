
package body Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode,
   Refined_State => (Configuration_State => Config_Registers,
                     GPIO_State          => IO_Registers)
is

   use type SSE.Integer_Address;

   --  Both register arrays span over the whole GPIO memory region as arrays of
   --  GPIO ports. While they might overlap each other their components only
   --  access slices of memory that are non-overlapping:
   --
   --  Port:   |     A     |     B     |
   --          ---------------------------
   --  Config: | 1 |       | 1 |       |
   --          ---------------------------
   --  IO:     |   | 2 |   |   | 2 |   |
   --          ---------------------------
   --
   --  The Config registers only access region 1 of each port while the
   --  IO registers only access region 2.

   Config_Registers : Configuration with
      Import,
      Address => SSE.To_Address (16#4800_0000#);

   IO_Registers : Input_Output with
      Import,
      Address => SSE.To_Address (16#4800_0000#),
      Volatile,
      Async_Readers,
      Async_Writers,
      Effective_Writes;

   procedure Configure (P : Pin;
                        M : Mode;
                        D : Value := Low)
   is
   begin
      Config_Registers (Bank_Select (P)).Port_Mode (Pin_Offset (P)) := M;
      case M is
         when Port_In =>
            Config_Registers (Bank_Select (P)).Pull_Mode (Pin_Offset (P))
               := (if D = Low then Down else Up);
         when Port_Out =>
            Config_Registers (Bank_Select (P)).Pull_Mode (Pin_Offset (P))
               := Pull_None;
      end case;
   end Configure;

   function Pin_Mode (P : Pin) return Mode
   is
   begin
      return Config_Registers (Bank_Select (P)).Port_Mode (Pin_Offset (P));
   end Pin_Mode;

   procedure Write (P : Pin;
                    V : Value)
   is
      Bits : Bit_Register := (others => 0);
   begin
      Bits (Pin_Offset (P)) := 1;
      case V is
         when Low =>
            IO_Registers (Bank_Select (P)).Set_Reset
               := Set_Reset_Register'(Set   => (others => 0),
                                      Reset => Bits);
         when High =>
            IO_Registers (Bank_Select (P)).Set_Reset
               := Set_Reset_Register'(Set   => Bits,
                                      Reset => (others => 0));
      end case;
   end Write;

   procedure Read (P :     Pin;
                   V : out Value)
   is
      B : Bit;
   begin
      B := IO_Registers (Bank_Select (P)).Input.Data (Pin_Offset (P));
      V := Value'Val (B);
   end Read;

   function Bank_Select (P : Pin) return Bank_Id is
      (case P is
         when PA0 .. PA15 => A,
         when PB0 .. PB15 => B,
         when PC0 .. PC15 => C,
         when PD0 .. PD15 => D,
         when PF0 .. PF15 => F);

   function Pin_Offset (P : Pin) return Pin_Index is
      (Pin_Index (Pin'Pos (P) mod 16));

end Componolit.Runtime.Drivers.GPIO;
