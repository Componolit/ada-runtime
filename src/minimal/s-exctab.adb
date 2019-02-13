--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Platform;

package body System.Exception_Table is

   use System.Standard_Library;

   procedure Register_Exception (X : Exception_Data_Ptr) is
      pragma Unreferenced (X);
   begin
      Platform.Log_Warning ("Register_Exception not implemented");
   end Register_Exception;

end System.Exception_Table;
