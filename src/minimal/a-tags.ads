--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

private with System;
private with System.Storage_Elements;
private with Componolit.Runtime.Compiler;

package Ada.Tags with
   Preelaborate,
   Elaborate_Body
is

   type Tag is private with
      Preelaborable_Initialization;

   No_Tag : constant Tag;

private

   package SSE renames System.Storage_Elements;
   use type SSE.Storage_Offset;

   subtype Cstring is String (Positive);
   type Cstring_Ptr is access all Cstring;
   pragma No_Strict_Aliasing (Cstring_Ptr);
   type Tag_Table is array (Natural range <>) of Tag;
   type Prim_Ptr is access procedure;
   type Address_Array is array (Positive range <>) of Prim_Ptr;
   subtype Dispatch_Table is Address_Array (1 .. 1);

   type Tag is access all Dispatch_Table;
   pragma No_Strict_Aliasing (Tag);

   No_Tag : constant Tag := null;

   type Type_Specific_Data (Depth : Natural) is record
      Access_Level       : Natural;
      Alignment          : Natural;
      Expanded_Name      : Cstring_Ptr;
      External_Tag       : Cstring_Ptr;
      Transportable      : Boolean;
      Needs_Finalization : Boolean;
      Tags_Table         : Tag_Table (0 .. Depth);
   end record;

   type Dispatch_Table_Wrapper (Procedure_Count : Natural) is record
      Predef_Prims  : System.Address;
      Offset_To_Top : SSE.Storage_Offset;
      TSD           : System.Address;
      Prims_Ptr     : Address_Array (1 .. Procedure_Count);
   end record;

   Max_Predef_Prims : constant Positive :=
      Componolit.Runtime.Compiler.Max_Predef_Prims;
   subtype Predef_Prims_Table is Address_Array (1 .. Max_Predef_Prims);
   type Predef_Prims_Table_Ptr is access Predef_Prims_Table;
   pragma No_Strict_Aliasing (Predef_Prims_Table_Ptr);

   DT_Predef_Prims_Size    : constant SSE.Storage_Count :=
      SSE.Storage_Count (Standard'Address_Size / System.Storage_Unit);
   DT_Offset_To_Top_Size   : constant SSE.Storage_Count :=
      SSE.Storage_Count (Standard'Address_Size / System.Storage_Unit);
   DT_Typeinfo_Ptr_Size    : constant SSE.Storage_Count :=
      SSE.Storage_Count (Standard'Address_Size / System.Storage_Unit);
   DT_Offset_To_Top_Offset : constant SSE.Storage_Count :=
      DT_Typeinfo_Ptr_Size + DT_Offset_To_Top_Size;
   DT_Predef_Prims_Offset  : constant SSE.Storage_Count :=
      DT_Typeinfo_Ptr_Size + DT_Offset_To_Top_Size + DT_Predef_Prims_Size;

   type Addr_Ptr is access System.Address;
   pragma No_Strict_Aliasing (Addr_Ptr);

end Ada.Tags;
