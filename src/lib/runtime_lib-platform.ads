--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System;
with Runtime_Lib.Exceptions;

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

   procedure Raise_Ada_Exception (T    : Runtime_Lib.Exceptions.Exception_Type;
                                  Name : String;
                                  Msg  : String);

   procedure Terminate_Message (Msg : String);
   pragma No_Return (Terminate_Message);

private

   procedure C_Raise_Exception (T    : Runtime_Lib.Exceptions.Exception_Type;
                                Name : System.Address;
                                Msg  : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "raise_ada_exception";

end Runtime_Lib.Platform;
