#!/usr/bin/env python3

import sys

exceptions = {}

def gen_header():
    return "\
typedef enum {\n\
" + "\n".join(["    {} = {},".format(exceptions[name].upper(), hex(name)) for name in sorted(list(exceptions))]).strip(",") + "\n\
} exception_t;"

def gen_spec():
    return "\
package Ada_Exceptions is\n\
   pragma Preelaborate;\n\
\n\
   type Exception_Type is (\n\
" + "\n".join(["      {},".format(exceptions[name]) for name in sorted(list(exceptions))]).strip(",") + "\n\
    );\n\
\n\
   for Exception_Type use (\n\
" + "\n".join(["      {} => 16#{}#,".format(exceptions[name], hex(name)[2:]) for name in sorted(list(exceptions))]).strip(",") + "\n\
    );\n\
end Ada_Exceptions;"

with open(sys.argv[1], "r") as md:
    for line in md.readlines():
        try:
            exception = line.split("|")[1].strip(" `")
            excid = line.split("|")[2].strip(" `")
            if not exception[1] == 'E' and not excid.startswith("0x"):
                raise ValueError
            exceptions[int(excid, 16)] = exception
        except:
            print("IGNORE: " + line.strip("\n"))

with open("ada_exceptions.h", "w") as header:
    header.write(gen_header())

with open("ada_exceptions.ads", "w") as spec:
    spec.write(gen_spec())
