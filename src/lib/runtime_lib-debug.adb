
package body Runtime_Lib.Debug with
   SPARK_Mode
is

   procedure Log (Msg : String)
   is
      C_Msg : String := Msg & Character'Val (0);
   begin
      C_Log (C_Msg'Address);
   end Log;

   procedure Log_Debug_Private is new Log (C_Debug);
   procedure Log_Debug (Msg : String) renames Log_Debug_Private;

   procedure Log_Warning_Private is new Log (C_Warning);
   procedure Log_Warning (Msg : String) renames Log_Warning_Private;

   procedure Log_Error_Private is new Log (C_Error);
   procedure Log_Error (Msg : String) renames Log_Error_Private;

end Runtime_Lib.Debug;
