
with Componolit.Runtime.Debug;

package body Parent is

   function Is_Parent (O : Object) return Boolean
   is
      pragma Unreferenced (O);
   begin
      return True;
   end Is_Parent;

end Parent;
