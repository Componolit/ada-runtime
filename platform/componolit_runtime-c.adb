
with Componolit.Runtime.Strings;

package body Componolit_Runtime.C
is

   procedure C_Log_Debug (S : System.Address)
   is
   begin
      Log_Debug (Componolit.Runtime.Strings.Convert_To_Ada
         (S, "Invalid string."));
   end C_Log_Debug;

   procedure C_Log_Warning (S : System.Address)
   is
   begin
      Log_Warning (Componolit.Runtime.Strings.Convert_To_Ada
         (S, "Invalid string."));
   end C_Log_Warning;

   procedure C_Log_Error (S : System.Address)
   is
   begin
      Log_Error (Componolit.Runtime.Strings.Convert_To_Ada
         (S, "Invalid string."));
   end C_Log_Error;

   procedure C_Raise_Exception (E : CRE.Exception_Type;
                                N : System.Address;
                                M : System.Address)
   is
   begin
      Raise_Ada_Exception (E,
                           Componolit.Runtime.Strings.Convert_To_Ada
                              (N, "Unknown exception"),
                           Componolit.Runtime.Strings.Convert_To_Ada
                              (M, "Invalid message"));
   end C_Raise_Exception;

end Componolit_Runtime.C;
