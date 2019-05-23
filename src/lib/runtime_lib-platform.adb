--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body Runtime_Lib.Platform
  with SPARK_Mode => Off
is

   procedure Raise_Ada_Exception (T    : Runtime_Lib.Exceptions.Exception_Type;
                                  Name : String;
                                  Msg  : String)
   is
      C_Name : String := Name & Character'Val (0);
      C_Msg  : String := Msg & Character'Val (0);
   begin
      C_Raise_Exception (T, C_Name'Address, C_Msg'Address);
   end Raise_Ada_Exception;

end Runtime_Lib.Platform;
