--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System;
with Componolit.Runtime.Exceptions;

package Componolit.Runtime.Platform with
   SPARK_Mode
is
   pragma Pure;
   pragma Preelaborate;

   procedure Unhandled_Terminate with
      Export,
      Convention => C,
      External_Name => "__gnat_unhandled_terminate";
   pragma No_Return (Unhandled_Terminate);

   procedure Raise_Ada_Exception (T    : Exceptions.Exception_Type;
                                  Name : String;
                                  Msg  : String);

   procedure Terminate_Message (Msg : String);
   pragma No_Return (Terminate_Message);

   function Gnat_Personality_V0 (Status  : Integer;
                                 Phase   : Long_Integer;
                                 Class   : Natural;
                                 Exc     : System.Address;
                                 Context : System.Address) return Integer with
      Export,
      Convention => C,
      External_Name => "__gnat_personality_v0";

private

   procedure C_Raise_Exception (T    : Exceptions.Exception_Type;
                                Name : System.Address;
                                Msg  : System.Address)
     with
       Import,
       Convention => C,
       External_Name => "componolit_runtime_raise_ada_exception";

   procedure C_Unhandled_Terminate with
      Import,
      Convention => C,
      External_Name => "componolit_runtime_unhandled_terminate";
   pragma No_Return (C_Unhandled_Terminate);

   function C_Gnat_Personality (Status  : Integer;
                                Phase   : Long_Integer;
                                Class   : Natural;
                                Exc     : System.Address;
                                Context : System.Address) return Integer with
      Import,
      Convention => C,
      External_Name => "componolit_runtime_personality";

end Componolit.Runtime.Platform;
