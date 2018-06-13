with Ada.Exceptions;

package System.Soft_Links is
   pragma Preelaborate;

   subtype EOA is Ada.Exceptions.Exception_Occurrence_Access;

   type Get_EOA_Call      is access function return EOA;
   pragma Favor_Top_Level (Get_EOA_Call);

   function Get_Current_Excep_NT return EOA;

   Get_Current_Excep : Get_EOA_Call := Get_Current_Excep_NT'Access;

end System.Soft_Links;
