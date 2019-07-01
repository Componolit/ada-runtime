
with System;
with Componolit.Runtime.Exceptions;

package Componolit_Runtime
is
   package CRE renames Componolit.Runtime.Exceptions;

   procedure Log_Debug (S : String);

   procedure Log_Warning (S : String);

   procedure Log_Error (S : String);

   procedure Raise_Ada_Exception (E : CRE.Exception_Type;
                                  N : String;
                                  M : String);

   procedure Initialize with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_initialize";

   procedure Finalize with
      Export,
      Convention => C,
      External_Name => "componolit_runtime_finalize";

end Componolit_Runtime;
