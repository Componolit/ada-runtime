--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package System.Init is
   pragma Preelaborate;

   procedure Initialize with
      Export,
      Convention => C,
      External_Name => "__gnat_initialize";

   procedure Finalize with
      Export,
      Convention => C,
      External_Name => "__gnat_finalize";

   procedure Runtime_Initialize with
      Export,
      Convention => C,
      External_Name => "__gnat_runtime_initialize";

   procedure Runtime_Finalize with
      Export,
      Convention => C,
      External_Name => "__gnat_runtime_finalize";

private

   procedure C_Runtime_Initialize with
      Import,
      Convention => C,
      External_Name => "componolit_runtime_initialize";

   procedure C_Runtime_Finalize with
      Import,
      Convention => C,
      External_Name => "componolit_runtime_finalize";

end System.Init;
