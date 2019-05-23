VERBOSE ?= @

COMPONENT = rts
OBJ_DIR = obj
TEST_DIR = tests/system
UNIT_DIR = tests/unit

SRC = a-except.adb \
      a-unccon.ads \
      ada.ads \
      i-c.adb \
      i-cexten.ads \
      interfac.ads \
      runtime_lib.ads \
      runtime_lib-secondary_stack.adb \
      runtime_lib-strings.adb \
      runtime_lib-debug.adb \
      runtime_lib-platform.adb \
      runtime_lib-exceptions.ads \
      s-exctab.adb \
      s-init.adb \
      s-parame.adb \
      s-unstyp.ads \
      s-secsta.adb \
      s-soflin.adb \
      s-stalib.adb \
      s-stoele.adb \
      s-arit64.adb \
      system.ads \
      argv.c \
      exit.c \
      init.c \
      gnat.ads \
      g-io.adb \

ifneq ($(USE_GNATIO),)
SRC += gnat.ads g-io.ads g-io.adb
endif

SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib $(OBJ_DIR)/lib)

runtime: $(OBJ_DIR)/adalib/libgnat.a

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	$(VERBOSE)gprbuild --RTS=./obj -P$(COMPONENT) -p

$(OBJ_DIR)/adainclude/%: src/minimal/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: src/common/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: src/lib/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: contrib/gcc-8.3.0/%
	$(VERBOSE)cp -a $< $@

platform: $(OBJ_DIR)/lib/libposix_rts.a

$(OBJ_DIR)/lib/libposix_rts.a: $(OBJ_DIR)/posix_common.o $(OBJ_DIR)/posix_minimal.o
	$(VERBOSE)ar rcs $@ $^

$(OBJ_DIR)/%.o: platform/%.c
	$(VERBOSE)gcc -c -o $@ $<

clean: clean_test
	$(VERBOSE)rm -rf $(OBJ_DIR)

TEST_DIRS = $(addprefix $(TEST_DIR)/,$(shell ls tests/system))
TEST_BINS = $(addsuffix /test,$(TEST_DIRS))

$(TEST_DIR)/%/test:
	@echo "TEST $(dir $@)"
	$(VERBOSE)cd $(dir $@) && gprbuild -q --RTS=../../../obj -p && ./test

$(UNIT_DIR)/test:
	@echo "UNITTEST $(dir $@)"
	$(VERBOSE)cd $(dir $@) && gprbuild -q -P test && ./test

test: runtime platform clean_test $(TEST_BINS) $(UNIT_DIR)/test

clean_test:
	$(VERBOSE)$(foreach DIR,$(TEST_DIRS) $(UNIT_DIR),cd $(DIR) && gprclean -q -Ptest -r; cd -;)
