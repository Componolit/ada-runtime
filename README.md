# generic Ada runtime implementation

## directory structure

 - `src/`: ada runtime sources
 - `src/lib`: implementations of required functionality, e.g. a range allocator for the secondary stack

## required environment

### missing runtime symbols

These symbols should be provided by the runtime itself, later they should not be missing.

 - `__gnat_personality_v0`
 - `__gnat_rcheck_CE_Explicit_Raise`
 - `__gnat_rcheck_CE_Index_Check`
 - `__gnat_rcheck_CE_Overflow_Check`
 - `__gnat_rcheck_PE_Explicit_Raise`
 - `__gnat_rcheck_SE_Explicit_Raise`

### external symbols

The following symbols are required to be provided by the platform. They are platform dependent and should not be implemented here:

 - `raise_ada_exception` is a `void func(char *name, char *message)` that gets the exceptions name and message (may be null pointers with the current implementation) and propagates them
 - `warn_unimplemented_function` is a `void func(char *message)` warning message that is called in not or incompletely implemented functions
 - `__gnat_malloc` is a `void *func(size_t size)` allocator that returns a pointer to a allocated chunk of memory of size `size`
 - `__gnat_free` is a `void func(void *ptr)` that frees the memory allocated by `__gnat_malloc`
 - `allocate_secondary_stack` is a `void *func(void *thread, size_t size)` that allocates a secondary stack of size `size` for thread `thread` (which can be either a pointer to a stack object or a stack identifier)
 - `get_thread` is a `void *func()` that returns the current thread (should be consistent to the implementation of `thread` in `allocate_secondary_stack`)
