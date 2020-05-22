VERBOSE ?= @

COMPONENT = rts
OBJ_DIR = obj

SRC = $(SRC_COMMON) posix_common.c posix_minimal.c

SRC := $(sort $(SRC) $(patsubst %.adb, %.ads, $(filter %.adb, $(SRC))))

OBJ := $(filter-out %.h, $(patsubst %.c, %.o, $(patsubst %.adb, %.o, $(patsubst %.ads, %.o, $(SRC)))))

ALI := $(patsubst %.ads, %.ali, $(filter %.ads, $(SRC)))

dummy := $(shell mkdir -p $(OBJ_DIR)/adainclude $(OBJ_DIR)/adalib $(OBJ_DIR)/lib)

runtime: $(OBJ_DIR)/adalib/libgnat.a $(addprefix $(OBJ_DIR)/adalib/, $(ALI))

$(OBJ_DIR)/adalib/libgnat.a: $(OBJ_DIR)/adalib/libgnat.o
	$(VERBOSE)ar rcs $@ $<

$(OBJ_DIR)/adalib/libgnat.o: $(addprefix $(OBJ_DIR)/,$(OBJ))
	$(warning $(OBJ))
	$(VERBOSE)ld -relocatable $^ -o $@

.INTERMEDIATE: objects

$(OBJ_DIR)/%.o $(OBJ_DIR)/%.ali: objects
	@#

objects: $(addprefix $(OBJ_DIR)/adainclude/,$(SRC))
	$(VERBOSE)gprbuild --RTS=$(OBJ_DIR) -P$(COMPONENT) -XOBJECT_DIR=$(OBJ_DIR) -p

$(OBJ_DIR)/adalib/%.ali: $(OBJ_DIR)/%.ali
	$(VERBOSE)cp -a $< $@

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

$(OBJ_DIR)/adainclude/%: ../../platform/linux/%
	$(VERBOSE)cp -a $< $@

clean:
	$(VERBOSE)rm -rf $(OBJ_DIR)

.SECONDARY:
