
procedure Test is
   procedure Init (V1 : Long_Integer;
                   V2 : out Long_Integer)
   is
   begin
      V2 := V1;
   end Init;
   U1 : Long_Integer;
   U2 : Long_Integer;
   L1 : Long_Integer;
   I1 : Long_Integer;
begin
   --  Init via procedure to keep compiler from optimizing
   Init (42, U1);
   Init (24, U2);
   --  Test Add_With_Ovflo_Check
   L1 := U1 + U2;
   --  Test Multiply_With_Ovflo_Check
   I1 := L1 * U2;
   --  Test Subtract_With_Ovflo_Check
   U1 := U1 - U2;
   U2 := U2 / U1;
end Test;
