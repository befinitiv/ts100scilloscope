CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
CP = arm-none-eabi-objcopy
AS = arm-none-eabi-as

LKR_SCRIPT = LinkerScript.ld

CFLAGS  = -std=c11 -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER -mcpu=cortex-m3 -mthumb -Iinc -IStdPeriph_Driver/inc -ICMSIS/device/ -ICMSIS/core
CFLAGS		+= -Os -g3
#CFLAGS		+= -fno-common -ffunction-sections -fdata-sections

LFLAGS  = -static -T$(LKR_SCRIPT) -lc -lnosys
CPFLAGS = -Obinary


SOURCES = $(shell find . -name '*.c')
OBJ = $(SOURCES:.c=.o) startup/startup_stm32.o

all: ts100.bin

%.o: %.c %.s
	$(CC) $(CFLAGS) -c $< -o $@

ts100.elf: $(OBJ)
	$(LD) $(LFLAGS) -o ts100.elf $(OBJ)

ts100.bin: ts100.elf
	$(CP) $(CPFLAGS) ts100.elf ts100.bin

clean:
	find . -name "*.o" -delete
	rm -rf *.elf *.bin
