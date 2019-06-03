
#ifndef _COMPONOLIT_RUNTIME_H_
#define _COMPONOLIT_RUNTIME_H_

#include <ada_exceptions.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
    _URC_FOREIGN_EXCEPTION_CAUGHT = 1,
    _URC_CONTINUE_UNWIND = 8
} _Unwind_Reason_Code;

typedef unsigned _Unwind_Exception_Class __attribute__((__mode__(__DI__)));

void componolit_runtime_log_debug(char *);

void componolit_runtime_log_warning(char *);

void componolit_runtime_log_error(char *);

void componolit_runtime_unhandled_terminate(void);

void componolit_runtime_raise_ada_exception(exception_t, char *, char *);

void componolit_runtime_allocate_secondary_stack(unsigned, void **);

_Unwind_Reason_Code componolit_runtime_personality(
        int version,
        unsigned long phase,
        _Unwind_Exception_Class cls,
        void *exc,
        void *context);

void componolit_runtime_initialize(void);

void componolit_runtime_finalize(void);

#ifdef __cplusplus
}
#endif

#endif /* ifndef _COMPONOLIT_RUNTIME_H_ */
