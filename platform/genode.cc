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
#include <base/snprintf.h>
#include <util/string.h>
#include <util/reconstructible.h>
#include <terminal_session/connection.h>
#include <timer_session/connection.h>

#include <ada/exception.h>
#include <ada_exceptions.h>
#include <unwind.h>

class Gnat_Exception : public Genode::Exception {};

Genode::Constructible<Terminal::Connection> _terminal;
static bool _terminal_available = false;

Genode::Constructible<Timer::Connection> _timer;
static bool _timer_available = false;
static Genode::uint64_t _rt_resolution = 0;

extern Genode::Env *__genode_env;

void construct_terminal() {
   if (!_terminal_available && !_terminal.constructed()) {
      _terminal.construct(*__genode_env, "ada-runtime");
      _terminal_available = _terminal.constructed();
   }
}

extern "C" {

    _Unwind_Reason_Code __gnat_personality_v0(
            int,                        //version
            void *,                     //phases
            _Unwind_Exception_Class,    //exception class
            void *,                     //exception
            void *)                     //context
    {
        Genode::error(__func__);
        return _URC_FOREIGN_EXCEPTION_CAUGHT;
    }

    void put_char(const char c)
    {
        construct_terminal();
        if (_terminal_available) {
           _terminal->write(&c, 1);
        }
    }

    void put_char_stderr(const char c)
    {
        /* FIXME: We should output stderr via LOG */
        put_char(c);
    }

    void put_int(const int i)
    {
        construct_terminal();
        if (_terminal_available) {
            char buf[20];
            int len = Genode::snprintf(buf, sizeof(buf), "%d", i);
            _terminal->write(buf, len);
        }
    }

   void put_int_stderr(const int i)
   {
        /* FIXME: We should output stderr via LOG */
        put_int(i);
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

    void *allocate_secondary_stack(void * thread, Genode::size_t size)
    {
        return static_cast<Genode::Thread *>(thread)->alloc_secondary_stack("ada thread", size);
    }

    void *get_thread()
    {
        return static_cast<void *>(Genode::Thread::myself());
    }

#define exc_case(c, cpp) case c: throw Ada::Exception::cpp()

    void raise_ada_exception(exception_t exception, char *name, char *message)
    {
        Genode::error("Exception raised: ", Genode::Cstring(name), " in ", Genode::Cstring(message));
        switch(exception){
            exc_case(UNDEFINED_EXCEPTION,               Undefined_Error);
            exc_case(CE_EXPLICIT_RAISE,                 Constraint_Error);
            exc_case(CE_ACCESS_CHECK,                   Access_Check);
            exc_case(CE_NULL_ACCESS_PARAMETER,          Null_Access_Parameter);
            exc_case(CE_DISCRIMINANT_CHECK,             Discriminant_Check);
            exc_case(CE_DIVIDE_BY_ZERO,                 Divide_By_Zero);
            exc_case(CE_INDEX_CHECK,                    Index_Check);
            exc_case(CE_INVALID_DATA,                   Invalid_Data);
            exc_case(CE_LENGTH_CHECK,                   Length_Check);
            exc_case(CE_NULL_EXCEPTION_ID,              Null_Exception_Id);
            exc_case(CE_NULL_NOT_ALLOWED,               Null_Not_Allowed);
            exc_case(CE_OVERFLOW_CHECK,                 Overflow_Check);
            exc_case(CE_PARTITION_CHECK,                Partition_Check);
            exc_case(CE_RANGE_CHECK,                    Range_Check);
            exc_case(CE_TAG_CHECK,                      Tag_Check);
            exc_case(PE_EXPLICIT_RAISE,                 Program_Error);
            exc_case(PE_ACCESS_BEFORE_ELABORATION,      Access_Before_Elaboration);
            exc_case(PE_ACCESSIBILITY_CHECK,            Accessibility_Check);
            exc_case(PE_ADDRESS_OF_INTRINSIC,           Address_Of_Intrinsic);
            exc_case(PE_ALIASED_PARAMETERS,             Aliased_Parameters);
            exc_case(PE_ALL_GUARDS_CLOSED,              All_Guards_Closed);
            exc_case(PE_BAD_PREDICATED_GENERIC_TYPE,    Bad_Predicated_Generic_Type);
            exc_case(PE_CURRENT_TASK_IN_ENTRY_BODY,     Current_Task_In_Entry_Body);
            exc_case(PE_DUPLICATED_ENTRY_ADDRESS,       Duplicated_Entry_Address);
            exc_case(PE_IMPLICIT_RETURN,                Implicit_Return);
            exc_case(PE_MISALIGNED_ADDRESS_VALUE,       Misaligned_Address_Value);
            exc_case(PE_MISSING_RETURN,                 Missing_Return);
            exc_case(PE_OVERLAID_CONTROLLED_OBJECT,     Overlaid_Controlled_Object);
            exc_case(PE_NON_TRANSPORTABLE_ACTUAL,       Non_Transportable_Actual);
            exc_case(PE_POTENTIALLY_BLOCKING_OPERATION, Potentially_Blocking_Operation);
            exc_case(PE_STREAM_OPERATION_NOT_ALLOWED,   Stream_Operation_Not_Allowed);
            exc_case(PE_STUBBED_SUBPROGRAM_CALLED,      Stubbed_Subprogram_Called);
            exc_case(PE_UNCHECKED_UNION_RESTRICTION,    Unchecked_Union_Restriction);
            exc_case(PE_FINALIZE_RAISED_EXCEPTION,      Finalize_Raised_Exception);
            exc_case(SE_EXPLICIT_RAISE,                 Storage_Error);
            exc_case(SE_INFINITE_RECURSION,             Infinite_Recursion);
            exc_case(SE_OBJECT_TOO_LARGE,               Object_Too_Large);
            default:
                Genode::error("Unknown exception id: ", static_cast<int>(exception));
                throw Genode::Exception();
        }
    }

   Genode::uint64_t __ada_runtime_rt_resolution(void) {
      return _rt_resolution;
   }

   Genode::uint64_t __ada_runtime_rt_monotonic_clock(void) {
      if (_timer_available) {
         return _timer->elapsed_us() * 1000;
      }
      return 0;
   }

   void __ada_runtime_rt_initialize(void) {
      if (!_timer.constructed()) {
         _timer.construct(*__genode_env);
      }
      _timer_available = _timer.constructed();

      enum Iter { CALIBRATE_ITERATIONS = 1000 };
      for (int i = CALIBRATE_ITERATIONS; i > 0; i--)
      {
         Genode::uint64_t start = __ada_runtime_rt_monotonic_clock();
         Genode::uint64_t stop  = __ada_runtime_rt_monotonic_clock();
         _rt_resolution += stop - start;
      }
      _rt_resolution /= CALIBRATE_ITERATIONS;
   }
}
