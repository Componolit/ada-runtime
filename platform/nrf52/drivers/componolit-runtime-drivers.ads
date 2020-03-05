
with System.Storage_Elements;

package Componolit.Runtime.Drivers is

   package SSE renames System.Storage_Elements;

private

   APB_Base : constant SSE.Integer_Address := 16#4000_0000#;
   AHB_Base : constant SSE.Integer_Address := 16#5000_0000#;

end Componolit.Runtime.Drivers;
