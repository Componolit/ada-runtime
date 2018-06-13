with System.Standard_Library;

package System.Exception_Table is

   package SSL renames System.Standard_Library;

   procedure Register_Exception (X : SSL.Exception_Data_Ptr);

end System.Exception_Table;
