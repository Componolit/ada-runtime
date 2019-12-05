
with Parent;

package Child is

   type Object is new Parent.Object with record
      null;
   end record;

   overriding function Is_Parent (O : Object) return Boolean;

end Child;
