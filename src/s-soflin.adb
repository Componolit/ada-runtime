with External;

package body System.Soft_Links is

   function Get_Current_Excep_NT return EOA is
   begin
      External.Warn_Not_Implemented ("Get_Current_Excep_NT");
      return null;
   end Get_Current_Excep_NT;

end System.Soft_Links;
