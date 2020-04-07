# Generic Ada Runtime [![CI](https://github.com/Componolit/ada-runtime/workflows/CI/badge.svg)](https://github.com/Componolit/ada-runtime/actions)

The generic Ada runtime is a downsized Ada runtime which can be adapted to different platforms.
The offered feature set is a tradeoff between complexity and useful features.

## Features

The runtime includes a variety of specs providing types and compiler intrinsics.
It furthermore adds a small selection of more complex features:

- Secondary stack
  - SPARK proof:
    no runtime errors,
    safe program abort in case of stack overflow, stack underflow or invalid stack count
- 64bit arithmetic
  - SPARK proof:
    addition and subtraction with overflow check have no runtime errors,
    both functions perform a correct addition/subtraction
- Exception support
  - Exceptions can only be thrown but not catched, there is only a last chance handler available

## Platforms

- Posix/Linux
- [Genode](https://genode.org/)
- [Muen](https://muen.sk/)
- nRF52832
- STM32F051
- ESP8266 on Arduino

## Directory Structure

- `contrib/`: external sources (GCC 8.3)
- `platform/`: platform-specific sources of Ada runtime
- `src/`: Ada runtime sources
- `tests/`: test sources
- `build`: platform specific build directories

## Platform-specific Symbols

To enable a new platform for this runtime the platform needs to provide a set of linker symbols.
Please have a look into the [platform interface](doc/Platform-interface.md) description.
