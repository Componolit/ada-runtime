
with Componolit.Runtime.Exceptions;

package Componolit_Runtime.C
is
   package CRE renames Componolit.Runtime.Exceptions;

   procedure C_Log_Debug (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_debug";

   procedure C_Log_Warning (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_warning";

   procedure C_Log_Error (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log_error";

   procedure C_Raise_Exception (E : CRE.Exception_Type;
                                N : System.Address;
                                M : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_raise_ada_exception";

end Componolit_Runtime.C;
