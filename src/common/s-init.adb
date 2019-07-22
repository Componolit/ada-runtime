--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body System.Init is

   procedure Initialize (Addr : System.Address) is
      pragma Unreferenced (Addr);
   begin
      null;
   end Initialize;

   procedure Finalize is
   begin
      null;
   end Finalize;

   procedure Runtime_Initialize (Handler : Integer) is
      pragma Unreferenced (Handler);
   begin
      C_Runtime_Initialize;
   end Runtime_Initialize;

   procedure Runtime_Finalize is
   begin
      C_Runtime_Finalize;
   end Runtime_Finalize;

end System.Init;
