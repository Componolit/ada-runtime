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

   type Mark is private;

   type Registry_Entry is private;

   Registry_Size : constant := 128;

   type Registry_Index is new Integer range -1 .. Registry_Size - 1;
   type Registry is array (Registry_Index range 0 .. Registry_Index'Last) of Registry_Entry;
   Invalid_Index : constant Registry_Index := -1;

   Null_Registry : constant Registry;

   Secondary_Stack_Size : constant SSE.Storage_Count := 768 * 1024;

   function Thread_Exists (Thread_Registry : Registry;
                           T               : Thread) return Boolean
     with
       Ghost;

   function Slot_Available (Thread_Registry : Registry) return Boolean
     with
       Ghost;

   function Valid_Entry (E : Registry_Entry) return Boolean
     with
       Ghost;

   function Valid_Mark (M : Mark) return Boolean
     with
       Ghost;

   procedure Get_Mark (T               : Thread;
                       Thread_Registry : in out Registry;
                       M               : out Mark)
     with
       Pre => T /= Invalid_Thread and Slot_Available (Thread_Registry),
       Post => Valid_Mark (M) and
     Thread_Exists (Thread_Registry, T);

   function Get_Mark (T : Thread;
                      Thread_Registry : Registry) return Mark
     with
       Ghost,
       Pre => T /= Invalid_Thread and Thread_Exists (Thread_Registry, T) and
     (for all E of Thread_Registry => Valid_Entry (E)),
     Post => Valid_Mark (Get_Mark'Result);

   procedure Set_Mark (T               : Thread;
                       M               : Mark;
                       Thread_Registry : in out Registry)
     with
       Pre => (Valid_Mark (M) and
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
     Slot_Available (Reg) and
     Storage_Size < Secondary_Stack_Size;

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

private

   type Mark is
      record
         Base  : System.Address := System.Null_Address;
         Top   : SSE.Storage_Count := 0;
      end record
     with
       Type_Invariant => Top < Secondary_Stack_Size;

   Invalid_Mark : constant Mark := (Base => System.Null_Address, Top => 0);

   type Registry_Entry is
      record
         Id    : Thread := Invalid_Thread;
         Data  : Mark := Invalid_Mark;
      end record
     with
       Type_Invariant => (if Registry_Entry.Id /= Invalid_Thread then
                            Registry_Entry.Data.Base /= System.Null_Address);

   Null_Registry : constant Registry  := (others =>
                                            (Id   => Invalid_Thread,
                                             Data => (Base  => System.Null_Address,
                                                      Top   => 0)));

   function Thread_Exists (Thread_Registry : Registry;
                           T               : Thread) return Boolean is
     (for Some E of Thread_Registry => E.Id = T);

   function Slot_Available (Thread_Registry : Registry) return Boolean is
     (for Some E of Thread_Registry => E.Id = Invalid_Thread);

   function Valid_Entry (E : Registry_Entry) return Boolean is
     (if E.Id /= Invalid_Thread then E.Data.Base /= System.Null_Address);

   function Valid_Mark (M : Mark) return Boolean is
      (M.Base /= System.Null_Address);

end Ss_Utils;
