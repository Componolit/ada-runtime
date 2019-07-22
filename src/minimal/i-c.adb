--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of the Componolit Ada runtime, which is distributed
--  under the terms of the GNU Affero General Public License version 3.
--
--  As a special exception under Section 7 of GPL version 3, you are granted
--  additional permissions described in the GCC Runtime Library Exception,
--  version 3.1, as published by the Free Software Foundation.

package body Interfaces.C with
   SPARK_Mode
is
   --  We enforce a body in the spec, as the orignial version in the runtime
   --  has one. If the contrib directory is in our search path, we get an error
   --  that the body contained therein must not exist. With this dummy body,
   --  earlier in the search path, this problem is solved.
end Interfaces.C;
