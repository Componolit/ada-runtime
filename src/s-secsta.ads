with System.Parameters;
with System.Storage_Elements;
with Ss_Utils;
use all type Ss_Utils.Thread;

package System.Secondary_Stack is

   package SP renames System.Parameters;
   package SSE renames System.Storage_Elements;

   type SS_Stack (Size : SP.Size_Type) is private;

   type Mark_Id is private;

   procedure SS_Allocate (
                          Address      : out System.Address;
                          Storage_Size : SSE.Storage_Count
                         );

   function SS_Mark return Mark_Id;

   procedure SS_Release (
                         M : Mark_Id
                        );

private

   SS_Pool : Integer;

   subtype SS_Ptr is SP.Size_Type;

   type Memory is array (SS_Ptr range <>) of SSE.Storage_Element;
   for Memory'Alignment use Standard'Maximum_Alignment;

   type SS_Stack (Size : SP.Size_Type) is record
      Top : SS_Ptr;
      Max : SS_Ptr;
      Internal_Chunk : Memory (1 .. Size);
   end record;

   type Mark_Id is record
      Sstk : System.Address;
      Sptr : SSE.Integer_Address;
   end record;

   Thread_Registry : Ss_Utils.Registry := Ss_Utils.Null_Registry;

end System.Secondary_Stack;
