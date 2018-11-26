--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body Platform
  with SPARK_Mode => Off
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

   procedure Raise_Ada_Exception (T    : Ada_Exceptions.Exception_Type;
                                  Name : String;
                                  Msg  : String)
   is
      C_Name : String := Name & Character'Val (0);
      C_Msg  : String := Msg & Character'Val (0);
   begin
      C_Raise_Exception (T, C_Name'Address, C_Msg'Address);
   end Raise_Ada_Exception;

end Platform;
