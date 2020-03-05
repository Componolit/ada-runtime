
with System;
with Componolit.Runtime.Board;
with Gnat_Helpers;

package body Componolit_Runtime is

   procedure Log (S : String)
   is
   begin
      Componolit.Runtime.Board.Log (S);
   end Log;

   procedure Raise_Ada_Exception (E : CRE.Exception_Type;
                                  N : String;
                                  M : String)
   is
      pragma Unreferenced (E);
   begin
      Componolit.Runtime.Board.Log (N & ": " & M);
      Componolit.Runtime.Board.Halt_On_Error;
   end Raise_Ada_Exception;

   procedure Initialize
   is
   begin
      Componolit.Runtime.Board.Initialize;
   end Initialize;

   procedure Finalize
   is
   begin
      null;
   end Finalize;

   function Personality (State   : Gnat_Helpers.US;
                         Header  : System.Address;
                         Context : System.Address) return Gnat_Helpers.URC with
      Export,
      Convention    => C,
      External_Name => "__gnat_personality_v0";

   function Personality (State   : Gnat_Helpers.US;
                         Header  : System.Address;
                         Context : System.Address) return Gnat_Helpers.URC
   is
      pragma Unreferenced (State);
      pragma Unreferenced (Header);
      pragma Unreferenced (Context);
   begin
      return Gnat_Helpers.Failure;
   end Personality;

   procedure Unhandled_Terminate with
      Export,
      Convention    => C,
      External_Name => "__gnat_unhandled_terminate";

   procedure Unhandled_Terminate
   is
   begin
      Componolit.Runtime.Board.Halt_On_Error;
   end Unhandled_Terminate;

   procedure System_Abort with
      Export,
      Convention    => C,
      External_Name => "abort";

   procedure System_Abort
   is
   begin
      Componolit.Runtime.Board.Halt_On_Error;
   end System_Abort;

   procedure System_Exit with
      Export,
      Convention    => C,
      External_Name => "_exit";

   procedure System_Exit
   is
   begin
      Componolit.Runtime.Board.Poweroff;
   end System_Exit;

   procedure Breakpoint with
      Export,
      Convention    => C,
      External_Name => "__gnat_bkpt_trap";

   procedure Breakpoint is null;

end Componolit_Runtime;
