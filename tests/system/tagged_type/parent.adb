
with Componolit.Runtime.Debug;

package body Parent is

   procedure Print (O : in out Object)
   is
      pragma Unreferenced (O);
   begin
      Componolit.Runtime.Debug.Log_Debug ("Parent");
   end Print;

end Parent;
