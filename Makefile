LINKSCRIPT	= link.ld
XPLAT		= arm-none-eabi
AS		= $(XPLAT)-as
LD		= $(XPLAT)-ld

SRC		= src
BUILD           = build

KSRCS		= $(wildcard $(SRC)/kernel/*.s)
KOBJECTS	= $(patsubst $(SRC)/%.s,$(BUILD)/%.o,$(KSRCS))

all: $(BUILD)/kernel.img

$(BUILD)/kernel.img: $(KOBJECTS) $(LINKSCRIPT)
	$(LD) -T $(LINKSCRIPT) -o $@ $(KOBJECTS)

$(BUILD)/%.o: $(SRC)/%.s
	$(AS) -o $@ $<
