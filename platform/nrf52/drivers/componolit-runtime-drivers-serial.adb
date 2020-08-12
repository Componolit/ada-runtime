with System.Storage_Elements;
with Componolit.Runtime.Drivers.Slicer;
package body Componolit.Runtime.Drivers.Serial with
   SPARK_Mode
is

   package SSE renames System.Storage_Elements;
   use type SSE.Integer_Address;
   package Slicer is new Componolit.Runtime.Drivers.Slicer (Positive);

   Base : constant SSE.Integer_Address := 16#40002000#;

   TASKS_STARTTX : Reg_TASK with
     Import,
     Address => SSE.To_Address (Base + 16#8#);

   TASKS_STOPTX : Reg_TASK with
     Import,
     Address => SSE.To_Address (Base + 16#C#);

   EVENT_ENDTX : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#120#);

   EVENT_TXSTOPPED : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#158#);

   ENABLE : Reg_ENABLE with
     Import,
     Address => SSE.To_Address (Base + 16#500#);

   PSEL_TXD : Reg_PSEL_TXD with
     Import,
     Address => SSE.To_Address (Base + 16#50C#);

   PSELTXD : Reg_PSELTXD with
     Import,
     Address => SSE.To_Address (Base + 16#50C#);

   TXD_MAXCNT : Reg_TXD_MAXCNT with
     Import,
     Address => SSE.To_Address (Base + 16#548#);

   TXD_AMOUNT : Reg_TXD_AMOUNT with
     Import,
     Address => SSE.To_Address (Base + 16#54C#);

   CONFIG : Reg_CONFIG with
     Import,
     Address => SSE.To_Address (Base + 16#56C#);

   BAUDRATE : Reg_BAUDRATE with
     Import,
     Address => SSE.To_Address (Base + 16#524#);

   TXD_PTR : Reg_TXD_PTR with
     Import,
     Address => SSE.To_Address (Base + 16#544#);

   EVENT_TXSTARTED : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#150#);

   TXD : Reg_TXD with
     Import,
     Address => SSE.To_Address (Base + 16#51C#);

   EVENT_TXDRDY : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#11C#);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      ENABLE   := (ENABLE => Disabled);
      GPIO.Configure (6, GPIO.Port_Out);
      GPIO.Write (6, GPIO.High);
      PSEL_TXD := (CONNECT => Connected, PIN => 6);
      CONFIG   := (HWFC => False, PARITY => Excluded);
      BAUDRATE := (BAUDRATE => Baud115200);
      ENABLE   := (ENABLE => Enabled_UARTE);
   end Initialize;

   -----------
   -- Print --
   -----------
   Buffer : String (1 .. 255);

   procedure Print (Str : String) is
      StrI : Positive;
      Slice : Slicer.Context;
      R : Slicer.Slice;
   begin
      if Str'Length < 1 then
         return;
      end if;
      Slice := Slicer.Create (Str'First, Str'Last, Buffer'Length);
      loop
         pragma Loop_Invariant (Slicer.Get_Range (Slice).First = Str'First);
         pragma Loop_Invariant (Slicer.Get_Range (Slice).Last = Str'Last);
         R := Slicer.Get_Slice (Slice);
         StrI := Buffer'First;
         TXD_MAXCNT := (MAXCNT => Count (R.Last - R.First + 1));
         for B in R.First .. R.Last loop
            pragma Loop_Invariant (B in Str'Range);
            pragma Loop_Invariant (StrI <= Buffer'Last);
            pragma Loop_Invariant (R.Last - R.First < Buffer'Length);
            Buffer (StrI) := Str (B);
            StrI := StrI + 1;
         end loop;
         Send;
         exit when not Slicer.Has_Next (Slice);
         Slicer.Next (Slice);
      end loop;
   end Print;

   ----------
   -- Send --
   ----------

   procedure Send is
   begin
      TXD_PTR       := (PTR => String_Address (Buffer));
      TASKS_STARTTX := (TSK => Trigger);
      while EVENT_ENDTX.EVENT = Clear  loop
         pragma Inspection_Point (EVENT_ENDTX);
      end loop;
      EVENT_ENDTX.EVENT := Clear;
   end Send;

   --------------------
   -- String_Address --
   --------------------

   function String_Address (S : String) return System.Address with
     SPARK_Mode => Off
   is
   begin
      return S'Address;
   end String_Address;

end Componolit.Runtime.Drivers.Serial;
