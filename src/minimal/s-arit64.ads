------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . A R I T H _ 6 4                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2018, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  Copyright (C) 2019 Componolit GmbH
--  Copyright (C) 1992-2015, Free Software Foundation, Inc.
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

--  This unit provides software routines for doing arithmetic on 64-bit
--  signed integer values in cases where either overflow checking is
--  required, or intermediate results are longer than 64 bits.

pragma Restrictions (No_Elaboration_Code);
--  Allow direct call from gigi generated code

with Interfaces;

package System.Arith_64 with
   SPARK_Mode,
   Pure
is

   subtype Int64 is Interfaces.Integer_64;
   use type Interfaces.Integer_64;

   function Add_With_Ovflo_Check (X, Y : Int64) return Int64 with
      Pre     => (if X < 0 and Y <= 0 then Int64'First - X < Y)
                 and (if X >= 0 and Y >= 0 then Int64'Last - X >= Y),
      Post    => Add_With_Ovflo_Check'Result = X + Y,
      Global  => null,
      Depends => (Add_With_Ovflo_Check'Result => (X, Y));
   --  Raises Constraint_Error if sum of operands overflows 64 bits,
   --  otherwise returns the 64-bit signed integer sum.

   function Subtract_With_Ovflo_Check (X, Y : Int64) return Int64 with
      Pre     => (if X >= 0 and Y <= 0 then Y > Int64'First
                     and then Int64'Last - X >= abs (Y))
                 and (if X < 0 and Y > 0 then Y < Int64'First - X),
      Post    => Subtract_With_Ovflo_Check'Result = X - Y,
      Global  => null,
      Depends => (Subtract_With_Ovflo_Check'Result => (X, Y));
   --  Raises Constraint_Error if difference of operands overflows 64
   --  bits, otherwise returns the 64-bit signed integer difference.

   function Multiply_With_Ovflo_Check (X, Y : Int64) return Int64;
   pragma Export (C, Multiply_With_Ovflo_Check, "__gnat_mulv64");
   --  Raises Constraint_Error if product of operands overflows 64
   --  bits, otherwise returns the 64-bit signed integer product.
   --  GIGI may also call this routine directly.

   procedure Scaled_Divide
     (X, Y, Z : Int64;
      Q, R    : out Int64;
      Round   : Boolean);
   --  Performs the division of (X * Y) / Z, storing the quotient in Q
   --  and the remainder in R. Constraint_Error is raised if Z is zero,
   --  or if the quotient does not fit in 64-bits. Round indicates if
   --  the result should be rounded. If Round is False, then Q, R are
   --  the normal quotient and remainder from a truncating division.
   --  If Round is True, then Q is the rounded quotient. The remainder
   --  R is not affected by the setting of the Round flag.

   procedure Double_Divide
     (X, Y, Z : Int64;
      Q, R    : out Int64;
      Round   : Boolean);
   --  Performs the division X / (Y * Z), storing the quotient in Q and
   --  the remainder in R. Constraint_Error is raised if Y or Z is zero,
   --  or if the quotient does not fit in 64-bits. Round indicates if the
   --  result should be rounded. If Round is False, then Q, R are the normal
   --  quotient and remainder from a truncating division. If Round is True,
   --  then Q is the rounded quotient. The remainder R is not affected by the
   --  setting of the Round flag.

end System.Arith_64;
