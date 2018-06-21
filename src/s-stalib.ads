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

   --  Workaround for GNATBIND 8.1 / Pro 18.1:
   --  Enforce usage of secondary stack as GNATBIND generates binder
   --  output files which refer to System.Parameters for declaring
   --  Default_Secondary_Stack_Size even if no secondary stack is used,
   --  but only adds necessary withs when secondary stack is used
   function Dummy (S : String) return String is (S);

end System.Standard_Library;
