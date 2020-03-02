
with Componolit.Runtime.Strings;

package body Componolit_Runtime.C
is

   procedure C_Log (S : System.Address)
   is
   begin
      Log (Componolit.Runtime.Strings.Convert_To_Ada
         (S, "Invalid string."));
   end C_Log;

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
