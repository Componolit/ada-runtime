VERBOSE ?= @

TEST_DIR = tests/system
UNIT_DIR = tests/unit

.PHONY: posix esp8266

posix:
	make -C build/posix

esp8266:
	make -C build/arduino_esp8266

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

clean_test:
	$(VERBOSE)$(foreach DIR,$(TEST_DIRS) $(UNIT_DIR),cd $(DIR) && gprclean -q -Ptest -r; cd -;)
