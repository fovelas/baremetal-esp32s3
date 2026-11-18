CROSS_COMPILE ?= xtensa-esp32s3-elf-
CC = $(CROSS_COMPILE)gcc
ESPTOOL ?= esptool

BUILD_DIR ?= build
ELF = $(BUILD_DIR)/firmware.elf
BIN = $(BUILD_DIR)/firmware.bin
MAP = $(BUILD_DIR)/firmware.map
OBJECTS = $(BUILD_DIR)/startup.o $(BUILD_DIR)/main.o

ARCH_FLAGS ?= -mabi=call0
CFLAGS ?= -std=c11 -Os -g -ffreestanding -Wall -Wextra
ASFLAGS ?=
LDFLAGS ?= -nostdlib

FLASH_MODE ?= qio
FLASH_SIZE ?= 4MB
FLASH_FREQ ?= 40m

.PHONY: all clean

all: $(BIN)

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/main.o: src/main.c | $(BUILD_DIR)
	$(CC) $(ARCH_FLAGS) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/startup.o: src/startup.S | $(BUILD_DIR)
	$(CC) $(ARCH_FLAGS) $(ASFLAGS) -c $< -o $@

$(ELF): $(OBJECTS) linker.ld
	$(CC) $(ARCH_FLAGS) $(LDFLAGS) -T linker.ld -Wl,-Map=$(MAP) $(OBJECTS) -lgcc -o $@

$(BIN): $(ELF)
	$(ESPTOOL) --chip esp32s3 elf2image --flash-mode $(FLASH_MODE) --flash-size $(FLASH_SIZE) --flash-freq $(FLASH_FREQ) $<

clean:
	$(RM) $(BUILD_DIR)/*.o $(ELF) $(BIN) $(MAP)
