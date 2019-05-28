
with Runtime_Lib.Strings;
with SK.CPU;
with Debuglog.Client;

package body Muen with
   SPARK_Mode
is

   type Byte is mod 2 ** 8 with
      Size => 8;
   type Stack is array (Natural range <>) of Byte;

   Secondary_Stack : Stack (1 .. 1024 ** 2) := (others => 0);

   procedure Allocate_Secondary_Stack (Size    : Natural;
                                       Address : out System.Address)
   is
   begin
      if Size = 0 or else Size > Secondary_Stack'Last then
         Address := System.Null_Address;
      else
         Address := Secondary_Stack (Secondary_Stack'First)'Address;
      end if;
   end Allocate_Secondary_Stack;

   procedure Log_Debug (M : System.Address)
   is
   begin
      Debuglog.Client.Put_Line
         ("Info: " & Runtime_Lib.Strings.Convert_To_Ada
                        (M, "Invalid string."));
   end Log_Debug;

   procedure Log_Warning (M : System.Address)
   is
   begin
      Debuglog.Client.Put_Line
         ("Warning: " & Runtime_Lib.Strings.Convert_To_Ada
                           (M, "Invalid string."));
   end Log_Warning;

   procedure Log_Error (M : System.Address)
   is
   begin
      Debuglog.Client.Put_Line
         ("Error: " & Runtime_Lib.Strings.Convert_To_Ada
                         (M, "Invalid string."));
   end Log_Error;

   procedure Unhandled_Terminate
   is
   begin
      SK.CPU.Stop;
   end Unhandled_Terminate;

   function Personality_V0 (Status  : Integer;
                            Phase   : System.Address;
                            Class   : Natural;
                            Exc     : System.Address;
                            Context : System.Address) return Integer
   is
   begin
      SK.CPU.Stop;
      return 1;
   end Personality_V0;

   procedure Raise_Ada_Exception (T : Integer;
                                  N : System.Address;
                                  S : System.Address)
   is
   begin
      SK.CPU.Stop;
   end Raise_Ada_Exception;

   procedure Unwind_Resume
   is
   begin
      SK.CPU.Stop;
   end Unwind_Resume;

end Muen;
