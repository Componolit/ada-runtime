
package Gnat_Helpers
is

   type URC is (Foreign_Exception_Caught,
                Continue_Unwind);

   for URC use (Foreign_Exception_Caught => 1,
                Continue_Unwind          => 8);

end Gnat_Helpers;
