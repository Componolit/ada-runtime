
with Componolit.Runtime.Strings;
with SK.CPU;
with Debuglog.Client;

package body Componolit_Runtime with
   SPARK_Mode
is

   type Byte is mod 2 ** 8 with
      Size => 8;
   type Stack is array (Natural range <>) of Byte;

   Secondary_Stack : Stack (1 .. 1024 ** 2) := (others => 0);

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

   procedure Log_Debug (S : System.Address)
   is
   begin
      Debuglog.Client.Put_Line
         ("Info: " & Componolit.Runtime.Strings.Convert_To_Ada
                        (S, "Invalid string."));
   end Log_Debug;

   procedure Log_Warning (S : System.Address)
   is
   begin
      Debuglog.Client.Put_Line
         ("Warning: " & Componolit.Runtime.Strings.Convert_To_Ada
                           (S, "Invalid string."));
   end Log_Warning;

   procedure Log_Error (S : System.Address)
   is
   begin
      Debuglog.Client.Put_Line
         ("Error: " & Componolit.Runtime.Strings.Convert_To_Ada
                         (S, "Invalid string."));
   end Log_Error;

   procedure Unhandled_Terminate
   is
   begin
      SK.CPU.Stop;
   end Unhandled_Terminate;

   function Personality (Version : Integer;
                         Phase   : Long_Integer;
                         Class   : Natural;
                         Exc     : System.Address;
                         Context : System.Address) return URC
   is
   begin
      SK.CPU.Stop;
      return Foreign_Exception_Caught;
   end Personality;

   procedure Raise_Ada_Exception (E : CRE.Exception_Type;
                                  N : System.Address;
                                  M : System.Address)
   is
   begin
      SK.CPU.Stop;
   end Raise_Ada_Exception;

   procedure Initialize
   is
   begin
      null;
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
