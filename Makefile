# Variables
AS = nasm
ASFLAGS = -f elf64 -I include/
LD = ld
LDFLAGS = -static
BIN = build/elf-stat
OFFSET_GEN = build/offsets_gen
INC = include/stat.inc

OBJS = build/_start.o build/syscalls.o build/stat.o build/string_utils.o

all: prep $(INC) $(BIN)

prep:
	@mkdir -p build include

$(INC): tools/gen_offsets.c
	gcc tools/gen_offsets.c -o $(OFFSET_GEN)
	./$(OFFSET_GEN) > $(INC)

build/%.o: src/%.asm
	$(AS) $(ASFLAGS) $< -o $@

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(BIN)
	@echo "Success! Run: ./$(BIN) <file>"
clean:
	rm --force --recursive build/ include/stat.inc
