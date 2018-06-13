with External;

package body Ada.Exceptions is

   ----------------------------
   -- Raise_Exception_Always --
   ----------------------------

   procedure Raise_Exception_Always (
                                     E       : Exception_Id;
                                     Message : String := ""
                                    )
   is
      procedure Raise_Ada_Exception (
                                     Name : System.Address;
                                     Msg  : System.Address
                                    )
        with
          Import,
          Convention => C,
          External_Name => "raise_ada_exception";
      C_Msg : String := Message & Character'Val (0);
   begin
      External.Warn_Not_Implemented ("Raise_Exception_Always");
      Raise_Ada_Exception (E.Full_Name, C_Msg'Address);
   end Raise_Exception_Always;

   procedure Raise_Exception (
                              E       : Exception_Id;
                              Message : String := ""
                             )
   is
   begin
      Raise_Exception_Always (E, Message);
   end Raise_Exception;

   procedure Reraise_Occurrence_No_Defer (
                                          X : Exception_Occurrence
                                         )
   is
      pragma Unreferenced (X);
   begin
      External.Warn_Not_Implemented ("Reraise_Occurrence_No_Defer");
   end Reraise_Occurrence_No_Defer;

   procedure Save_Occurrence (
                              Target : out Exception_Occurrence;
                              Source : Exception_Occurrence
                             )
   is
   begin
      External.Warn_Not_Implemented ("Save_Occurrence");
      Target := Source;
   end Save_Occurrence;

end Ada.Exceptions;
