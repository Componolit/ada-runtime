------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                             E X P _ I N T R                              --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2014, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT; see file COPYING3.  If not, go to --
-- http://www.gnu.org/licenses for a complete copy of the license.          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  Processing for expanding intrinsic subprogram calls

with Namet; use Namet;
with Types; use Types;

package Exp_Intr is

   procedure Add_Source_Info (Loc : Source_Ptr; Nam : Name_Id);
   --  Append a string to Name_Buffer depending on Nam
   --    Name_File                  - append name of source file
   --    Name_Line                  - append line number
   --    Name_Source_Location       - append source location (file:line)
   --    Name_Enclosing_Entity      - append name of enclosing entity
   --    Name_Compilation_Date      - append compilation date
   --    Name_Compilation_Time      - append compilation time
   --  The caller must set Name_Buffer and Name_Len before the call. Loc is
   --  passed to provide location information where it is needed.

   procedure Expand_Intrinsic_Call (N : Node_Id; E : Entity_Id);
   --  N is either a function call node, a procedure call statement node, or
   --  an operator where the corresponding subprogram is intrinsic (i.e. was
   --  the subject of an Import or Interface pragma specifying the subprogram
   --  as intrinsic. The effect is to replace the call with appropriate
   --  specialized nodes. The second argument is the entity for the
   --  subprogram spec.

end Exp_Intr;
