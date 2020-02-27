VERBOSE ?= @

COMPONENT = rts
OBJ_DIR = obj

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
      componolit_runtime.h \
      ada_exceptions.h \
      gnat_helpers.h

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
