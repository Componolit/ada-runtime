package System.Init is
   pragma Preelaborate;

   procedure Initialize
      with Export,
           Convention => C,
           External_Name => "__gnat_initialize";

   procedure Finalize
      with Export,
           Convention => C,
           External_Name => "__gnat_finalize";

   procedure Runtime_Initialize
      with Export,
           Convention => C,
           External_Name => "__gnat_runtime_initialize";

   procedure Runtime_Finalize
      with Export,
           Convention => C,
           External_Name => "__gnat_runtime_finalize";

end System.Init;
