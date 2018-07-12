------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       A D A . E X C E P T I O N S                        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2015, Free Software Foundation, Inc.         --
--          Copyright (C) 2018, Componolit GmbH                             --
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

pragma Compiler_Unit_Warning;

with Platform;
with Ada_Exceptions;
with System.Standard_Library; use System.Standard_Library;

package body Ada.Exceptions is

   ----------------------------
   -- Raise_Exception_Always --
   ----------------------------

   procedure Raise_Exception_Always (E       : Exception_Id;
                                     Message : String := "") is
      pragma Unreferenced (E);
   begin
      Platform.Log_Warning  ("Raise_Exception_Alwaysis not implemented");
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      Undefined_Exception,
                                    "Undefined_Exception",
                                    Message);
   end Raise_Exception_Always;

   procedure Raise_Exception (E       : Exception_Id;
                              Message : String := "") is
   begin
      Raise_Exception_Always (E, Message);
   end Raise_Exception;

   procedure Reraise_Occurrence_No_Defer (X : Exception_Occurrence) is
      pragma Unreferenced (X);
   begin
      Platform.Log_Warning  ("Reraise_Occurrence_No_Deferis not implemented");
   end Reraise_Occurrence_No_Defer;

   procedure Save_Occurrence (Target : out Exception_Occurrence;
                              Source : Exception_Occurrence) is
   begin
      Platform.Log_Warning  ("Save_Occurrenceis not implemented");
      Target := Source;
   end Save_Occurrence;

   procedure Last_Chance_Handler (Except : Exception_Occurrence) is
      pragma Unreferenced (Except);
      procedure Unhandled_Terminate
        with
          Import,
          Convention => C,
          External_Name => "__gnat_unhandled_terminate",
          No_Return;
      --  Perform system dependent shutdown code
   begin
      Unhandled_Terminate;
   end Last_Chance_Handler;

   ---------------------------------------------
   -- Reason Strings for Run-Time Check Calls --
   ---------------------------------------------

   Rmsg_00 : constant String := "access check failed";
   Rmsg_01 : constant String := "access parameter is null";
   Rmsg_02 : constant String := "discriminant check failed";
   Rmsg_03 : constant String := "divide by zero";
   Rmsg_04 : constant String := "explicit raise";
   Rmsg_05 : constant String := "index check failed";
   Rmsg_06 : constant String := "invalid data";
   Rmsg_07 : constant String := "length check failed";
   Rmsg_08 : constant String := "null Exception_Id";
   Rmsg_09 : constant String := "null-exclusion check failed";
   Rmsg_10 : constant String := "overflow check failed";
   Rmsg_11 : constant String := "partition check failed";
   Rmsg_12 : constant String := "range check failed";
   Rmsg_13 : constant String := "tag check failed";
   Rmsg_14 : constant String := "access before elaboration";
   Rmsg_15 : constant String := "accessibility check failed";
   Rmsg_16 : constant String := "attempt to take address of"       &
               " intrinsic subprogram";
   Rmsg_17 : constant String := "aliased parameters";
   Rmsg_18 : constant String := "all guards closed";
   Rmsg_19 : constant String := "improper use of generic subtype"  &
               " with predicate";
   Rmsg_20 : constant String := "Current_Task referenced in entry" &
               " body";
   Rmsg_21 : constant String := "duplicated entry address";
   Rmsg_22 : constant String := "explicit raise";
   Rmsg_23 : constant String := "finalize/adjust raised exception";
   Rmsg_24 : constant String := "implicit return with No_Return";
   Rmsg_25 : constant String := "misaligned address value";
   Rmsg_26 : constant String := "missing return";
   Rmsg_27 : constant String := "overlaid controlled object";
   Rmsg_28 : constant String := "potentially blocking operation";
   Rmsg_29 : constant String := "stubbed subprogram called";
   Rmsg_30 : constant String := "unchecked union restriction";
   Rmsg_31 : constant String := "actual/returned class-wide"       &
               " value not transportable";
   Rmsg_32 : constant String := "empty storage pool";
   Rmsg_33 : constant String := "explicit raise";
   Rmsg_34 : constant String := "infinite recursion";
   Rmsg_35 : constant String := "object too large";
   Rmsg_36 : constant String := "stream operation not allowed";

   --------------------------------
   -- Run-Time Check Subprograms --
   --------------------------------

   function Create_File_Line_String (File : System.Address;
                                     Line : Integer) return String;

   function Create_File_Line_String (File : System.Address;
                                     Line : Integer) return String is
      Name_Length : Integer := 0;
   begin
      while To_Ptr (File) (Name_Length + 1) /= ASCII.NUL loop
         Name_Length := Name_Length + 1;
      end loop;

      if Name_Length = 0 then
         return "unknown file" & ASCII.NUL;
      end if;

      declare
         Name : String (1 .. Name_Length);
      begin
         for I in Integer range 1 .. Name_Length loop
            Name (I) := To_Ptr (File) (I);
         end loop;

         declare
            Msg : constant String := Name & ":" & Integer'Image (Line)
                                        & ASCII.NUL;
         begin
            return Msg;
         end;
      end;
   end Create_File_Line_String;

   procedure Rcheck_CE_Access_Check (File : System.Address;
                                     Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Access_Check";

   procedure Rcheck_CE_Access_Check (File : System.Address;
                                     Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Access_Check,
                                    Rmsg_00, Msg);
   end Rcheck_CE_Access_Check;

   procedure Rcheck_CE_Null_Access_Parameter (File : System.Address;
                                              Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Null_Access_Parameter";

   procedure Rcheck_CE_Null_Access_Parameter (File : System.Address;
                                              Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Null_Access_Parameter,
                                    Rmsg_01, Msg);
   end Rcheck_CE_Null_Access_Parameter;

   procedure Rcheck_CE_Discriminant_Check (File : System.Address;
                                           Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Discriminant_Check";

   procedure Rcheck_CE_Discriminant_Check (File : System.Address;
                                           Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Discriminant_Check,
                                    Rmsg_02, Msg);
   end Rcheck_CE_Discriminant_Check;

   procedure Rcheck_CE_Divide_By_Zero (File : System.Address;
                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Divide_By_Zero";

   procedure Rcheck_CE_Divide_By_Zero (File : System.Address;
                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Divide_By_Zero,
                                    Rmsg_03, Msg);
   end Rcheck_CE_Divide_By_Zero;

   procedure Rcheck_CE_Explicit_Raise (File : System.Address;
                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Explicit_Raise";

   procedure Rcheck_CE_Explicit_Raise (File : System.Address;
                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Explicit_Raise,
                                    Rmsg_04, Msg);
   end Rcheck_CE_Explicit_Raise;

   procedure Rcheck_CE_Index_Check (File : System.Address;
                                    Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Index_Check";

   procedure Rcheck_CE_Index_Check (File : System.Address;
                                    Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Index_Check,
                                    Rmsg_05, Msg);
   end Rcheck_CE_Index_Check;

   procedure Rcheck_CE_Invalid_Data (File : System.Address;
                                     Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Invalid_Data";

   procedure Rcheck_CE_Invalid_Data (File : System.Address;
                                     Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Invalid_Data,
                                    Rmsg_06, Msg);
   end Rcheck_CE_Invalid_Data;

   procedure Rcheck_CE_Length_Check (File : System.Address;
                                     Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Length_Check";

   procedure Rcheck_CE_Length_Check (File : System.Address;
                                     Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Length_Check,
                                    Rmsg_07, Msg);
   end Rcheck_CE_Length_Check;

   procedure Rcheck_CE_Null_Exception_Id (File : System.Address;
                                          Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Null_Exception_Id";

   procedure Rcheck_CE_Null_Exception_Id (File : System.Address;
                                          Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Null_Exception_Id,
                                    Rmsg_08, Msg);
   end Rcheck_CE_Null_Exception_Id;

   procedure Rcheck_CE_Null_Not_Allowed (File : System.Address;
                                         Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Null_Not_Allowed";

   procedure Rcheck_CE_Null_Not_Allowed (File : System.Address;
                                         Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Null_Not_Allowed,
                                    Rmsg_09, Msg);
   end Rcheck_CE_Null_Not_Allowed;

   procedure Rcheck_CE_Overflow_Check (File : System.Address;
                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Overflow_Check";

   procedure Rcheck_CE_Overflow_Check (File : System.Address;
                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Overflow_Check,
                                    Rmsg_10, Msg);
   end Rcheck_CE_Overflow_Check;

   procedure Rcheck_CE_Partition_Check (File : System.Address;
                                        Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Partition_Check";

   procedure Rcheck_CE_Partition_Check (File : System.Address;
                                        Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Partition_Check,
                                    Rmsg_11, Msg);
   end Rcheck_CE_Partition_Check;

   procedure Rcheck_CE_Range_Check (File : System.Address;
                                    Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Range_Check";

   procedure Rcheck_CE_Range_Check (File : System.Address;
                                    Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Range_Check,
                                    Rmsg_12, Msg);
   end Rcheck_CE_Range_Check;

   procedure Rcheck_CE_Tag_Check (File : System.Address;
                                  Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_CE_Tag_Check";

   procedure Rcheck_CE_Tag_Check (File : System.Address;
                                  Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      CE_Tag_Check,
                                    Rmsg_13, Msg);
   end Rcheck_CE_Tag_Check;

   procedure Rcheck_PE_Access_Before_Elaboration (File : System.Address;
                                                  Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Access_Before_Elaboration";

   procedure Rcheck_PE_Access_Before_Elaboration (File : System.Address;
                                                  Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Access_Before_Elaboration,
                                    Rmsg_14, Msg);
   end Rcheck_PE_Access_Before_Elaboration;

   procedure Rcheck_PE_Accessibility_Check (File : System.Address;
                                            Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Accessibility_Check";

   procedure Rcheck_PE_Accessibility_Check (File : System.Address;
                                            Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Accessibility_Check,
                                    Rmsg_15, Msg);
   end Rcheck_PE_Accessibility_Check;

   procedure Rcheck_PE_Address_Of_Intrinsic (File : System.Address;
                                             Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Address_Of_Intrinsic";

   procedure Rcheck_PE_Address_Of_Intrinsic (File : System.Address;
                                             Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Address_Of_Intrinsic,
                                    Rmsg_16, Msg);
   end Rcheck_PE_Address_Of_Intrinsic;

   procedure Rcheck_PE_Aliased_Parameters (File : System.Address;
                                           Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Aliased_Parameters";

   procedure Rcheck_PE_Aliased_Parameters (File : System.Address;
                                           Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Aliased_Parameters,
                                    Rmsg_17, Msg);
   end Rcheck_PE_Aliased_Parameters;

   procedure Rcheck_PE_All_Guards_Closed (File : System.Address;
                                          Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_All_Guards_Closed";

   procedure Rcheck_PE_All_Guards_Closed (File : System.Address;
                                          Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_All_Guards_Closed,
                                    Rmsg_18, Msg);
   end Rcheck_PE_All_Guards_Closed;

   procedure Rcheck_PE_Bad_Predicated_Generic_Type (File : System.Address;
                                                    Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Bad_Predicated_Generic_Type";

   procedure Rcheck_PE_Bad_Predicated_Generic_Type (File : System.Address;
                                                    Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Bad_Predicated_Generic_Type,
                                    Rmsg_19, Msg);
   end Rcheck_PE_Bad_Predicated_Generic_Type;

   procedure Rcheck_PE_Current_Task_In_Entry_Body (File : System.Address;
                                                   Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Current_Task_In_Entry_Body";

   procedure Rcheck_PE_Current_Task_In_Entry_Body (File : System.Address;
                                                   Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Current_Task_In_Entry_Body,
                                    Rmsg_20, Msg);
   end Rcheck_PE_Current_Task_In_Entry_Body;

   procedure Rcheck_PE_Duplicated_Entry_Address (File : System.Address;
                                                 Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Duplicated_Entry_Address";

   procedure Rcheck_PE_Duplicated_Entry_Address (File : System.Address;
                                                 Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Duplicated_Entry_Address,
                                    Rmsg_21, Msg);
   end Rcheck_PE_Duplicated_Entry_Address;

   procedure Rcheck_PE_Explicit_Raise (File : System.Address;
                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Explicit_Raise";

   procedure Rcheck_PE_Explicit_Raise (File : System.Address;
                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Explicit_Raise,
                                    Rmsg_22, Msg);
   end Rcheck_PE_Explicit_Raise;

   procedure Rcheck_PE_Implicit_Return (File : System.Address;
                                        Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Implicit_Return";

   procedure Rcheck_PE_Implicit_Return (File : System.Address;
                                        Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Implicit_Return,
                                    Rmsg_23, Msg);
   end Rcheck_PE_Implicit_Return;

   procedure Rcheck_PE_Misaligned_Address_Value (File : System.Address;
                                                 Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Misaligned_Address_Value";

   procedure Rcheck_PE_Misaligned_Address_Value (File : System.Address;
                                                 Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Misaligned_Address_Value,
                                    Rmsg_24, Msg);
   end Rcheck_PE_Misaligned_Address_Value;

   procedure Rcheck_PE_Missing_Return (File : System.Address;
                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Missing_Return";

   procedure Rcheck_PE_Missing_Return (File : System.Address;
                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Missing_Return,
                                    Rmsg_25, Msg);
   end Rcheck_PE_Missing_Return;

   procedure Rcheck_PE_Overlaid_Controlled_Object (File : System.Address;
                                                   Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Overlaid_Controlled_Object";

   procedure Rcheck_PE_Overlaid_Controlled_Object (File : System.Address;
                                                   Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Overlaid_Controlled_Object,
                                    Rmsg_26, Msg);
   end Rcheck_PE_Overlaid_Controlled_Object;

   procedure Rcheck_PE_Non_Transportable_Actual (File : System.Address;
                                                 Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Non_Transportable_Actual";

   procedure Rcheck_PE_Non_Transportable_Actual (File : System.Address;
                                                 Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Non_Transportable_Actual,
                                    Rmsg_27, Msg);
   end Rcheck_PE_Non_Transportable_Actual;

   procedure Rcheck_PE_Potentially_Blocking_Operation (File : System.Address;
                                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Potentially_Blocking_Operation";

   procedure Rcheck_PE_Potentially_Blocking_Operation (File : System.Address;
                                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Potentially_Blocking_Operation,
                                    Rmsg_28, Msg);
   end Rcheck_PE_Potentially_Blocking_Operation;

   procedure Rcheck_PE_Stream_Operation_Not_Allowed (File : System.Address;
                                                     Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Stream_Operation_Not_Allowed";

   procedure Rcheck_PE_Stream_Operation_Not_Allowed (File : System.Address;
                                                     Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Stream_Operation_Not_Allowed,
                                    Rmsg_29, Msg);
   end Rcheck_PE_Stream_Operation_Not_Allowed;

   procedure Rcheck_PE_Stubbed_Subprogram_Called (File : System.Address;
                                                  Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Stubbed_Subprogram_Called";

   procedure Rcheck_PE_Stubbed_Subprogram_Called (File : System.Address;
                                                  Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Stubbed_Subprogram_Called,
                                    Rmsg_30, Msg);
   end Rcheck_PE_Stubbed_Subprogram_Called;

   procedure Rcheck_PE_Unchecked_Union_Restriction (File : System.Address;
                                                    Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Unchecked_Union_Restriction";

   procedure Rcheck_PE_Unchecked_Union_Restriction (File : System.Address;
                                                    Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Unchecked_Union_Restriction,
                                    Rmsg_31, Msg);
   end Rcheck_PE_Unchecked_Union_Restriction;

   procedure Rcheck_PE_Finalize_Raised_Exception (File : System.Address;
                                                  Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_PE_Finalize_Raised_Exception";

   procedure Rcheck_PE_Finalize_Raised_Exception (File : System.Address;
                                                  Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      PE_Finalize_Raised_Exception,
                                    Rmsg_32, Msg);
   end Rcheck_PE_Finalize_Raised_Exception;

   procedure Rcheck_SE_Empty_Storage_Pool (File : System.Address;
                                           Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_SE_Empty_Storage_Pool";

   procedure Rcheck_SE_Empty_Storage_Pool (File : System.Address;
                                           Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      SE_Empty_Storage_Pool,
                                    Rmsg_33, Msg);
   end Rcheck_SE_Empty_Storage_Pool;

   procedure Rcheck_SE_Explicit_Raise (File : System.Address;
                                       Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_SE_Explicit_Raise";

   procedure Rcheck_SE_Explicit_Raise (File : System.Address;
                                       Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      SE_Explicit_Raise,
                                    Rmsg_34, Msg);
   end Rcheck_SE_Explicit_Raise;

   procedure Rcheck_SE_Infinite_Recursion (File : System.Address;
                                           Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_SE_Infinite_Recursion";

   procedure Rcheck_SE_Infinite_Recursion (File : System.Address;
                                           Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      SE_Infinite_Recursion,
                                    Rmsg_35, Msg);
   end Rcheck_SE_Infinite_Recursion;

   procedure Rcheck_SE_Object_Too_Large (File : System.Address;
                                         Line : Integer)
     with
       Export,
       Convention => C,
       External_Name => "__gnat_rcheck_SE_Object_Too_Large";

   procedure Rcheck_SE_Object_Too_Large (File : System.Address;
                                         Line : Integer) is
      Msg : constant String := Create_File_Line_String (File, Line);
   begin
      Platform.Raise_Ada_Exception (Ada_Exceptions.
                                      SE_Object_Too_Large,
                                    Rmsg_36, Msg);
   end Rcheck_SE_Object_Too_Large;

end Ada.Exceptions;
