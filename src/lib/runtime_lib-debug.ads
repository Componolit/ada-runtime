
with System;

package Runtime_Lib.Debug with
   SPARK_Mode
is
   pragma Pure;
   pragma Preelaborate;

   procedure Log_Debug (Msg : String);
   procedure Log_Warning (Msg : String);
   procedure Log_Error (Msg : String);

private

   generic
      with procedure C_Log (Str : System.Address);
   procedure Log (Msg : String);

   procedure C_Debug (Str : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "log_debug";

   procedure C_Warning (Str : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "log_warning";

   procedure C_Error (Str : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "log_error";

end Runtime_Lib.Debug;
