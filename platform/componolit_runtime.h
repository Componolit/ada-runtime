
#ifndef _COMPONOLIT_RUNTIME_H_
#define _COMPONOLIT_RUNTIME_H_

#include <ada_exceptions.h>

#ifdef __cplusplus
extern "C" {
#endif

void componolit_runtime_log_debug(char *);

void componolit_runtime_log_warning(char *);

void componolit_runtime_log_error(char *);

void componolit_runtime_raise_ada_exception(exception_t, char *, char *);

void componolit_runtime_allocate_secondary_stack(unsigned, void **);

void componolit_runtime_initialize(void);

void componolit_runtime_finalize(void);

#ifdef __cplusplus
}
#endif

#endif /* ifndef _COMPONOLIT_RUNTIME_H_ */
