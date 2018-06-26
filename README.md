# Generic Ada Runtime [![Build Status](https://travis-ci.org/Componolit/ada-runtime.svg?branch=master)](https://travis-ci.org/Componolit/ada-runtime)

A downsized Ada runtime which can be adapted to different platforms.

## Directory Structure

- `contrib/`: external sources (GCC 6.3)
- `platform/`: platform-specific sources of Ada runtime (POSIX implementation used for tests)
- `src/`: Ada runtime sources
- `tests/`: test sources

## Platform-specific Symbols

The following symbols are required to be provided by the platform:

- `__gnat_malloc` is a `void *func(size_t size)` allocator that returns a pointer to a allocated chunk of memory of size `size`
- `__gnat_free` is a `void func(void *ptr)` that frees the memory allocated by `__gnat_malloc`
- `__gnat_unhandled_terminate` is a ` void func()` that is called if an unhandled exception occurs
- `allocate_secondary_stack` is a `void *func(void *thread, size_t size)` that allocates a secondary stack of size `size` for thread `thread` (which can be either a pointer to a stack object or a stack identifier)
- `get_thread` is a `void *func()` that returns the current thread (should be consistent to the implementation of `thread` in `allocate_secondary_stack`)
- `raise_ada_exception` is a `void func(char *name, char *message)` that gets the exceptions name and message (may be null pointers with the current implementation) and propagates them
- `warn_unimplemented_function` is a `void func(char *message)` warning message that is called in not or incompletely implemented functions
