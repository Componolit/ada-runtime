/*
 * Copyright (C) 2018 Componolit GmbH
 *
 * This file is part of the Componolit Ada runtime, which is distributed
 * under the terms of the GNU Affero General Public License version 3.
 *
 * As a special exception under Section 7 of GPL version 3, you are granted
 * additional permissions described in the GCC Runtime Library Exception,
 * version 3.1, as published by the Free Software Foundation.
 */

#include <base/exception.h>
#include <base/log.h>
#include <base/thread.h>
#include <base/buffered_output.h>
#include <util/string.h>
#include <util/reconstructible.h>
#include <terminal_session/connection.h>
#include <timer_session/connection.h>

#include <unwind.h>

class Gnat_Exception : public Genode::Exception {};

extern "C" {

    _Unwind_Reason_Code __gnat_personality_v0(
            int version,
            unsigned long phase,
            _Unwind_Exception_Class cls,
            void *exc,
            void *context)
    {
        if(version == 1 && (phase & 3)){
            return _URC_CONTINUE_UNWIND;
        }else{
            Genode::error(__func__, " called with invalid values",
                                    " version=", version,
                                    " phase=", phase,
                                    " class=", (unsigned)cls,
                                    " exception=", exc,
                                    " context=", context);
            return _URC_FOREIGN_EXCEPTION_CAUGHT;
        }
    }

    void log_debug(char *message)
    {
        Genode::log(Genode::Cstring(message));
    }

    void log_warning(char *message)
    {
        Genode::warning(Genode::Cstring(message));
    }

    void log_error(char *message)
    {
        Genode::error(Genode::Cstring(message));
    }

/*
    void *__gnat_malloc(Genode::size_t)
    {
    }

    void __gnat_free(void *)
    {
    }
*/

    void __gnat_unhandled_terminate()
    {
        Genode::error("Unhandled GNAT exception.");
        throw Gnat_Exception();
    }

    void allocate_secondary_stack(Genode::size_t size, void **address)
    {
        *address = Genode::Thread::myself()->alloc_secondary_stack("ada thread", size);
    }

}
