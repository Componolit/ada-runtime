
#ifndef _GNAT_HELPERS_H_
#define _GNAT_HELPERS_H_

typedef enum
{ } _Unwind_State;

typedef enum
{
    _URC_CONTINUE_UNWIND = 8,
    _URC_FAILURE = 9
} _Unwind_Reason_Code;

typedef unsigned _Unwind_Exception_Class __attribute__((__mode__(__DI__)));


#endif /* ifndef _GNAT_HELPERS_H_ */
