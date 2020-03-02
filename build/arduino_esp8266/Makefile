VERBOSE ?= @

COMPONENT = rts
OBJ_DIR = obj

SRC = $(SRC_COMMON) arduino_esp8266.c

SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib $(OBJ_DIR)/lib)

runtime: src/esp8266/ada_runtime.a

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	$(VERBOSE)gprbuild --RTS=$(OBJ_DIR) -P$(COMPONENT) -XOBJECT_DIR=$(OBJ_DIR) -XTARGET=esp8266 -p

$(OBJ_DIR)/adainclude/%: ../../src/minimal/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: ../../src/common/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: ../../src/lib/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: ../../contrib/gcc-8.3.0/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: ../../platform/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: ../../platform/esp8266/%
	$(VERBOSE)cp -a $< $@

src/esp8266:
	mkdir -p src/esp8266

src/esp8266/ada_runtime.a: $(OBJ_DIR)/adalib/libgnat.a src/esp8266
	$(VERBOSE)cp -a $< $@

clean:
	$(VERBOSE)rm -rf $(OBJ_DIR)
	$(VERBOSE)rm -f src/esp8266/ada_runtime.a
