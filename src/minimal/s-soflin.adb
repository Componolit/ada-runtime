--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with Componolit.Runtime.Debug;

package body System.Soft_Links is

   function Get_Current_Excep_NT return EOA is
   begin
      Componolit.Runtime.Debug.Log_Warning
         ("Get_Current_Excep_NT not implemented");
      return null;
   end Get_Current_Excep_NT;

   function Get_GNAT_Exception return Ada.Exceptions.Exception_Id is
   begin
      Componolit.Runtime.Debug.Log_Warning
         ("Set_Jmpbuf_Address_Soft not implemented");
      return Ada.Exceptions.Null_Exception_Id;
   end Get_GNAT_Exception;

   function Get_Jmpbuf_Address_Soft return Address is
   begin
      return Address (0);
   end Get_Jmpbuf_Address_Soft;

   procedure Set_Jmpbuf_Address_Soft (Addr : Address) is
      pragma Unreferenced (Addr);
   begin
      null;
   end Set_Jmpbuf_Address_Soft;

end System.Soft_Links;
