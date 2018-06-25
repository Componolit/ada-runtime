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

with External;
with System.Standard_Library; use System.Standard_Library;

package body Ada.Exceptions is

   ----------------------------
   -- Raise_Exception_Always --
   ----------------------------

   procedure Raise_Ada_Exception (Name : System.Address;
                                  Msg  : System.Address)
     with Import,
          Convention => C,
          External_Name => "raise_ada_exception";

   procedure Raise_Exception_Always (E       : Exception_Id;
                                     Message : String := "") is
      C_Msg : String := Message & Character'Val (0);
   begin
      External.Warn_Not_Implemented ("Raise_Exception_Always");
      Raise_Ada_Exception (E.Full_Name, C_Msg'Address);
   end Raise_Exception_Always;

   procedure Raise_Exception (E       : Exception_Id;
                              Message : String := "") is
   begin
      Raise_Exception_Always (E, Message);
   end Raise_Exception;

   procedure Reraise_Occurrence_No_Defer (X : Exception_Occurrence) is
      pragma Unreferenced (X);
   begin
      External.Warn_Not_Implemented ("Reraise_Occurrence_No_Defer");
   end Reraise_Occurrence_No_Defer;

   procedure Save_Occurrence (Target : out Exception_Occurrence;
                              Source : Exception_Occurrence) is
   begin
      External.Warn_Not_Implemented ("Save_Occurrence");
      Target := Source;
   end Save_Occurrence;

   procedure Last_Chance_Handler (Except : Exception_Occurrence) is
      pragma Unreferenced (Except);
      procedure Unhandled_Terminate
         with Import,
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

   use ASCII;

   Rmsg_00 : constant String := "access check failed"              & NUL;
   Rmsg_01 : constant String := "access parameter is null"         & NUL;
   Rmsg_02 : constant String := "discriminant check failed"        & NUL;
   Rmsg_03 : constant String := "divide by zero"                   & NUL;
   Rmsg_04 : constant String := "explicit raise"                   & NUL;
   Rmsg_05 : constant String := "index check failed"               & NUL;
   Rmsg_06 : constant String := "invalid data"                     & NUL;
   Rmsg_07 : constant String := "length check failed"              & NUL;
   Rmsg_08 : constant String := "null Exception_Id"                & NUL;
   Rmsg_09 : constant String := "null-exclusion check failed"      & NUL;
   Rmsg_10 : constant String := "overflow check failed"            & NUL;
   Rmsg_11 : constant String := "partition check failed"           & NUL;
   Rmsg_12 : constant String := "range check failed"               & NUL;
   Rmsg_13 : constant String := "tag check failed"                 & NUL;
   Rmsg_14 : constant String := "access before elaboration"        & NUL;
   Rmsg_15 : constant String := "accessibility check failed"       & NUL;
   Rmsg_16 : constant String := "attempt to take address of"       &
                                " intrinsic subprogram"            & NUL;
   Rmsg_17 : constant String := "aliased parameters"               & NUL;
   Rmsg_18 : constant String := "all guards closed"                & NUL;
   Rmsg_19 : constant String := "improper use of generic subtype"  &
                                " with predicate"                  & NUL;
   Rmsg_20 : constant String := "Current_Task referenced in entry" &
                                " body"                            & NUL;
   Rmsg_21 : constant String := "duplicated entry address"         & NUL;
   Rmsg_22 : constant String := "explicit raise"                   & NUL;
   Rmsg_23 : constant String := "finalize/adjust raised exception" & NUL;
   Rmsg_24 : constant String := "implicit return with No_Return"   & NUL;
   Rmsg_25 : constant String := "misaligned address value"         & NUL;
   Rmsg_26 : constant String := "missing return"                   & NUL;
   Rmsg_27 : constant String := "overlaid controlled object"       & NUL;
   Rmsg_28 : constant String := "potentially blocking operation"   & NUL;
   Rmsg_29 : constant String := "stubbed subprogram called"        & NUL;
   Rmsg_30 : constant String := "unchecked union restriction"      & NUL;
   Rmsg_31 : constant String := "actual/returned class-wide"       &
                                " value not transportable"         & NUL;
   Rmsg_32 : constant String := "empty storage pool"               & NUL;
   Rmsg_33 : constant String := "explicit raise"                   & NUL;
   Rmsg_34 : constant String := "infinite recursion"               & NUL;
   Rmsg_35 : constant String := "object too large"                 & NUL;
   Rmsg_36 : constant String := "stream operation not allowed"     & NUL;

   --------------------------------
   -- Run-Time Check Subprograms --
   --------------------------------

   function Create_File_Line_String (File : System.Address;
                                     Line : Integer) return String;

   function Create_File_Line_String (File : System.Address;
                                     Line : Integer) return String is
      File_Name : String (1 .. 128);
      File_Name_Length : Positive := 1;
   begin
      while To_Ptr (File) (File_Name_Length + 1) /= ASCII.NUL
         and then File_Name_Length < 128
      loop
         File_Name_Length := File_Name_Length + 1;
         File_Name (File_Name_Length) := To_Ptr (File) (File_Name_Length);
      end loop;

      declare
         Msg : constant String := File_Name & ":" & Integer'Image (Line) & NUL;
      begin
         return Msg;
      end;
   end Create_File_Line_String;

   procedure Rcheck_CE_Access_Check (File : System.Address;
                                     Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Access_Check";

   procedure Rcheck_CE_Access_Check (File : System.Address;
                                     Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_00'Address, Msg'Address);
   end Rcheck_CE_Access_Check;

   procedure Rcheck_CE_Null_Access_Parameter (File : System.Address;
                                              Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Null_Access_Parameter";

   procedure Rcheck_CE_Null_Access_Parameter (File : System.Address;
                                              Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_01'Address, Msg'Address);
   end Rcheck_CE_Null_Access_Parameter;

   procedure Rcheck_CE_Discriminant_Check (File : System.Address;
                                           Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Discriminant_Check";

   procedure Rcheck_CE_Discriminant_Check (File : System.Address;
                                           Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_02'Address, Msg'Address);
   end Rcheck_CE_Discriminant_Check;

   procedure Rcheck_CE_Divide_By_Zero (File : System.Address;
                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Divide_By_Zero";

   procedure Rcheck_CE_Divide_By_Zero (File : System.Address;
                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_03'Address, Msg'Address);
   end Rcheck_CE_Divide_By_Zero;

   procedure Rcheck_CE_Explicit_Raise (File : System.Address;
                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Explicit_Raise";

   procedure Rcheck_CE_Explicit_Raise (File : System.Address;
                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_04'Address, Msg'Address);
   end Rcheck_CE_Explicit_Raise;

   procedure Rcheck_CE_Index_Check (File : System.Address;
                                    Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Index_Check";

   procedure Rcheck_CE_Index_Check (File : System.Address;
                                    Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_05'Address, Msg'Address);
   end Rcheck_CE_Index_Check;

   procedure Rcheck_CE_Invalid_Data (File : System.Address;
                                     Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Invalid_Data";

   procedure Rcheck_CE_Invalid_Data (File : System.Address;
                                     Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_06'Address, Msg'Address);
   end Rcheck_CE_Invalid_Data;

   procedure Rcheck_CE_Length_Check (File : System.Address;
                                     Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Length_Check";

   procedure Rcheck_CE_Length_Check (File : System.Address;
                                     Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_07'Address, Msg'Address);
   end Rcheck_CE_Length_Check;

   procedure Rcheck_CE_Null_Exception_Id (File : System.Address;
                                          Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Null_Exception_Id";

   procedure Rcheck_CE_Null_Exception_Id (File : System.Address;
                                          Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_08'Address, Msg'Address);
   end Rcheck_CE_Null_Exception_Id;

   procedure Rcheck_CE_Null_Not_Allowed (File : System.Address;
                                         Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Null_Not_Allowed";

   procedure Rcheck_CE_Null_Not_Allowed (File : System.Address;
                                         Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_09'Address, Msg'Address);
   end Rcheck_CE_Null_Not_Allowed;

   procedure Rcheck_CE_Overflow_Check (File : System.Address;
                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Overflow_Check";

   procedure Rcheck_CE_Overflow_Check (File : System.Address;
                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_10'Address, Msg'Address);
   end Rcheck_CE_Overflow_Check;

   procedure Rcheck_CE_Partition_Check (File : System.Address;
                                        Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Partition_Check";

   procedure Rcheck_CE_Partition_Check (File : System.Address;
                                        Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_11'Address, Msg'Address);
   end Rcheck_CE_Partition_Check;

   procedure Rcheck_CE_Range_Check (File : System.Address;
                                    Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Range_Check";

   procedure Rcheck_CE_Range_Check (File : System.Address;
                                    Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_12'Address, Msg'Address);
   end Rcheck_CE_Range_Check;

   procedure Rcheck_CE_Tag_Check (File : System.Address;
                                  Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_CE_Tag_Check";

   procedure Rcheck_CE_Tag_Check (File : System.Address;
                                  Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_13'Address, Msg'Address);
   end Rcheck_CE_Tag_Check;

   procedure Rcheck_PE_Access_Before_Elaboration (File : System.Address;
                                                  Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Access_Before_Elaboration";

   procedure Rcheck_PE_Access_Before_Elaboration (File : System.Address;
                                                  Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_14'Address, Msg'Address);
   end Rcheck_PE_Access_Before_Elaboration;

   procedure Rcheck_PE_Accessibility_Check (File : System.Address;
                                            Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Accessibility_Check";

   procedure Rcheck_PE_Accessibility_Check (File : System.Address;
                                            Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_15'Address, Msg'Address);
   end Rcheck_PE_Accessibility_Check;

   procedure Rcheck_PE_Address_Of_Intrinsic (File : System.Address;
                                             Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Address_Of_Intrinsic";

   procedure Rcheck_PE_Address_Of_Intrinsic (File : System.Address;
                                             Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_16'Address, Msg'Address);
   end Rcheck_PE_Address_Of_Intrinsic;

   procedure Rcheck_PE_Aliased_Parameters (File : System.Address;
                                           Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Aliased_Parameters";

   procedure Rcheck_PE_Aliased_Parameters (File : System.Address;
                                           Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_17'Address, Msg'Address);
   end Rcheck_PE_Aliased_Parameters;

   procedure Rcheck_PE_All_Guards_Closed (File : System.Address;
                                          Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_All_Guards_Closed";

   procedure Rcheck_PE_All_Guards_Closed (File : System.Address;
                                          Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_18'Address, Msg'Address);
   end Rcheck_PE_All_Guards_Closed;

   procedure Rcheck_PE_Bad_Predicated_Generic_Type (File : System.Address;
                                                    Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Bad_Predicated_Generic_Type";

   procedure Rcheck_PE_Bad_Predicated_Generic_Type (File : System.Address;
                                                    Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_19'Address, Msg'Address);
   end Rcheck_PE_Bad_Predicated_Generic_Type;

   procedure Rcheck_PE_Current_Task_In_Entry_Body (File : System.Address;
                                                   Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Current_Task_In_Entry_Body";

   procedure Rcheck_PE_Current_Task_In_Entry_Body (File : System.Address;
                                                   Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_20'Address, Msg'Address);
   end Rcheck_PE_Current_Task_In_Entry_Body;

   procedure Rcheck_PE_Duplicated_Entry_Address (File : System.Address;
                                                 Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Duplicated_Entry_Address";

   procedure Rcheck_PE_Duplicated_Entry_Address (File : System.Address;
                                                 Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_21'Address, Msg'Address);
   end Rcheck_PE_Duplicated_Entry_Address;

   procedure Rcheck_PE_Explicit_Raise (File : System.Address;
                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Explicit_Raise";

   procedure Rcheck_PE_Explicit_Raise (File : System.Address;
                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_22'Address, Msg'Address);
   end Rcheck_PE_Explicit_Raise;

   procedure Rcheck_PE_Implicit_Return (File : System.Address;
                                        Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Implicit_Return";

   procedure Rcheck_PE_Implicit_Return (File : System.Address;
                                        Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_23'Address, Msg'Address);
   end Rcheck_PE_Implicit_Return;

   procedure Rcheck_PE_Misaligned_Address_Value (File : System.Address;
                                                 Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Misaligned_Address_Value";

   procedure Rcheck_PE_Misaligned_Address_Value (File : System.Address;
                                                 Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_24'Address, Msg'Address);
   end Rcheck_PE_Misaligned_Address_Value;

   procedure Rcheck_PE_Missing_Return (File : System.Address;
                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Missing_Return";

   procedure Rcheck_PE_Missing_Return (File : System.Address;
                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_25'Address, Msg'Address);
   end Rcheck_PE_Missing_Return;

   procedure Rcheck_PE_Overlaid_Controlled_Object (File : System.Address;
                                                   Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Overlaid_Controlled_Object";

   procedure Rcheck_PE_Overlaid_Controlled_Object (File : System.Address;
                                                   Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_26'Address, Msg'Address);
   end Rcheck_PE_Overlaid_Controlled_Object;

   procedure Rcheck_PE_Non_Transportable_Actual (File : System.Address;
                                                 Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Non_Transportable_Actual";

   procedure Rcheck_PE_Non_Transportable_Actual (File : System.Address;
                                                 Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_27'Address, Msg'Address);
   end Rcheck_PE_Non_Transportable_Actual;

   procedure Rcheck_PE_Potentially_Blocking_Operation (File : System.Address;
                                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Potentially_Blocking_Operation";

   procedure Rcheck_PE_Potentially_Blocking_Operation (File : System.Address;
                                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_28'Address, Msg'Address);
   end Rcheck_PE_Potentially_Blocking_Operation;

   procedure Rcheck_PE_Stream_Operation_Not_Allowed (File : System.Address;
                                                     Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Stream_Operation_Not_Allowed";

   procedure Rcheck_PE_Stream_Operation_Not_Allowed (File : System.Address;
                                                     Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_29'Address, Msg'Address);
   end Rcheck_PE_Stream_Operation_Not_Allowed;

   procedure Rcheck_PE_Stubbed_Subprogram_Called (File : System.Address;
                                                  Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Stubbed_Subprogram_Called";

   procedure Rcheck_PE_Stubbed_Subprogram_Called (File : System.Address;
                                                  Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_30'Address, Msg'Address);
   end Rcheck_PE_Stubbed_Subprogram_Called;

   procedure Rcheck_PE_Unchecked_Union_Restriction (File : System.Address;
                                                    Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Unchecked_Union_Restriction";

   procedure Rcheck_PE_Unchecked_Union_Restriction (File : System.Address;
                                                    Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_31'Address, Msg'Address);
   end Rcheck_PE_Unchecked_Union_Restriction;

   procedure Rcheck_PE_Finalize_Raised_Exception (File : System.Address;
                                                  Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_PE_Finalize_Raised_Exception";

   procedure Rcheck_PE_Finalize_Raised_Exception (File : System.Address;
                                                  Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_32'Address, Msg'Address);
   end Rcheck_PE_Finalize_Raised_Exception;

   procedure Rcheck_SE_Empty_Storage_Pool (File : System.Address;
                                           Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_SE_Empty_Storage_Pool";

   procedure Rcheck_SE_Empty_Storage_Pool (File : System.Address;
                                           Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_33'Address, Msg'Address);
   end Rcheck_SE_Empty_Storage_Pool;

   procedure Rcheck_SE_Explicit_Raise (File : System.Address;
                                       Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_SE_Explicit_Raise";

   procedure Rcheck_SE_Explicit_Raise (File : System.Address;
                                       Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_34'Address, Msg'Address);
   end Rcheck_SE_Explicit_Raise;

   procedure Rcheck_SE_Infinite_Recursion (File : System.Address;
                                           Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_SE_Infinite_Recursion";

   procedure Rcheck_SE_Infinite_Recursion (File : System.Address;
                                           Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_35'Address, Msg'Address);
   end Rcheck_SE_Infinite_Recursion;

   procedure Rcheck_SE_Object_Too_Large (File : System.Address;
                                         Line : Integer)
      with Export,
           Convention => C,
           External_Name => "__gnat_rcheck_SE_Object_Too_Large";

   procedure Rcheck_SE_Object_Too_Large (File : System.Address;
                                         Line : Integer) is
      Msg : String := Create_File_Line_String (File, Line);
   begin
      Raise_Ada_Exception (Rmsg_36'Address, Msg'Address);
   end Rcheck_SE_Object_Too_Large;

end Ada.Exceptions;
