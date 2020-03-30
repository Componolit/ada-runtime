#!/bin/sh

set -e
cd /app
make stm32f0
gprbuild -P tests/platform/stm32f0/test.gpr
make nrf52
gprbuild -P tests/platform/nrf52/test.gpr
