with External;

package body System.Soft_Links is

   function Get_Current_Excep_NT return EOA is
   begin
      External.Warn_Not_Implemented ("Get_Current_Excep_NT");
      return null;
   end Get_Current_Excep_NT;

   function Get_GNAT_Exception return Ada.Exceptions.Exception_Id is
   begin
      External.Warn_Not_Implemented ("Set_Jmpbuf_Address_Soft");
      return Ada.Exceptions.Null_Exception_Id;
   end Get_GNAT_Exception;

   function Get_Jmpbuf_Address_Soft return Address is
   begin
      External.Warn_Not_Implemented ("Get_Jmpbuf_Address_Soft");
      return Address (0);
   end Get_Jmpbuf_Address_Soft;

   procedure Set_Jmpbuf_Address_Soft (Addr : Address) is
      pragma Unreferenced (Addr);
   begin
      External.Warn_Not_Implemented ("Set_Jmpbuf_Address_Soft");
   end Set_Jmpbuf_Address_Soft;

end System.Soft_Links;
