--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System;

package Componolit.Runtime.Debug with
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
       External_Name => "componolit_runtime_log_debug";

   procedure C_Warning (Str : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "componolit_runtime_log_warning";

   procedure C_Error (Str : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "componolit_runtime_log_error";

end Componolit.Runtime.Debug;
