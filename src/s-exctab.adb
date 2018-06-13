with External;

package body System.Exception_Table is

   use System.Standard_Library;

   procedure Register_Exception (X : Exception_Data_Ptr) is
      pragma Unreferenced (X);
   begin
      External.Warn_Not_Implemented ("Register_Exception");
   end Register_Exception;

end System.Exception_Table;
