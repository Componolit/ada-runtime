with Platform;

package body System.Exception_Table is

   use System.Standard_Library;

   procedure Register_Exception (X : Exception_Data_Ptr) is
      pragma Unreferenced (X);
   begin
      Platform.Log_Warning ("Register_Exception not implemented");
   end Register_Exception;

end System.Exception_Table;
