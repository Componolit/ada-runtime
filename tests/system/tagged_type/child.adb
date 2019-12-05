
with Componolit.Runtime.Debug;

package body Child is

   function Is_Parent (O : Object) return Boolean
   is
      pragma Unreferenced (O);
   begin
      return False;
   end Is_Parent;

end Child;
