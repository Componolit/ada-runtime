COMPONENT = rts
OBJ_DIR = obj
TEST_DIR = tests/system
UNIT_DIR = tests/unit

SRC = a-except.adb \
      a-unccon.ads \
      ada.ads \
      ada_exceptions.ads \
      i-c.adb \
      i-cexten.ads \
      i-cstrin.adb \
      interfac.ads \
      platform.adb \
      ss_utils.adb \
      s-exctab.adb \
      s-imgint.adb \
      s-init.adb \
      s-parame.ads \
      s-unstyp.ads \
      s-secsta.adb \
      s-soflin.adb \
      s-stalib.ads \
      s-stoele.adb \
      string_utils.adb \
      system.ads \
      argv.c \
      exit.c \
      init.c

SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib $(OBJ_DIR)/lib)

runtime: $(OBJ_DIR)/adalib/libgnat.a

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	gprbuild --RTS=./obj -P$(COMPONENT) -p

$(OBJ_DIR)/adainclude/%: src/%
	cp -a $< $@

$(OBJ_DIR)/adainclude/%: src/lib/%
	cp -a $< $@

$(OBJ_DIR)/adainclude/%: contrib/gcc-6.3.0/%
	cp -v -a $< $@

platform: $(OBJ_DIR)/lib/libposix_rts.a

$(OBJ_DIR)/lib/libposix_rts.a: $(OBJ_DIR)/posix.o
	ar rcs $@ $^

$(OBJ_DIR)/%.o: platform/%.c
	gcc -c -o $@ $<

clean: clean_test
	@rm -rf $(OBJ_DIR)

TEST_DIRS = $(addprefix $(TEST_DIR)/,$(shell ls tests/system))
TEST_BINS = $(addsuffix /test,$(TEST_DIRS))

$(TEST_DIR)/%/test:
	@echo "TEST $(dir $@)"
	@cd $(dir $@) && gprbuild --RTS=../../../obj -p && ./test

$(UNIT_DIR)/test:
	@echo "UNITTEST $(dir $@)"
	@cd $(dir $@) && gprbuild -P test && ./test

test: runtime platform clean_test $(TEST_BINS) $(UNIT_DIR)/test

clean_test:
	$(foreach DIR,$(TEST_DIRS) $(UNIT_DIR),cd $(DIR) && gprclean -Ptest -r; cd -;)
