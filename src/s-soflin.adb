with Platform;

package body System.Soft_Links is

   function Get_Current_Excep_NT return EOA is
   begin
      Platform.Log_Warning ("Get_Current_Excep_NT not implemented");
      return null;
   end Get_Current_Excep_NT;

   function Get_GNAT_Exception return Ada.Exceptions.Exception_Id is
   begin
      Platform.Log_Warning ("Set_Jmpbuf_Address_Soft not implemented");
      return Ada.Exceptions.Null_Exception_Id;
   end Get_GNAT_Exception;

   function Get_Jmpbuf_Address_Soft return Address is
   begin
      Platform.Log_Warning ("Get_Jmpbuf_Address_Soft not implemented");
      return Address (0);
   end Get_Jmpbuf_Address_Soft;

   procedure Set_Jmpbuf_Address_Soft (Addr : Address) is
      pragma Unreferenced (Addr);
   begin
      Platform.Log_Warning ("Set_Jmpbuf_Address_Soft not implemented");
   end Set_Jmpbuf_Address_Soft;

end System.Soft_Links;
