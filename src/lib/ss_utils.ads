with System;
with System.Storage_Elements;
use all type System.Address;
use all type System.Storage_Elements.Storage_Offset;

package Ss_Utils
  with SPARK_Mode
is

   package SSE renames System.Storage_Elements;

   type Thread is new System.Address;
   Invalid_Thread : constant Thread := Thread (System.Null_Address);

   type Mark is
      record
         Base  : System.Address;
         Top   : SSE.Storage_Count;
      end record;

   type Registry_Entry is
      record
         Id    : Thread;
         Data  : Mark;
      end record;

   Registry_Size : constant := 128;

   type Registry_Index is new Integer range -1 .. Registry_Size - 1;
   type Registry is array (Registry_Index range 0 .. Registry_Index'Last) of Registry_Entry;
   Invalid_Index : constant Registry_Index := -1;

   Null_Registry : constant Registry := (others =>
                                    (Id   => Invalid_Thread,
                                     Data => (Base  => System.Null_Address,
                                              Top   => 0)));

   Secondary_Stack_Size : constant SSE.Storage_Count := 768 * 1024;

   function Thread_Exists (Thread_Registry : Registry;
                           T               : Thread) return Boolean is
     (for Some E of Thread_Registry => E.Id = T) with Ghost;

   function Slot_Available (Thread_Registry : Registry) return Boolean is
     (for Some E of Thread_Registry => E.Id = Invalid_Thread) with Ghost;

   procedure Get_Mark (T               : Thread;
                       Thread_Registry : in out Registry;
                       E               : out Mark)
     with
       Pre => T /= Invalid_Thread and Slot_Available (Thread_Registry),
       Post => (E.Base /= System.Null_Address) and
         Thread_Exists (Thread_Registry, T);

   procedure Set_Mark (T               : Thread;
                       M               : Mark;
                       Thread_Registry : in out Registry)
     with
       Pre => (M.Base /= System.Null_Address and
                 T /= Invalid_Thread and Thread_Exists (Thread_Registry, T));

   function Allocate_Stack (
                            T    : Thread;
                            Size : SSE.Storage_Count
                           ) return System.Address
     with
       Pre => T /= Invalid_Thread,
       Post => Allocate_Stack'Result /= System.Null_Address;

   procedure S_Allocate (Address      : out System.Address;
                         Storage_Size : SSE.Storage_Count;
                         Reg          : in out Registry;
                         T            : Thread)
     with
       Pre => T /= Invalid_Thread and
       Thread_Exists (Reg, T) and
       Slot_Available (Reg);

   procedure S_Mark (Stack_Base : out System.Address;
                     Stack_Ptr  : out SSE.Storage_Count;
                     Reg        : in out Registry;
                     T          : Thread)
     with
       Pre => T /= Invalid_Thread and Slot_Available (Reg);

   procedure S_Release (Stack_Base : System.Address;
                        Stack_Ptr  : SSE.Storage_Count;
                        Reg        : in out Registry;
                        T          : Thread)
     with
       Pre => T /= Invalid_Thread and
       Thread_Exists (Reg, T) and
       Slot_Available (Reg);

   function C_Alloc (T    : Thread;
                     Size : SSE.Storage_Count) return System.Address
     with
       Import,
       Convention => C,
       External_Name => "allocate_secondary_stack",
       Pre => T /= Invalid_Thread,
       Post => C_Alloc'Result /= System.Null_Address,
       Global => null;

   function C_Get_Thread return Thread
     with
       Import,
       Convention => C,
       External_Name => "get_thread";

end Ss_Utils;
