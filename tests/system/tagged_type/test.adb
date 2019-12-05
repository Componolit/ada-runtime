
with Parent;
with Child;

procedure Test
is
   procedure Print (O : in out Parent.Object'Class)
   is
   begin
      O.Print;
   end Print;
   O_P : Parent.Object;
   O_C : Child.Object;
begin
   O_P.Print;
   O_C.Print;
   Print (O_P);
   Print (O_C);
end Test;
