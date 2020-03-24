
package body Componolit.Runtime.Drivers.GPIO with
   SPARK_Mode
is
   use type SSE.Integer_Address;

   procedure Configure (P : Pin;
                        M : Mode;
                        D : Value := Low)
   is
      Reg : Mode_Register with
         Import,
         Address => SSE.To_Address (Offset (P) + Mode_Offset);
      P_Reg : Pull_Register with
         Import,
         Address => SSE.To_Address (Offset (P) + Pull_Offset);
   begin
      Reg (Pin_Offset (P)) := M;
      case M is
         when Port_In =>
            P_Reg (Pin_Offset (P)) := (if D = Low then Down else Up);
         when Port_Out =>
            P_Reg (Pin_Offset (P)) := Pull_None;
      end case;
   end Configure;

   function Pin_Mode (P : Pin) return Mode
   is
      Reg : Mode_Register with
         Import,
         Address => SSE.To_Address (Offset (P) + Mode_Offset);
   begin
      return Reg (Pin_Offset (P));
   end Pin_Mode;

   procedure Write (P : Pin;
                    V : Value)
   is
      Reg  : Set_Reset_Register with
         Import,
         Address => SSE.To_Address (Offset (P) + SR_Offset);
      Bits : Bit_Register := (others => 0);
   begin
      Bits (Pin_Offset (P)) := 1;
      case V is
         when Low =>
            Reg := Set_Reset_Register'(Set   => (others => 0),
                                       Reset => Bits);
         when High =>
            Reg := Set_Reset_Register'(Set   => Bits,
                                       Reset => (others => 0));
      end case;
   end Write;

   procedure Read (P :     Pin;
                   V : out Value)
   is
      Reg : Input_Register with
         Import,
         Address => SSE.To_Address (Offset (P) + Input_Offset);
   begin
      V := Value'Val (Reg.Data (Pin_Offset (P)));
   end Read;

   function Offset (P : Pin) return SSE.Integer_Address is
      (case P is
         when PA0 .. PA15 => 16#4800_0000#,
         when PB0 .. PB15 => 16#4800_0400#,
         when PC0 .. PC15 => 16#4800_0800#,
         when PD0 .. PD15 => 16#4800_0C00#,
         when PF0 .. PF15 => 16#4800_1400#);

   function Pin_Offset (P : Pin) return Pin_Index is
      (Pin_Index (Pin'Pos (P) mod 16));

end Componolit.Runtime.Drivers.GPIO;
