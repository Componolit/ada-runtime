--  Copyright (C) 2020 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package Ada.Numerics with
   Pure
is

   Pi : constant :=
          3.14159_26535_89793_23846_26433_83279_50288_41971_69399_37511;

   ["03C0"] : constant := Pi;
   --  This is the Greek letter Pi (for Ada 2005 AI-388). Note that it is
   --  conforming to have this constant present even in Ada 95 mode, as there
   --  is no way for a normal mode Ada 95 program to reference this identifier.

   e : constant :=
         2.71828_18284_59045_23536_02874_71352_66249_77572_47093_69996;

end Ada.Numerics;
