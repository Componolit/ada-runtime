
with Parent;
with Child;

procedure Test
is
   function Is_Parent (O : Parent.Object'Class) return Boolean
   is
   begin
      return O.Is_Parent;
   end Is_Parent;
   O_P : Parent.Object;
   O_C : Child.Object;
begin
   if
      not O_P.Is_Parent
      or else O_C.Is_Parent
      or else not Is_Parent (O_P)
      or else Is_Parent (O_C)
      or else O_P not in Parent.Object'Class
      or else O_C not in Parent.Object'Class
      or else O_C not in Child.Object'Class
   then
      raise Program_Error;
   end if;
end Test;
