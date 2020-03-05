
package Gnat_Helpers
is

   --  _Unwind_Reason_Code
   type URC is (Foreign_Exception_Caught,
                Continue_Unwind,
                Failure);

   for URC use (Foreign_Exception_Caught => 1,
                Continue_Unwind          => 8,
                Failure                  => 9);

   --  _Unwind_State
   type US is (Virtual_Unwind_Frame);
   for US use (Virtual_Unwind_Frame => 0);

   --  _Unwind_Exception_Class
   type UEC is mod 2 ** 64;

end Gnat_Helpers;
