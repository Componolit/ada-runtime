VERBOSE ?= @
BOARD ?= default

TEST_DIR = tests/system
UNIT_DIR = tests/unit

SRC_COMMON = a-except.adb \
	     a-unccon.ads \
	     ada.ads \
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
	$(VERBOSE)cd $(dir $@) && gprbuild -q --RTS=../../../build/posix/obj -p && ./test

$(UNIT_DIR)/test:
	@echo "UNITTEST $(dir $@)"
	$(VERBOSE)cd $(dir $@) && gprbuild -q -P test && ./test

test: posix clean_test $(TEST_BINS) $(UNIT_DIR)/test

REPORT ?= fail

proof:
	$(VERBOSE)gnatprove --level=3 --checks-as-errors -j0 -Psrc/componolit_runtime.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)

clean: clean_test
	make -C build/posix clean
	make -C build/arduino_esp8266 clean
	make -C build/nrf52 clean

clean_test:
	$(VERBOSE)$(foreach DIR,$(TEST_DIRS) $(UNIT_DIR),cd $(DIR) && gprclean -q -Ptest -r; cd -;)
