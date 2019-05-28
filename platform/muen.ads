
with System;

package Muen with
   SPARK_Mode
is

   procedure Allocate_Secondary_Stack (Size    : Natural;
                                       Address : out System.Address) with
      Export,
      Convention => C,
      External_Name => "allocate_secondary_stack";

   procedure Log_Debug (M : System.Address) with
      Export,
      Convention => C,
      External_Name => "log_debug";

   procedure Log_Warning (M : System.Address) with
      Export,
      Convention => C,
      External_Name => "log_warning";

   procedure Log_Error (M : System.Address) with
      Export,
      Convention => C,
      External_Name => "log_error";

   procedure Unhandled_Terminate with
      Export,
      Convention => C,
      External_Name => "__gnat_unhandled_terminate";

   function Personality_V0 (Status  : Integer;
                            Phase   : System.Address;
                            Class   : Natural;
                            Exc     : System.Address;
                            Context : System.Address) return Integer with
      Export,
      Convention => C,
      External_Name => "__gnat_personality_v0";

   procedure Raise_Ada_Exception (T : Integer;
                                  N : System.Address;
                                  S : System.Address) with
      Export,
      Convention => C,
      External_Name => "raise_ada_exception";

   procedure Unwind_Resume with
      Export,
      Convention => C,
      External_Name => "_Unwind_Resume";

end Muen;
