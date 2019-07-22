# Componolit runtime platform interface

The Componolit runtime platform interface defines a linker interface the platform must provide.
That interface can either be implemented in C using [`componolit_runtime.h`](../platform/componolit_runtime.h) or in Ada using [`componolit_runtime.ads`](../platform/componolit_runtime.ads).
The table below shows the symbol names and language signatures to implement.
Note that the Ada signatures are not ABI compatible to the C signatures.
This has been done to simplify the support of native Ada platforms.
The package [`Componolit_Runtime.C`](../platform/componolit_runtime-c.ads) does the required conversions.

| Symbol                                   | C signature                                                               | Ada signature                                                                     |
|------------------------------------------|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| `componolit_runtime_log_debug`           | `void componolit_runtime_log_debug(char *)`                               | `procedure Log_Debug (Msg : String)`                                              |
| `componolit_runtime_log_warning`         | `void componolit_runtime_log_warning(char *)`                             | `procedure Log_Warning (Msg : String)`                                            |
| `componolit_runtime_log_error`           | `void componolit_runtime_log_error(char *)`                               | `procedure Log_Error (Msg : String)`                                              |
| `componolit_runtime_raise_ada_exception` | `void componolit_runtime_raise_ada_exception(exception_t, char *, char*)` | `procedure Raise_Ada_Exception (T : Exception_Type; Name : String; Msg : String)` |
| `componolit_runtime_initialize`          | `void componolit_runtime_initialize(void)`                                | `procedure Initialize`                                                            |
| `componolit_runtime_finalize`            | `void componolit_runtime_finalize(void)`                                  | `procedure Finalize`                                                              |


## Symbol definitions

### `componolit_runtime_log_debug`

#### Signature

 - C: `void componolit_runtime_log_debug(char *)`
 - Ada: `procedure Log_Debug(Msg : String)`

 * Msg: Log message

#### Semantics

Prints log message with debug priority.

### `componolit_runtime_log_warning`

#### Signature

 - C: `void componolit_runtime_log_warning(char *)`
 - Ada: `procedure Log_Warning(Msg : String)`

 * Msg: Log message

#### Semantics

Prints log message with warning priority.

### `componolit_runtime_log_error`

#### Signature

 - C: `void componolit_runtime_log_error(char *)`
 - Ada: `procedure Log_Error(Msg : String)`

 * Msg: Log message

#### Semantics

Prints log message with error priority.

### `componolit_runtime_raise_ada_exception`

#### Signature

 - C: `void componolit_runtime_raise_ada_exception(exception_t, char *, char*)`
 - Ada: `procedure Raise_Ada_Exception(T : Exception_Type; Name : String; Msg : String)`

 * T: Type of the exception (enum)
 * Name: Name of the raised exception (or short description)
 * Msg: Exception message

#### Semantics

Called when any exception is raised. The Name is usually the name of the Ada exception or a short description of it. In this runtime Msg consists of the file name and line number of the exception occurrence.

### `componolit_runtime_initialize`

#### Signature

 - C: `void componolit_runtime_initialize(void)`
 - Ada: `procedure Initialize`

#### Semantics

Called in `adainit` when the runtime gets initialized by the binder.
Implementation can be empty.

### `componolit_runtime_finalize`

#### Signature

 - C: `void componolit_runtime_finalize(void)`
 - Ada: `procedure Finalize`

#### Semantics

Called in `adafinal` when the runtime is finalized by the binder.
Implementation can be empty.

## Other symbols

When porting the runtime to a platform ther can be other missing symbols, often starting with `__gnat_`.
These are functions inserted by the compiler for memory management and exception handling.
As they are highly platform dependent and are not required by the runtime code to work they are not listed here.
