with Ada.Exceptions;

package System.Soft_Links is
   pragma Preelaborate;

   subtype EOA is Ada.Exceptions.Exception_Occurrence_Access;

   type Get_EOA_Call      is access function return EOA;
   pragma Favor_Top_Level (Get_EOA_Call);

   function Get_Current_Excep_NT return EOA;

   Get_Current_Excep : Get_EOA_Call := Get_Current_Excep_NT'Access;

   function Get_GNAT_Exception return Ada.Exceptions.Exception_Id;

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
