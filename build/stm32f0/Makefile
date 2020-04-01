VERBOSE ?= @

COMPONENT = rts
OBJ_DIR = obj

SRC = $(SRC_COMMON) \
      gnat_helpers.ads \
      componolit_runtime.ads \
      componolit_runtime.adb \
      componolit_runtime-c.ads \
      componolit_runtime-c.adb \
      componolit-runtime-drivers.ads \
      componolit-runtime-drivers-gpio.ads \
      componolit-runtime-drivers-gpio.adb \
      componolit-runtime-drivers-rcc.ads \
      componolit-runtime-drivers-rcc.adb

SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib $(OBJ_DIR)/lib)

runtime: $(OBJ_DIR)/adalib/libgnat.a

$(OBJ_DIR)/adalib/libgnat.a: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	$(VERBOSE)gprbuild --RTS=$(OBJ_DIR) -P$(COMPONENT) -XOBJECT_DIR=$(OBJ_DIR) -p

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

$(OBJ_DIR)/adainclude/%: ../../platform/stm32f0/%
	$(VERBOSE)cp -a $< $@

$(OBJ_DIR)/adainclude/%: ../../platform/stm32f0/drivers/%
	$(VERBOSE)cp -a $< $@

clean:
	$(VERBOSE)rm -rf $(OBJ_DIR)
