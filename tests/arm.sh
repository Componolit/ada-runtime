#!/bin/sh

set -e
make stm32f0
gprbuild -P tests/platform/stm32f0/test.gpr
gprclean -P tests/platform/stm32f0/test.gpr
make clean
for board in default bluefruit_feather sparkfun
do
    make nrf52 BOARD=$board
    gprbuild -P tests/platform/nrf52/test.gpr
    gprclean -P tests/platform/nrf52/test.gpr
    make clean
done
