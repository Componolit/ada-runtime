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

SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib $(OBJ_DIR)/lib)

runtime: $(OBJ_DIR)/adalib/libgnat.a

$(OBJ_DIR)/adalib/libgnat.so: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	$(VERBOSE)gprbuild --RTS=$(OBJ_DIR) -P$(COMPONENT) -XOBJECT_DIR=$(OBJ_DIR) -XLIBRARY_KIND=dynamic -p

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC)) $(OBJ_DIR)/adalib/libgnat.so
	$(VERBOSE)gprbuild --RTS=$(OBJ_DIR) -P$(COMPONENT) -XOBJECT_DIR=$(OBJ_DIR) -p

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

$(OBJ_DIR)/%.o: platform/linux/%.c
	$(VERBOSE)gcc -Iplatform -c -o $@ $<

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

REPORT ?= fail

proof:
	$(VERBOSE)gnatprove --level=3 --checks-as-errors -j0 -Psrc/componolit_runtime.gpr -XOBJECT_DIR=$(OBJ_DIR) --info --report=$(REPORT)

clean_test:
	$(VERBOSE)$(foreach DIR,$(TEST_DIRS) $(UNIT_DIR),cd $(DIR) && gprclean -q -Ptest -r; cd -;)
