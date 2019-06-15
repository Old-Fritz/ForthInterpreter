AFLAGS=-felf64
ASM=nasm

all: forth

forth: forth.o lib.o
	ld -o forth forth.o lib.o

forth.o: forth.asm asmwords.asm interpreter.asm macros.asm
	$(ASM) $(AFLAGS) forth.asm
	
lib.o: lib.inc
	$(ASM) $(AFLAGS) lib.inc

clean:
	rm -f *.o