--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package System.Parameters is
   pragma Pure;

   ------------------------------
   -- Stack Allocation Control --
   ------------------------------

   type Task_Storage_Size is new Integer;
   --  Type used in tasking units for task storage size

   type Size_Type is new Task_Storage_Size;
   --  Type used to provide task storage size to runtime

   Runtime_Default_Sec_Stack_Size : constant Size_Type := 10 * 1024;
   --  The run-time chosen default size for secondary stacks that may be
   --  overriden by the user with the use of binder -D switch.

   ----------------------------------------------
   -- Characteristics of types in Interfaces.C --
   ----------------------------------------------

   long_bits : constant := Long_Integer'Size;
   --  Number of bits in type long and unsigned_long. The normal convention
   --  is that this is the same as type Long_Integer, but this may not be true
   --  of all targets.

   ptr_bits  : constant := Standard'Address_Size;
   subtype C_Address is System.Address;
   --  Number of bits in Interfaces.C pointers, normally a standard address

   C_Malloc_Linkname : constant String := "__gnat_malloc";
   --  Name of runtime function used to allocate such a pointer

end System.Parameters;
