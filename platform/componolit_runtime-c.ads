
with System;
with Componolit.Runtime.Exceptions;

package Componolit_Runtime.C
is
   package CRE renames Componolit.Runtime.Exceptions;

   procedure C_Log (S : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_log";

   procedure C_Raise_Exception (E : CRE.Exception_Type;
                                N : System.Address;
                                M : System.Address) with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_raise_ada_exception";

end Componolit_Runtime.C;
