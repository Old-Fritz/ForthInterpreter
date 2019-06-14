AFLAGS=-felf64
ASM=nasm

all: forth

forth: interpreter.o lib.o
	ld -o forth interpreter.o lib.o

interpreter.o: interpreter.asm asmwords.asm
	$(ASM) $(AFLAGS) interpreter.asm
	
lib.o: lib.inc
	$(ASM) $(AFLAGS) lib.inc

clean:
	rm -f *.o