LINKSCRIPT	= link.ld
XPLAT		= arm-none-eabi
AS		= $(XPLAT)-as
LD		= $(XPLAT)-ld
OBJCOPY		= $(XPLAT)-objcopy
OBJDUMP		= $(XPLAT)-objdump

SRC		= src
BUILD           = build

KSRCS		= $(wildcard $(SRC)/kernel/*.s)
KOBJECTS	= $(patsubst $(SRC)/%.s,$(BUILD)/%.o,$(KSRCS))

DEST		= /Volumes/boot

.PHONY: all
all: $(BUILD)/kernel.img $(BUILD)/kernel.list

$(BUILD)/kernel.list: $(BUILD)/kernel.elf
	$(OBJDUMP) -D $< > $@

$(BUILD)/kernel.img: $(BUILD)/kernel.elf
	$(OBJCOPY) $< -O binary $@

$(BUILD)/kernel.elf: $(KOBJECTS) $(LINKSCRIPT)
	$(LD) --no-undefined -Map $(BUILD)/kernel.map -T $(LINKSCRIPT) -o $@ $(KOBJECTS)

$(BUILD)/%.o: $(SRC)/%.s
	$(AS) -o $@ $<

.PHONY: clean
clean:
	rm -rf $(BUILD)/*
	mkdir -p $(BUILD)/kernel

.PHONY: upload
upload: $(BUILD)/kernel.img
	cp -f $(BUILD)/kernel.img $(DEST)/kernel.img
