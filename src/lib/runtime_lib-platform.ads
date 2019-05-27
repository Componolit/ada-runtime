--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System;

package Runtime_Lib.Platform with
   SPARK_Mode
is
   pragma Pure;
   pragma Preelaborate;

   function Malloc (Size : Natural) return System.Address
     with
       Import,
       Convention => C,
       External_Name => "__gnat_malloc";

   procedure Free (Ptr : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "__gnat_free";

   procedure Unhandled_Terminate
     with
       Import,
       Convention => C,
       External_Name => "__gnat_unhandled_terminate";
   pragma No_Return (Unhandled_Terminate);

   function Allocate_Secondary_Stack (Thread : System.Address;
                                      Size   : Natural) return System.Address
     with
       Import,
       Convention => C,
       External_Name => "allocate_secondary_stack";

   procedure Terminate_Message (Msg : String);
   pragma No_Return (Terminate_Message);

end Runtime_Lib.Platform;
