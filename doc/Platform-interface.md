| Symbol                             | C signature                                            | Ada signature                                                                                       |
|------------------------------------|--------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `log_debug`                        | `void log_debug(char *)`                               | `procedure Log_Debug (Msg : String)`                                                                |
| `log_warning`                      | `void log_warning(char *)`                             | `procedure Log_Warning (Msg : String)`                                                              |
| `log_error`                        | `void log_error(char *)`                               | `procedure Log_Error (Msg : String)`                                                                |
| `__gnat_malloc`                    | `void *__gnat_malloc(size_t)`                          | `function Malloc (Size : Natural) return System.Address`                                            |
| `__gnat_free`                      | `void __gnat_free(void *)`                             | `procedure Free (Ptr : System.Address)`                                                             |
| `__gnat_unhandled_terminate`       | `void __gnat_unhandled_terminate()`                    | `procedure Unhandled_Terminate`                                                                     |
| `__gnat_personality_v0`            | `int __gnat_personality_v0(int, void *, unsigned, void *, void *)` | n/a |
| `allocate_secondary_stack`         | `void allocate_secondary_stack(size_t, void **)`       | `procedure Allocate_Secondary_Stack (Size : Natural; Address : out System.Address)` |
| `raise_ada_exception`              | `void raise_ada_exception(exception_t, char *, char*)` | `procedure Raise_Ada_Exception (T : Exception_Type; Name : String; Msg : String)`                   |
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

## `__gnat_personality_v0`

### Signature

 - C: `int __gnat_personality_v0(int, void *, unsigned, void *, void *)`
 
### Semantics

Called if an exception is thrown, used to unwind the stack frame. Since exceptions are not supported in this runtime other than raising this function should either pass the exception to the platform or exit the program.
The return value depicts the exception unwind reason. For a simple implementation a foreign exception is assumed that is handled by the platform which can be indicated by returning `1`.

## `allocate_secondary_stack`

### Signature

 - C: `void allocate_secondary_stack(size_t, void **)`
 - Ada: `procedure Allocate_Secondary_Stack(Size : Natural; Address : out System.Address)`

 * Size: size of the stack frame to be allocated
 * Address: base address of the stack

### Semantics

Allocates a secondary stack frame. As the stack grows downwards the address must be the upper address of the stack frame. In C the function gets a pointer to an uninitialized void pointer that needs to be initialized with the stack base pointer.

## `raise_ada_exception`

### Signature

 - C: `void raise_ada_exception(exception_t, char *, char*)`
 - Ada: `procedure Raise_Ada_Exception(T : Exception_Type; Name : String; Msg : String)`

 * T: Type of the exception (enum)
 * Name: Name of the raised exception (or short description)
 * Msg: Exception message

### Semantics

Called when any exception is raised. The Name is usually the name of the Ada exception or a short description of it. In this runtime Msg consists of the file name and line number of the exception occurrence.

## `__ada_runtime_exit_status`

### Signature

 - C: `int __ada_runtime_exit_status`

### Semantics

Contains the applications exit status as set by
`Ada.Command_Line.Set_Exit_Status`.
