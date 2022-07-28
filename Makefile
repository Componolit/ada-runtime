VERBOSE ?= @
BOARD ?= default

TEST_DIR = tests/system
UNIT_DIR = tests/unit

SRC_COMMON = a-except.adb \
	     a-unccon.ads \
	     ada.ads \
	     a-tags.ads \
	     a-tags.adb \
	     a-numeri.ads \
	     a-nubinu.ads \
	     a-nbnbin.adb \
	     i-c.adb \
	     i-cexten.ads \
	     interfac.ads \
	     componolit.ads \
	     componolit-runtime.ads \
	     componolit-runtime-strings.adb \
	     componolit-runtime-debug.adb \
	     componolit-runtime-platform.adb \
	     componolit-runtime-exceptions.ads \
	     componolit-runtime-conversions.adb \
	     s-exctab.adb \
	     s-init.adb \
	     s-parame.adb \
	     s-unstyp.ads \
	     s-secsta.adb \
	     s-soflin.adb \
	     s-stalib.adb \
	     s-stoele.adb \
	     s-arit64.adb \
	     s-maccod.ads \
	     system.ads \
	     argv.c \
	     exit.c \
	     init.c \
	     componolit_runtime.h \
	     ada_exceptions.h \
	     gnat_helpers.h

.PHONY: posix esp8266

posix:
	make SRC_COMMON="$(SRC_COMMON)" -C build/posix

esp8266:
	make SRC_COMMON="$(SRC_COMMON)" -C build/arduino_esp8266

nrf52:
	make BOARD=$(BOARD) SRC_COMMON="$(SRC_COMMON)" -C build/nrf52

stm32f0:
	make BOARD=$(BOARD) SRC_COMMON="$(SRC_COMMON)" -C build/stm32f0

TEST_DIRS = $(addprefix $(TEST_DIR)/,$(shell ls tests/system))
TEST_BINS = $(addsuffix /test,$(TEST_DIRS))

$(TEST_DIR)/%/test:
	@echo "TEST $(dir $@)"
	$(VERBOSE)cd $(dir $@) && gprbuild -p -q --RTS=../../../build/posix/obj -p && ./test

$(TEST_DIR)/exception/test:
	@echo "TEST $(dir $@)"
	$(VERBOSE)cd $(dir $@) && gprbuild -p -q --RTS=../../../build/posix/obj -p && ./test; test $$? -gt 0

$(UNIT_DIR)/test:
	@echo "UNITTEST $(dir $@)"
	$(VERBOSE)cd $(dir $@) && gprbuild -p -q -P test && ./test

test: posix clean_test $(TEST_BINS) $(UNIT_DIR)/test

REPORT ?= fail

proof: stm32f0 nrf52
	$(VERBOSE)gnatprove --level=3 --checks-as-errors -j0 -Psrc/componolit_runtime.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)
	$(VERBOSE)gnatprove --level=4 --checks-as-errors -j0 -Pplatform/stm32f0/drivers.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)
	$(VERBOSE)gnatprove --level=3 --checks-as-errors -j0 -Pplatform/nrf52/drivers.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)
	$(VERBOSE)gnatprove --level=3 --checks-as-errors -j0 -Ptests/platform/stm32f0/test.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)
	$(VERBOSE)gnatprove --level=3 --checks-as-errors -j0 -Ptests/platform/nrf52/test.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)

install_gnat_11:
	alr toolchain --install gnat_native=11.2.1 && \
	alr toolchain --select gnat_native=11.2.1 && \
	mkdir -p build && \
	cd build && \
	alr -n init --lib gnat_11 && \
	cd gnat_11 && \
	alr -n with aunit

printenv_gnat_11:
	@test -d build/gnat_11 && \
	cd build/gnat_11 && \
	alr printenv

clean: clean_test
	make -C build/posix clean
	make -C build/arduino_esp8266 clean
	make -C build/nrf52 clean
	make -C build/stm32f0 clean

clean_test:
	$(VERBOSE)$(foreach DIR,$(TEST_DIRS) $(UNIT_DIR),cd $(DIR) && gprclean -q -Ptest -r; cd -;)
