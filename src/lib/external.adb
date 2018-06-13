with System;

package body External is

   procedure Warn_Not_Implemented (Name : String)
   is
      procedure C_Warn_Unimplemented_Function (Func : System.Address)
        with
          Import,
          Convention => C,
          External_Name => "warn_unimplemented_function";
      C_Name : String := Name & Character'Val (0);
   begin
      C_Warn_Unimplemented_Function (C_Name'Address);
   end Warn_Not_Implemented;

end External;
