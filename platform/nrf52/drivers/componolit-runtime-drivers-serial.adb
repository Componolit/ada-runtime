with System.Storage_Elements;
with Componolit.Runtime.Drivers.Slicer;
package body Componolit.Runtime.Drivers.Serial with
SPARK_Mode,
  Refined_State => (Start_End_State => (TASKS_STARTTX, EVENT_ENDTX,
                                        TASKS_STOPTX, EVENT_TXSTOPPED,
                                        EVENT_TXSTARTED, EVENT_TXDRDY),
                    Register_State => (ENABLE, PSEL_TXD, PSELTXD,
                                       TXD_MAXCNT, TXD_AMOUNT, CONFIG,
                                       BAUDRATE, TXD_PTR, TXD),
                    Buffer_State => Buffer)
is

   package SSE renames System.Storage_Elements;
   use type SSE.Integer_Address;
   package Slicer is new Componolit.Runtime.Drivers.Slicer (Positive);

   Base : constant SSE.Integer_Address := 16#40002000#;

   TASKS_STARTTX : Reg_TASK with
     Import,
     Address => SSE.To_Address (Base + 16#8#),
     Volatile,
     Async_Readers,
     Async_Writers,
     Effective_Reads,
     Effective_Writes;

   TASKS_STOPTX : Reg_TASK with
     Import,
     Address => SSE.To_Address (Base + 16#C#),
     Volatile,
     Async_Readers,
     Async_Writers,
     Effective_Reads,
     Effective_Writes;

   EVENT_ENDTX : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#120#),
     Volatile,
     Async_Readers,
     Async_Writers,
     Effective_Reads,
     Effective_Writes;

   EVENT_TXSTOPPED : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#158#),
     Volatile,
     Async_Readers,
     Async_Writers,
     Effective_Reads,
     Effective_Writes;

   ENABLE : Reg_ENABLE with
     Import,
     Address => SSE.To_Address (Base + 16#500#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   PSEL_TXD : Reg_PSEL_TXD with
     Import,
     Address => SSE.To_Address (Base + 16#50C#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   PSELTXD : Reg_PSELTXD with
     Import,
     Address => SSE.To_Address (Base + 16#50C#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   TXD_MAXCNT : Reg_TXD_MAXCNT with
     Import,
     Address => SSE.To_Address (Base + 16#548#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   TXD_AMOUNT : Reg_TXD_AMOUNT with
     Import,
     Address => SSE.To_Address (Base + 16#54C#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   CONFIG : Reg_CONFIG with
     Import,
     Address => SSE.To_Address (Base + 16#56C#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   BAUDRATE : Reg_BAUDRATE with
     Import,
     Address => SSE.To_Address (Base + 16#524#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   TXD_PTR : Reg_TXD_PTR with
     Import,
     Address => SSE.To_Address (Base + 16#544#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   EVENT_TXSTARTED : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#150#),
     Volatile,
     Async_Readers,
     Async_Writers,
     Effective_Reads,
     Effective_Writes;

   TXD : Reg_TXD with
     Import,
     Address => SSE.To_Address (Base + 16#51C#),
     Volatile,
     Async_Readers,
     Effective_Writes;

   EVENT_TXDRDY : Reg_EVENT with
     Import,
     Address => SSE.To_Address (Base + 16#11C#),
     Volatile,
     Async_Readers,
     Async_Writers,
     Effective_Reads,
     Effective_Writes;

   Buffer : String (1 .. 255) := (others => Character'First);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Pin : GPIO.Pin) is
   begin
      ENABLE   := (ENABLE => Disabled);
      GPIO.Configure (Pin, GPIO.Port_Out);
      GPIO.Write (Pin, GPIO.High);
      PSEL_TXD := (CONNECT => Connected, PIN => Pin);
      CONFIG   := (HWFC => False, PARITY => Excluded);
      BAUDRATE := (BAUDRATE => Baud115200);
      ENABLE   := (ENABLE => Enabled_UARTE);
   end Initialize;

   -----------
   -- Print --
   -----------

   procedure Print (Str : String) is
      StrI : Positive;
      Slice : Slicer.Context;
      R : Slicer.Slice;
   begin
      if Str'Length <= 1 then
         return;
      end if;
      Slice := Slicer.Create (Str'First, Str'Last, Buffer'Length);
      loop
         pragma Loop_Invariant (Slicer.Get_Range (Slice).First = Str'First);
         pragma Loop_Invariant (Slicer.Get_Range (Slice).Last = Str'Last);
         pragma Loop_Invariant (Slicer.Get_Length (Slice) <= 255);
         R := Slicer.Get_Slice (Slice);
         StrI := Buffer'First;
         pragma Assert (R.Last - R.First + 1 <= 255);
         TXD_MAXCNT := (MAXCNT => Count (R.Last - R.First + 1));
         for B in R.First .. R.Last loop
            pragma Loop_Invariant (B in Str'Range);
            pragma Loop_Invariant (StrI <= Buffer'Last);
            pragma Loop_Invariant (R.Last - R.First < Buffer'Length);
            Buffer (StrI) := Str (B);
            exit when StrI = Buffer'Last;
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
      Event : Reg_EVENT;
   begin
      TXD_PTR       := (PTR => String_Address (Buffer));
      TASKS_STARTTX := (TSK => Trigger);
      loop
         Event := EVENT_ENDTX;
         exit when Event.EVENT = Clear;
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
