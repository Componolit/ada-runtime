COMPONENT = rts
OBJ_DIR = obj
TEST_DIR = tests

SRC = a-except.adb a-unccon.ads ada.ads i-c.adb i-cexten.ads i-cstrin.adb interfac.ads external.adb ss_utils.adb s-exctab.adb s-parame.ads s-secsta.adb s-soflin.adb s-stalib.ads s-stoele.adb system.ads argv.c exit.c init.c
SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib)

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	gprbuild --RTS=./obj -P$(COMPONENT)

$(OBJ_DIR)/adainclude/%: src/%
	cp -a $< $@

$(OBJ_DIR)/adainclude/%: contrib/gcc/gcc/ada/%
	cp -a $< $@

clean: clean_test
	@rm -rf $(OBJ_DIR)

TEST_DIRS = $(addprefix $(TEST_DIR)/,$(shell ls tests))
TEST_BINS = $(addsuffix /test,$(TEST_DIRS))

$(TEST_DIR)/%/test:
	@echo "TEST $(dir $@)"
	@cd $(dir $@) && gprbuild --RTS=../../obj && ./test

test: clean_test $(TEST_BINS)

clean_test:
	$(foreach DIR,$(TEST_DIRS),cd $(DIR) && gprclean -Ptest; cd -;)
