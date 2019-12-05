
with Componolit.Runtime.Debug;

package body Child is

   procedure Print (O : in out Object)
   is
      pragma Unreferenced (O);
   begin
      Componolit.Runtime.Debug.Log_Debug ("Child");
   end Print;

end Child;
