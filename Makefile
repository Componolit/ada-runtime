COMPONENT = rts
OBJ_DIR = obj

SRC = a-except.adb a-unccon.ads ada.ads i-c.adb i-cexten.ads i-cstrin.adb interfac.ads lib/external.adb lib/ss_utils.adb s-exctab.adb s-parame.adb s-secsta.adb s-soflin.adb s-stalib.ads s-stoele.adb system.ads
SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude/lib $(OBJ_DIR)/adalib)

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	gprbuild --RTS=./obj -P$(COMPONENT)

$(OBJ_DIR)/adainclude/%: src/%
	cp -a $< $@

$(OBJ_DIR)/adainclude/%: contrib/gcc/gcc/ada/%
	cp -a $< $@

clean:
	@rm -rf $(OBJ_DIR)
