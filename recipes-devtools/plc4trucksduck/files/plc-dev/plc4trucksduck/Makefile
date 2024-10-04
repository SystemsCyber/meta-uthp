PRU_CGT := /usr/share/ti/cgt-pru
PRU_SUPPORT := ../pru-software-support-package

# Compiler and Hex utilities
CLPRU = clpru
ifeq (, $(shell which clpru))
    CLPRU = $(PRU_CGT)/usr/bin/clpru
endif

# Include directories and libraries
PRU_INC = $(PRU_CGT)/usr/share/ti/cgt-pru/include
ifeq (, $(wildcard $(PRU_INC)))
    PRU_INC = $(PRU_CGT)/include
endif

PRU_LIBC = $(PRU_CGT)/usr/share/ti/cgt-pru/lib/libc.a
ifeq (, $(wildcard $(PRU_LIBC)))
    PRU_LIBC = $(PRU_CGT)/lib/libc.a
endif

# Directories
ARM_SRC_DIR = src/arm
ARM_BUILD_DIR = src/arm/build

PRU_SRC_DIR = src/pru
PRU_GEN_DIR = src/pru/generated


# Device tree sources and output files
# 16-byte DTBO cape name limit
THIS_DTS_SOURCE = $(ARM_SRC_DIR)/BB-PLC4TRUCKSDUC-00A0.dts
THIS_DTB_OFILE = $(ARM_BUILD_DIR)/BB-PLC4TRUCKSDUC-00A0.dtbo

DTB_OFILES = $(THIS_DTB_OFILE) $(PARENT_DTB_OFILE)

# PRU source files, object files, and binaries
J17084TRUCKDUCK_SOURCES = $(PRU_SRC_DIR)/j17084truckduck.c
J17084TRUCKDUCK_OFILE = $(PRU_GEN_DIR)/j17084truckduck.out

PLC4TRUCKSDUCK_SOURCES = $(PRU_SRC_DIR)/plc4trucksduck.c
PLC4TRUCKSDUCK_OFILE = $(PRU_GEN_DIR)/plc4trucksduck.out

PRU_BINS = $(J17084TRUCKDUCK_OFILE) $(PLC4TRUCKSDUCK_OFILE)

# Compiler and linker flags
# Align stack size to 4 bytes
STACK_SIZE = $(shell expr 8 + 8 + 8 + 8 + 344)
# Added: --hardware_mac=on -ppd -ppa
CFLAGS = --c99 -v3 -O1 --endian=little --keep_asm --asm_directory=$(PRU_GEN_DIR) \
         --obj_directory=$(PRU_GEN_DIR) --pp_directory=$(PRU_GEN_DIR) -ss \
         --symdebug:none --display_error_number --hardware_mac=on -ppd -ppa --diag_remark=1119
INC = -I$(PRU_INC) -I$(PRU_SUPPORT)/include -I$(PRU_SUPPORT)/include/am335x
LFLAGS = --reread_libs --warn_sections --stack_size=$(STACK_SIZE)
LIBS = --library=$(PRU_LIBC) $(PRU_SRC_DIR)/AM335x_PRU_intc_rscTbl.cmd \
       --library=$(PRU_SUPPORT)/lib/rpmsg_lib.lib

# Targets
all: $(PRU_BINS) $(DTB_OFILES)

# Device tree compilation
$(THIS_DTB_OFILE): $(THIS_DTS_SOURCE) | $(ARM_BUILD_DIR)
	dtc -O dtb -I dts -o $@ -b 0 -@ $<

# PRU compilation and linking
$(J17084TRUCKDUCK_OFILE): $(J17084TRUCKDUCK_SOURCES) | $(PRU_GEN_DIR)
	$(CLPRU) $(CFLAGS) $(INC) $^ --run_linker $(LFLAGS) $(LIBS) --output_file=$@ -m$(patsubst %.out,%.map,$@)

$(PLC4TRUCKSDUCK_OFILE): $(PLC4TRUCKSDUCK_SOURCES) | $(PRU_GEN_DIR)
	$(CLPRU) $(CFLAGS) $(INC) $^ --run_linker $(LFLAGS) $(LIBS) --output_file=$@ -m$(patsubst %.out,%.map,$@)

# Directory creation
$(ARM_BUILD_DIR):
	mkdir -p $(ARM_BUILD_DIR)

$(ARM_BUILD_DIR)/%.dtbo: $(ARM_SRC_DIR)/%.dts | $(ARM_BUILD_DIR)
	dtc -O dtb -I dts -o $@ -b 0 -@ $<

$(PRU_GEN_DIR):
	mkdir -p $(PRU_GEN_DIR)

# Clean up
clean:
	rm -rf $(PRU_GEN_DIR) $(ARM_BUILD_DIR)

# Python code check
check:
	~/.local/bin/flake8 src/arm/*.py

# Installation
#install -m 755 $(ARM_SRC_DIR)/j1708send.py /usr/local/bin/ # TODO: Eventually
#install -m 755 $(ARM_SRC_DIR)/j1708dump.py /usr/local/bin/ # TODO: Eventually
install: $(DTB_OFILES)
	install -d /etc/systemd/system
	install -m 600 $(THIS_DTB_OFILE) /boot/p1/extlinux/
	install -m 700 $(ARM_SRC_DIR)/j17084truckduck_host.py /usr/bin/
	install -m 600 $(PRU_GEN_DIR)/j17084truckduck.out /lib/firmware/am335x-pru1-fw
	install -m 644 $(ARM_SRC_DIR)/j17084truckduck.service /etc/systemd/system/
	install -m 700 $(ARM_SRC_DIR)/plc4trucksduck_host.py /usr/bin/
	install -m 600 $(PRU_GEN_DIR)/plc4trucksduck.out /lib/firmware/am335x-pru0-fw
	install -m 644 $(ARM_SRC_DIR)/plc4trucksduck.service /etc/systemd/system/
	install -m 644 $(ARM_SRC_DIR)/pru4trucksduck.service /etc/systemd/system/
	chmod +x /usr/bin/plc4trucksduck_host.py
	chmod +x /usr/bin/j17084truckduck_host.py
	@echo NOTE /// You must reboot before you can load $(THIS_DTB_OFILE) ///

.PHONY: all clean check install

plc:
	sudo /usr/bin/plc4trucksduck_host.py

j1708:
	sudo /usr/bin/j17084truckduck_host.py
