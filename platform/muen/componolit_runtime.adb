
with Interfaces;
with SK.CPU;
with Debuglog.Types;
with Debuglog.Stream;
with Debuglog.Stream.Writer_Instance;
with Musinfo;
with Musinfo.Instance;
with Gnat_Helpers;

package body Componolit_Runtime with
   SPARK_Mode
is
   use type Interfaces.Unsigned_64;
   use type Musinfo.Memregion_Type;

   type Byte is mod 2 ** 8 with
      Size => 8;
   type Stack is array (Natural range <>) of Byte;

   Secondary_Stack : Stack (1 .. 1024 ** 2)       := (others => 0);
   Log_Memory      : Musinfo.Memregion_Type       := Musinfo.Null_Memregion;
   Log_Buffer      : Debuglog.Types.Data_Type     := Debuglog.Types.Null_Data;
   Log_Index       : Debuglog.Types.Message_Index :=
      Debuglog.Types.Message_Index'First;
   Log_Activated   : Boolean := False;

   procedure Allocate_Secondary_Stack (Size :     Natural;
                                       Addr : out System.Address)
   is
   begin
      if Size = 0 or else Size > Secondary_Stack'Last then
         Addr := System.Null_Address;
      else
         Addr := Secondary_Stack (Secondary_Stack'First)'Address;
      end if;
   end Allocate_Secondary_Stack;

   procedure Activate_Channel (Mem : Musinfo.Memregion_Type) with
      Pre => Debuglog.Stream.Channel_Type'Size <= Mem.Size;

   procedure Activate_Channel (Mem : Musinfo.Memregion_Type) with
      SPARK_Mode => Off
   is
      Channel : Debuglog.Stream.Channel_Type with
         Address => System'To_Address (Mem.Address),
         Async_Readers;
   begin
      Debuglog.Stream.Writer_Instance.Initialize (Channel, 1);
   end Activate_Channel;

   procedure Write_Channel (Mem : Musinfo.Memregion_Type;
                            Msg : Debuglog.Types.Data_Type) with
      Pre => Debuglog.Stream.Channel_Type'Size <= Mem.Size;

   procedure Write_Channel (Mem : Musinfo.Memregion_Type;
                            Msg : Debuglog.Types.Data_Type) with
      SPARK_Mode => Off
   is
      Channel : Debuglog.Stream.Channel_Type with
         Address => System'To_Address (Mem.Address),
         Async_Readers;
   begin
      Debuglog.Stream.Writer_Instance.Write (Channel, Msg);
   end Write_Channel;

   procedure Put (Char : Character) with
      Pre => Log_Memory /= Musinfo.Null_Memregion;

   procedure Put (Char : Character)
   is
   begin
      if Char /= ASCII.NUL and then Char /= ASCII.CR then
         Log_Buffer.Message (Log_Index) := Char;
         if
            Log_Index = Debuglog.Types.Message_Index'Last
            or else Char = ASCII.LF
         then
            Log_Buffer.Timestamp := Musinfo.Instance.TSC_Schedule_Start;
            Write_Channel (Log_Memory, Log_Buffer);
            Log_Index  := Debuglog.Types.Message_Index'First;
            Log_Buffer := Debuglog.Types.Null_Data;
         else
            Log_Index := Log_Index + 1;
         end if;
      end if;
   end Put;

   procedure Put (Str : String) with
      Pre => Log_Memory /= Musinfo.Null_Memregion;

   procedure Put (Str : String)
   is
   begin
      for Char of Str loop
         Put (Char);
      end loop;
   end Put;

   procedure Check_Channel;

   procedure Check_Channel
   is
      S_Name : constant String := "runtime_log";
      Name : Musinfo.Name_Type :=
         (Length    => 0,
          Padding   => 0,
          Data      => (others => Character'First),
          Null_Term => Character'First);
   begin
      if not Log_Activated then
         Name.Length := Musinfo.Name_Size_Type (S_Name'Length);
         Name.Data (1 .. S_Name'Length) := Musinfo.Name_Data_Type (S_Name);
         Log_Memory := Musinfo.Instance.Memory_By_Name (Name);
         if Log_Memory /= Musinfo.Null_Memregion then
            Activate_Channel (Log_Memory);
            Log_Activated := True;
         end if;
      end if;
   end Check_Channel;

   procedure Log_Debug (S : String)
   is
   begin
      Check_Channel;
      if Log_Memory /= Musinfo.Null_Memregion then
         Put ("Info: " & S);
      end if;
   end Log_Debug;

   procedure Log_Warning (S : String)
   is
   begin
      Check_Channel;
      if Log_Memory /= Musinfo.Null_Memregion then
         Put ("Warning: " & S);
      end if;
   end Log_Warning;

   procedure Log_Error (S : String)
   is
   begin
      Check_Channel;
      if Log_Memory /= Musinfo.Null_Memregion then
         Put ("Error: " & S);
      end if;
   end Log_Error;

   procedure Unhandled_Terminate with
      Export,
      Convention => C,
      External_Name => "__gnat_unhandled_terminate";

   procedure Unhandled_Terminate
   is
   begin
      SK.CPU.Stop;
   end Unhandled_Terminate;

   function Personality (Version : Integer;
                         Phase   : Long_Integer;
                         Class   : Natural;
                         Exc     : System.Address;
                         Context : System.Address) return Gnat_Helpers.URC with
      Export,
      Convention => C,
      External_Name => "__gnat_personality_v0";

   function Personality (Version : Integer;
                         Phase   : Long_Integer;
                         Class   : Natural;
                         Exc     : System.Address;
                         Context : System.Address) return Gnat_Helpers.URC
   is
   begin
      SK.CPU.Stop;
      return Gnat_Helpers.Foreign_Exception_Caught;
   end Personality;

   procedure Raise_Ada_Exception (E : CRE.Exception_Type;
                                  N : String;
                                  M : String)
   is
      pragma Unreferenced (E);
   begin
      Log_Error (N & ": " & M);
      SK.CPU.Stop;
   end Raise_Ada_Exception;

   procedure Initialize
   is
   begin
      Check_Channel;
   end Initialize;

   procedure Finalize
   is
   begin
      null;
   end Finalize;

   procedure Unwind_Resume with
      Export,
      Convention => C,
      External_Name => "_Unwind_Resume";

   procedure Unwind_Resume
   is
   begin
      SK.CPU.Stop;
   end Unwind_Resume;

end Componolit_Runtime;
