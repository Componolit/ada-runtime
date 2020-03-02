--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body Componolit.Runtime.Debug with
   SPARK_Mode
is

   procedure Log (Msg : String)
   is
      pragma SPARK_Mode (Off);
      C_Msg : String := Prefix & Msg & Character'Val (0);
   begin
      C_Log (C_Msg'Address);
   end Log;

   procedure Log_Debug_Private is new Log ("");
   procedure Log_Debug (Msg : String) renames Log_Debug_Private;

   procedure Log_Warning_Private is new Log ("Warning: ");
   procedure Log_Warning (Msg : String) renames Log_Warning_Private;

   procedure Log_Error_Private is new Log ("Error: ");
   procedure Log_Error (Msg : String) renames Log_Error_Private;

end Componolit.Runtime.Debug;
