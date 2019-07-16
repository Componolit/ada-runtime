--  Copyright (C) 2018 Componolit GmbH
--  Copyright (C) 1992-2015, Free Software Foundation, Inc.
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Ada.Unchecked_Conversion;

package System.Standard_Library with
   SPARK_Mode => Off
   --  Use of access types
is

   pragma Preelaborate;
   pragma Elaborate_Body;

   subtype Big_String is String (1 .. Positive'Last);
   pragma Suppress_Initialization (Big_String);
   --  Type used to obtain string access to given address. Initialization is
   --  suppressed, since we never want to have variables of this type, and
   --  we never want to attempt initialiazation of virtual variables of this
   --  type (e.g. when pragma Normalize_Scalars is used).

   type Big_String_Ptr is access all Big_String;
   for Big_String_Ptr'Storage_Size use 0;
   --  We use this access type to pass a pointer to an area of storage to be
   --  accessed as a string. Of course when this pointer is used, it is the
   --  responsibility of the accessor to ensure proper bounds. The storage
   --  size clause ensures we do not allocate variables of this type.

   function To_Ptr is
     new Ada.Unchecked_Conversion (System.Address, Big_String_Ptr);

   type Exception_Data;
   type Exception_Data_Ptr is access all Exception_Data;
   type Raise_Action is access procedure;

   type Exception_Data is record
      Not_Handled_By_Others : Boolean;
      Lang                  : Character;
      Name_Length           : Natural;
      Full_Name             : System.Address;
      HTable_Ptr            : Exception_Data_Ptr;
      Foreign_Data          : System.Address;
      Raise_Hook            : Raise_Action;
   end record;

   Constraint_Error_Name : constant String := "CONSTRAINT_ERROR" & ASCII.NUL;
   Constraint_Error_Def : aliased Exception_Data :=
     (Not_Handled_By_Others => False,
      Lang                  => 'A',
      Name_Length           => Constraint_Error_Name'Length,
      Full_Name             => Constraint_Error_Name'Address,
      HTable_Ptr            => null,
      Foreign_Data          => Null_Address,
      Raise_Hook            => null);
   pragma Export (C, Constraint_Error_Def, "constraint_error");

   procedure Adafinal is null;

   --  Workaround for GNATBIND 8.1 / Pro 18.1:
   --  Enforce usage of secondary stack as GNATBIND generates binder
   --  output files which refer to System.Parameters for declaring
   --  Default_Secondary_Stack_Size even if no secondary stack is used,
   --  but only adds necessary withs when secondary stack is used
   function Dummy (S : String) return String is (S);

end System.Standard_Library;
