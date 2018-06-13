with System;

package System.Standard_Library is
   pragma Preelaborate;

   type Exception_Data;
   type Exception_Data_Ptr is access all Exception_Data;
   type Raise_Action is access procedure;

   type Exception_Data is record
      Not_Handled_By_Others : Boolean;
      Lang                  : Character;
      Name_Length           : Natural;
      Full_Name             : System.Address;
      HTable_Ptr            : Exception_Data_Ptr;
      Foreign_Data          : System.Address;
      Raise_Hook            : Raise_Action;
   end record;

end System.Standard_Library;
