
with System;
with Gnat_Helpers;

package body Componolit_Runtime is

   procedure Log (S : String)
   is
   begin
      null;
   end Log;

   procedure Raise_Ada_Exception (E : CRE.Exception_Type;
                                  N : String;
                                  M : String)
   is
   begin
      null;
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
      null;
   end Unhandled_Terminate;

   procedure System_Abort with
      Export,
      Convention    => C,
      External_Name => "abort";

   procedure System_Abort
   is
   begin
      null;
   end System_Abort;

   procedure System_Exit with
      Export,
      Convention    => C,
      External_Name => "_exit";

   procedure System_Exit
   is
   begin
      null;
   end System_Exit;

   procedure Breakpoint with
      Export,
      Convention    => C,
      External_Name => "__gnat_bkpt_trap";

   procedure Breakpoint is null;

end Componolit_Runtime;
