
package Ada.Numerics.Big_Numbers.Big_Integers with
   Preelaborate,
   Ghost
is

   type Big_Integer is private with
      Ghost;

   function Is_Valid (Arg : Big_Integer) return Boolean with
      Ghost,
      Import;

   function "=" (L, R : Big_Integer) return Boolean with
      Ghost,
      Import;

   function "<" (L, R : Big_Integer) return Boolean with
      Ghost,
      Import;

   function "<=" (L, R : Big_Integer) return Boolean with
      Ghost,
      Import;

   function ">" (L, R : Big_Integer) return Boolean with
      Ghost,
      Import;

   function ">=" (L, R : Big_Integer) return Boolean with
      Ghost,
      Import;

   function To_Big_Integer (Arg : Integer) return Big_Integer with
      Ghost,
      Import;

   subtype Big_Positive is Big_Integer with
      Dynamic_Predicate => (if Is_Valid (Big_Positive)
                            then Big_Positive > To_Big_Integer (0));

   subtype Big_Natural is Big_Integer with
      Dynamic_Predicate => (if Is_Valid (Big_Natural)
                            then Big_Natural >= To_Big_Integer (0));

   function In_Range (Arg, Low, High : Big_Integer) return Boolean is
      ((Low <= Arg) and then (Arg <= High)) with
      Ghost;

   function To_Integer (Arg : Big_Integer) return Integer with
      Pre => In_Range (Arg,
                       To_Big_Integer (Integer'First),
                       To_Big_Integer (Integer'Last)),
      Ghost,
      Import;

   generic
      type Int is range <>;
   package Signed_Conversions is

      --  This use clause is required to instantiate Signed_Conversions
      pragma Warnings
         (Off, "use clause for package ""Big_Integers"" has no effect");
      use Big_Integers;
      pragma Warnings
         (On, "use clause for package ""Big_Integers"" has no effect");

      function To_Big_Integer (Arg : Int) return Big_Integer with
         Ghost,
         Import;

      function From_Big_Integer (Arg : Big_Integer) return Int with
         Pre => In_Range (Arg,
                          To_Big_Integer (Int'First),
                          To_Big_Integer (Int'Last)),
         Ghost,
         Import;

   end Signed_Conversions;

   generic
      type Int is mod <>;
   package Unsigned_Conversions is

      --  This use clause is required to instantiate Unsigned_Conversions
      pragma Warnings
         (Off, "use clause for package ""Big_Integers"" has no effect");
      use Big_Integers;
      pragma Warnings
         (On, "use clause for package ""Big_Integers"" has no effect");

      function To_Big_Integer (Arg : Int) return Big_Integer with
         Ghost,
         Import;

      function From_Big_Integer (Arg : Big_Integer) return Int with
         Pre => In_Range (Arg,
                          To_Big_Integer (Int'First),
                          To_Big_Integer (Int'Last)),
         Ghost,
         Import;

   end Unsigned_Conversions;

   function "+" (L : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "-" (L : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "abs" (L : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "+" (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "-" (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "*" (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "/" (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "mod" (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "rem" (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function "**" (L : Big_Integer;
                  R : Natural) return Big_Integer with
      Ghost,
      Import;

   function Min (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function Max (L, R : Big_Integer) return Big_Integer with
      Ghost,
      Import;

   function Greates_Common_Divisor (L, R : Big_Integer)
      return Big_Positive with
      Pre => (L /= To_Big_Integer (0) and then R /= To_Big_Integer (0)),
      Ghost,
      Import;

private

   type Big_Integer is null record;

end Ada.Numerics.Big_Numbers.Big_Integers;
