
package Parent is

   type Object is tagged record
      null;
   end record;

   function Is_Parent (O : Object) return Boolean;

end Parent;
