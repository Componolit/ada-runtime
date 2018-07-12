# Generic Ada Runtime [![Build Status](https://travis-ci.org/Componolit/ada-runtime.svg?branch=master)](https://travis-ci.org/Componolit/ada-runtime)

A downsized Ada runtime which can be adapted to different platforms.

## Directory Structure

- `contrib/`: external sources (GCC 6.3)
- `platform/`: platform-specific sources of Ada runtime (POSIX implementation used for tests)
- `src/`: Ada runtime sources
- `tests/`: test sources

## Platform-specific Symbols

Some symbols are required to be provided by the platform. Please have a look into the [platform interface](https://github.com/Componolit/ada-runtime/wiki/Platform-interface) description.
