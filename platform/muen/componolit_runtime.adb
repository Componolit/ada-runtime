
with System;
with SK.CPU;
with Debuglog.Client;
with Gnat_Helpers;

package body Componolit_Runtime with
   SPARK_Mode
is

   procedure Log_Debug (S : String)
   is
   begin
      Debuglog.Client.Put_Line
         ("Info: " & S);
   end Log_Debug;

   procedure Log_Warning (S : String)
   is
   begin
      Debuglog.Client.Put_Line
         ("Warning: " & S);
   end Log_Warning;

   procedure Log_Error (S : String)
   is
   begin
      Debuglog.Client.Put_Line
         ("Error: " & S);
   end Log_Error;

   procedure Unhandled_Terminate with
      Export,
      Convention => C,
      External_Name => "__gnat_unhandled_terminate";

   procedure Unhandled_Terminate
   is
   begin
      Debuglog.Client.Put_Line ("Unhandled_Terminate called, stopping.");
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
