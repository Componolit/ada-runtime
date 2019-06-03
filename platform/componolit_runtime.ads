
with System;
with Componolit.Runtime.Exceptions;

package Componolit_Runtime
is
   package CRE renames Componolit.Runtime.Exceptions;

   type URC is (Foreign_Exception_Caught,
                Continue_Unwind);

   for URC use (Foreign_Exception_Caught => 1,
                Continue_Unwind          => 8);

   procedure Log_Debug (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_debug";

   procedure Log_Warning (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_warning";

   procedure Log_Error (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_error";

   procedure Unhandled_Terminate with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_unhandled_terminate";

   procedure Raise_Ada_Exception (E : CRE.Exception_Type;
                                  N : System.Address;
                                  M : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_raise_ada_exception";

   procedure Allocate_Secondary_Stack (Size :     Natural;
                                       Addr : out System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_allocate_secondary_stack";

   function Personality (Version : Integer;
                         Phase   : Long_Integer;
                         Class   : Natural;
                         Exc     : System.Address;
                         Context : System.Address) return URC with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_personality";

   procedure Initialize with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_initialize";

   procedure Finalize with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_finalize";

end Componolit_Runtime;
