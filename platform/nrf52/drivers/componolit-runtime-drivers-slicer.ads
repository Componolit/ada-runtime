--
--  @summary Generic slice generator
--  @author  Johannes Kliemann
--  @date    2019-11-19
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of Basalt, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

--  Basalt.Slicer is a generic slicing tool that allows to
--  split a range into multiple subsequent slices of a maximum length.
--  All slices will be equal to the given maximum length. If the
--  range cannot be divided into full slices the last slice will be
--  smaller.

generic
   type Index is range <>;
package Componolit.Runtime.Drivers.Slicer with
   SPARK_Mode,
   Annotate => (GNATprove, Terminating)
is
   --  Slicer context
   type Context is private;

   --  Slice that denotes the range First .. Last
   --  @field First  First element of the slice
   --  @field Last   Last element of the slice
   type Slice is record
      First : Index;
      Last  : Index;
   end record with
      Dynamic_Predicate => Slice.First <= Slice.Last;

   --  Create a slicer
   --
   --  @param Range_First   First element of the range to be sliced
   --  @param Range_Last    Last element of the range to be sliced
   --  @param Slice_Length  Maximum length of a single slice
   --  @return              Context
   function Create (Range_First  : Index;
                    Range_Last   : Index;
                    Slice_Length : Index) return Context with
      Pre  => Range_First < Range_Last
              and then Slice_Length > 0,
      Post => Get_Range (Create'Result).First = Range_First
              and then Get_Range (Create'Result).Last = Range_Last
              and then Get_Length (Create'Result) = Slice_Length;

   --  Get the current slice
   --
   --  @param C  Context
   --  @return   The current slice
   function Get_Slice (C : Context) return Slice with
      Post => Get_Slice'Result.Last - Get_Slice'Result.First < Get_Length (C)
              and then Get_Slice'Result.First in
              Get_Range (C).First .. Get_Range (C).Last
              and then Get_Slice'Result.Last
              in Get_Range (C).First .. Get_Range (C).Last;

   --  Get the configured range
   --
   --  @param C  Context
   --  @return   The range that has been configured in Create
   function Get_Range (C : Context) return Slice;

   --  Get the configured length
   --
   --  @param C  Context
   --  @return   The length that has been configured in Create
   function Get_Length (C : Context) return Index;

   --  Check if a further slice is available
   --
   --  @param C  Context
   --  @return   True if a new slice is available,
   --            False if the current slice is the last one
   function Has_Next (C : Context) return Boolean;

   --  Iterate to the next slice
   --
   --  @param C  Context
   procedure Next (C : in out Context) with
      Pre  => Has_Next (C),
      Post => Get_Range (C'Old) = Get_Range (C)
              and then Get_Length (C'Old) = Get_Length (C);
private
   type Context is record
      Full_Range   : Slice;
      Slice_Range  : Slice;
      Slice_Length : Index;
   end record with
      Dynamic_Predicate => Slice_Range.First in
      Full_Range.First .. Full_Range.Last
                           and then Slice_Range.Last in
                           Full_Range.First .. Full_Range.Last
                           and then Slice_Range.Last - Slice_Range.First + 1
                           <= Slice_Length;

end Componolit.Runtime.Drivers.Slicer;
