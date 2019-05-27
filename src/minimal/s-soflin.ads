--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package System.Soft_Links is
   pragma Preelaborate;

   function Get_Jmpbuf_Address_Soft return Address;
   procedure Set_Jmpbuf_Address_Soft (Addr : Address);
   pragma Inline (Get_Jmpbuf_Address_Soft);
   pragma Inline (Set_Jmpbuf_Address_Soft);

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);
   pragma Suppress_Initialization (No_Param_Proc);

   Finalize_Library_Objects : No_Param_Proc
      with Export,
           Convention => C,
           External_Name => "__gnat_finalize_library_objects";

end System.Soft_Links;
