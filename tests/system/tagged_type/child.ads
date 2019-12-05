
with Parent;

package Child is

   type Object is new Parent.Object with record
      null;
   end record;

   overriding procedure Print (O : in out Object);

end Child;
