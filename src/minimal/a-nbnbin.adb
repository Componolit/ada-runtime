package body Ada.Numerics.Big_Numbers.Big_Integers
is
   --  We enforce a body in the spec, as the orignial version in the runtime
   --  has one. If the contrib directory is in our search path, we get an error
   --  that the body contained therein must not exist. With this dummy body,
   --  earlier in the search path, this problem is solved.
end Ada.Numerics.Big_Numbers.Big_Integers;
