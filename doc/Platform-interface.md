| Symbol                             | C signature                                            | Ada signature                                                                                       |
|------------------------------------|--------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `log_debug`                        | `void log_debug(char *)`                               | `procedure Log_Debug (Msg : String)`                                                                |
| `log_warning`                      | `void log_warning(char *)`                             | `procedure Log_Warning (Msg : String)`                                                              |
| `log_error`                        | `void log_error(char *)`                               | `procedure Log_Error (Msg : String)`                                                                |
| `__gnat_malloc`                    | `void *__gnat_malloc(size_t)`                          | `function Malloc (Size : Natural) return System.Address`                                            |
| `__gnat_free`                      | `void __gnat_free(void *)`                             | `procedure Free (Ptr : System.Address)`                                                             |
| `__gnat_unhandled_terminate`       | `void __gnat_unhandled_terminate()`                    | `procedure Unhandled_Terminate`                                                                     |
| `allocate_secondary_stack`         | `void *allocate_secondary_stack(void *, size_t)`       | `function Allocate_Secondary_Stack (Thread : System.Address; Size : Natural) return System.Address` |
| `get_thread`                       | `void *get_thread()`                                   | `function Get_Thread return System.Address`                                                         |
| `raise_ada_exception`              | `void raise_ada_exception(exception_t, char *, char*)` | `procedure Raise_Ada_Exception (T : Exception_Type; Name : String; Msg : String)`                   |
| `put_char`                         | `void put_char(const char)`                            | `procedure Put_Char (C : Character)`                                                                |
| `put_char_stderr`                  | `void put_char_stderr(const char)`                     | `procedure Put_Char_Stderr (C : Character)`                                                         |
| `get_char`                         | `char get_char(void)`                                  | `function Get_Char (C : Character) return Character`                                                |
| `put_int`                          | `void put_int(const int)`                              | `procedure Put_Int (X : Integer)`                                                                   |
| `put_int_stderr`                   | `void put_int_stderr(const int)`                       | `procedure Put_Int_Stderr (X : Integer)`                                                            |
| `get_int`                          | `int get_int(void)`                                    | `function Get_Int return Integer`                                                                   |
| `__ada_runtime_rt_initialize`      | `void __ada_runtime_rt_initialize(void)`               | `procedure Initialize`                                                                              |
| `__ada_runtime_rt_monotonic_clock` | `u_int64_t __ada_runtime_rt_monotonic_clock(void)`     | `function Monotonic_Clock return Time`                                                              |
| `__ada_runtime_rt_resolution`      | `u_int64_t __ada_runtime_rt_resolution(void)`          | `function RT_Resolution return Duration`                                                            |
| `__ada_runtime_exit_status`        | `int __ada_runtime_exit_status`                        | n/a                                                                                                 |


# Symbol definitions

## `log_debug`

### Signature

 - C: `void log_debug(char *)`
 - Ada: `procedure Log_Debug(Msg : String)`

 * Msg: Log message

### Semantics

Prints log message with debug priority.

## `log_warning`

### Signature

 - C: `void log_warning(char *)`
 - Ada: `procedure Log_Warning(Msg : String)`

 * Msg: Log message

### Semantics

Prints log message with warning priority.

## `log_error`

### Signature

 - C: `void log_error(char *)`
 - Ada: `procedure Log_Error(Msg : String)`

 * Msg: Log message

### Semantics

Prints log message with error priority.

## `__gnat_malloc`

### Signature
 
 - C: `void *__gnat_malloc(size_t)`
 - Ada: `function Malloc(Size : Natural) return System.Address`

 * Size: Memory size that shall be allocated

### Semantics

Allocates memory on the heap. When Size is 0 a null pointer should be returned.

## `__gnat_free`

### Signature

 - C: `void __gnat_free(void *)`
 - Ada: `procedure Free(Ptr : System.Address)`

 * Ptr: Address of memory range that should be freed

### Semantics

