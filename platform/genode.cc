
#include <base/exception.h>
#include <base/log.h>
#include <base/thread.h>
#include <util/string.h>

#include <ada/exception.h>
#include <ada_exceptions.h>

class Gnat_Exception : public Genode::Exception {};

extern "C" {

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
}
