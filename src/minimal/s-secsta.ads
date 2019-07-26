--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

with System.Parameters;
with System.Storage_Elements;

package System.Secondary_Stack with
   SPARK_Mode,
   Abstract_State => (Stack_State, Binder_State),
   Initializes    => (Stack_State, Binder_State)
is

   package SP renames System.Parameters;
   package SSE renames System.Storage_Elements;

   type SS_Stack (Size : SP.Size_Type) is private;

   type Mark_Id is private;

   function Valid_Address (A : SSE.Integer_Address) return Boolean with
      Ghost,
      Global  => null,
      Depends => (Valid_Address'Result => A);

   function Valid_Stack return Boolean with
      Ghost,
      Global  => (Input => Stack_State),
      Depends => (Valid_Stack'Result => Stack_State);

   function Valid_Mark_Id (M : Mark_Id) return Boolean with
      Ghost,
      Global  => null,
      Depends => (Valid_Mark_Id'Result => M);

   function Consistent_Mark_Id (M : Mark_Id) return Boolean with
      Ghost,
      Global  => (Input => Stack_State),
      Depends => (Consistent_Mark_Id'Result => (M, Stack_State));

   function Sufficient_Stack_Space (S : SSE.Storage_Count) return Boolean with
      Global  => (Input => (Stack_State, Binder_State)),
      Depends => (Sufficient_Stack_Space'Result =>
                     (S, Stack_State, Binder_State));

   function Valid_Lower_Mark_Id (M : Mark_Id) return Boolean with
      Ghost,
      Global  => (Input => Stack_State),
      Depends => (Valid_Lower_Mark_Id'Result =>
                     (M, Stack_State));

   procedure SS_Allocate (Address      : out SSE.Integer_Address;
                          Storage_Size :     SSE.Storage_Count) with
      Pre     => Sufficient_Stack_Space (Storage_Size) and Valid_Stack,
      Post    => Valid_Address (Address) and Valid_Stack,
      Global  => (Input  => Binder_State,
                  In_Out => Stack_State),
      Depends => (Stack_State =>+ Storage_Size,
                  Address     => (Stack_State, Storage_Size),
                  null        => Binder_State);

   function SS_Mark return Mark_Id with
      Pre     => Valid_Stack,
      Post    => Valid_Mark_Id (SS_Mark'Result) and Valid_Stack,
      Global  => (Input => Stack_State),
      Depends => (SS_Mark'Result => Stack_State);

   procedure SS_Release (M : Mark_Id) with
      Pre     => Consistent_Mark_Id (M)
                 and Valid_Lower_Mark_Id (M)
                 and Valid_Stack,
      Post    => Valid_Stack,
      Global  => (In_Out => Stack_State),
      Depends => (Stack_State =>+ M);

private

   SS_Pool : Integer with
      Part_Of => Binder_State;

   subtype SS_Ptr is SP.Size_Type;

   type Memory is array (SS_Ptr range <>) of SSE.Storage_Element;
   for Memory'Alignment use Standard'Maximum_Alignment;

   type SS_Stack (Size : SP.Size_Type) is record
      Stack_Space : Memory (1 .. Size);
   end record;

   type Stack_Meta_Data is record
      Base : SSE.Integer_Address;
      Top  : SSE.Storage_Count;
   end record;

   type Mark_Id is record
      Sstk : SSE.Integer_Address;
      Sptr : SSE.Integer_Address;
   end record;

   Stack_Size : Natural with
      Export,
      Convention    => Ada,
      External_Name => "__gnat_default_ss_size",
      Part_Of       => Binder_State;

   Stack_Count : Natural := 1 with
      Export,
      Convention    => Ada,
      External_Name => "__gnat_binder_ss_count",
      Part_Of       => Binder_State;

   Stack_Pool_Address : System.Address with
      Export,
      Convention    => Ada,
      External_Name => "__gnat_default_ss_pool",
      Part_Of       => Binder_State;

   Stack : Stack_Meta_Data := (Base => 0,
                               Top  => 0) with
      Part_Of => Stack_State;

   use type SSE.Integer_Address;
   use type SSE.Storage_Offset;

   function Valid_Address (A : SSE.Integer_Address) return Boolean
   is
      (A /= 0);

   function Valid_Mark_Id (M : Mark_Id) return Boolean
   is
      (M.Sstk /= 0);

   function Valid_Stack return Boolean
   is
      (Stack.Base /= 0);

   function Sufficient_Stack_Space (S : SSE.Storage_Count) return Boolean
   is
      (Stack.Top < SSE.Storage_Count (Stack_Size)
       and then S < SSE.Storage_Count (Stack_Size)
       and then S + Stack.Top < SSE.Storage_Count (Stack_Size)
       and then SSE.Integer_Address (S + Stack.Top) < Stack.Base);

   function Consistent_Mark_Id (M : Mark_Id) return Boolean
   is
      (Stack.Base = M.Sstk);

   function Valid_Lower_Mark_Id (M : Mark_Id) return Boolean
   is
      (M.Sptr < SSE.Integer_Address (Integer'Last)
       and then SSE.Storage_Count (M.Sptr) <= Stack.Top);

end System.Secondary_Stack;
