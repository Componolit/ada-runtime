--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

pragma Compiler_Unit_Warning;

with System;
with System.Standard_Library;

package Ada.Exceptions is
   pragma Preelaborate;
   --  We make this preelaborable. If we did not do this, then run time units
   --  used by the compiler (e.g. s-soflin.ads) would run into trouble.
   --  Conformance with Ada 95 is not an issue, since this version is used
   --  only by the compiler.

   type Exception_Id is private;
   type Exception_Occurrence is limited private;
   type Exception_Occurrence_Access is access all Exception_Occurrence;

   Null_Exception_Id : constant Exception_Id;

   procedure Raise_Exception_Always (E       : Exception_Id;
                                     Message : String := "")
     with
       Export,
       Convention => Ada,
       External_Name => "__gnat_raise_exception";

   procedure Raise_Exception (E       : Exception_Id;
                              Message : String := "");

   procedure Reraise_Occurrence_No_Defer (X : Exception_Occurrence);

   procedure Save_Occurrence (Target : out Exception_Occurrence;
                              Source : Exception_Occurrence);

   procedure Last_Chance_Handler (Except : Exception_Occurrence)
     with
       Export,
       Convention => Ada,
       External_Name => "__gnat_last_chance_handler";

private

   type Exception_Id is new System.Standard_Library.Exception_Data_Ptr;
   type Exception_Occurrence is record
      null;
   end record;

   Null_Exception_Id : constant Exception_Id := null;

end Ada.Exceptions;
