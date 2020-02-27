
#include <gnat_helpers.h>

extern void exit(int);

void __gnat_unhandled_terminate()
{
    exit(0);
}

void componolit_runtime_raise_ada_exception(int exception, char *name, char *message)
{
    exit(0);
}

#define LOG(type) void componolit_runtime_log_##type(char *message) { \
}

LOG(debug)
LOG(warning)
LOG(error)

_Unwind_Reason_Code __gnat_personality_v0(int version,
                                          unsigned long phases,
                                          _Unwind_Exception_Class class,
                                          void *exception,
                                          void *context)
{
    exit(0);
}
