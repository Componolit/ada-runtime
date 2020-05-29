--  Copyright (C) 2020 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package Ada.Numerics.Big_Numbers with
   Pure
is

   subtype Field is Integer range 0 .. 255;
   subtype Number_Base is Integer range 2 .. 16;

end Ada.Numerics.Big_Numbers;