Frees (only) memory allocated by `__gnat_malloc`. Should do nothing if Ptr is a null pointer.

## `__gnat_unhandled_terminate`

### Signature

 - C: `void __gnat_unhandled_terminate()`
 - Ada: `procedure Unhandled_Terminate`

### Semantics

Called if an exception has been raised and no exception handler is able to catch it. Should terminate the program.

## `allocate_secondary_stack`

### Signature

 - C: `void *allocate_secondary_stack(void *, size_t)`
 - Ada: `function Allocate_Secondary_Stack(Thread : System.Address; Size : Natural) return System.Address`

 * Thread: thread ID of the current thread
 * Size: size of the stack frame to be allocated

### Semantics

Allocates a secondary stack frame in this thread. As the thread grows downwards the returned address must be the upper address of the stack frame. While the thread ID is a pointer type it can be of any value and must not be a valid address (at least not inside the runtime). The only condition is that it is not `0` as this is the reserved invalid thread ID.

## `get_thread`

### Signature

 - C: `void *get_thread()`
 - Ada `function Get_Thread return System.Address`

### Semantics

Returns the ID of the current thread. This ID is used in `allocate_secondary_stack` and can be anything except `0` which is the reserved invalid thread ID.

## `raise_ada_exception`

### Signature

 - C: `void raise_ada_exception(exception_t, char *, char*)`
 - Ada: `procedure Raise_Ada_Exception(T : Exception_Type; Name : String; Msg : String)`

 * T: Type of the exception (enum)
 * Name: Name of the raised exception (or short description)
 * Msg: Exception message

### Semantics

Called when any exception is raised. The Name is usually the name of the Ada exception or a short description of it. In this runtime Msg consists of the file name and line number of the exception occurrence.

## `put_char`

### Signature

 - C: `void put_char(const char)`
 - Ada: `procedure Put_Char(C : Character)`

### Semantics

Called to output a single character to standard output.

## `get_char`

### Signature

 - C: `char get_char(voi)`
 - Ada: `function Get_Char return Character`

### Semantics

Called to read a single character from standard output.

## `put_char_stderr`

### Signature

 - C: `void put_char_stderr(const char)`
 - Ada: `procedure Put_Char_Stderr(C : Character)`

### Semantics

Called to output a single character to standard error.

## `put_int`

### Signature

 - C: `void put_int(const int)`
 - Ada: `procedure Put_Int(X : Integer)`

### Semantics

Called to output a single integer to standard output.

## `get_int`

### Signature

 - C: `int get_int(voi)`
 - Ada: `function Get_Int return Integer`

### Semantics

Called to read a single integer from standard input.

## `put_int_stderr`

### Signature

 - C: `void put_int_stderr(const int)`
 - Ada: `procedure Put_Int_Stderr(X : Integer)`

### Semantics

Called to output a single integer to standard error.

## `__ada_runtime_rt_initialize`

### Signature

 - C: `void __ada_runtime_rt_initialize(void)`
 - Ada: `procedure Initialize`

### Semantics

Perform initialization required to use `__ada_runtime_rt_monotonic_clock`  and
`__ada_runtime_rt_resolution`.

## `__ada_runtime_rt_monotonic_clock`

### Signature

 - C: `u_int64_t __ada_runtime_rt_monotonic_clock(void)`
 - Ada: `function Monotonic_Clock return Time`

### Semantics

Return amount of time elapsed since epoch in Nanoseconds.

## `__ada_runtime_rt_resolution`

### Signature

 - C: `u_int64_t __ada_runtime_rt_resolution(void)`
 - Ada: `function RT_Resolution return Duration`

### Semantics

Return the average time interval during which the clock interval obtained by
calling `__ada_runtime_rt_monotonic_clock` remains constant in Nanoseconds.

## `__ada_runtime_exit_status`

### Signature

 - C: `int __ada_runtime_exit_status`

### Semantics

Contains the applications exit status as set by
`Ada.Command_Line.Set_Exit_Status`.
