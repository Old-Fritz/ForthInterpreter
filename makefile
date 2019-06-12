AFLAGS=-felf64
ASM=nasm

all: forth

forth: interpreter.o
	ld -o forth interpreter.o

interpreter.o: interpreter.asm lib.asm asmwords.asm
	$(ASM) $(AFLAGS) interpreter.asm

dict.o: dict.asm 
	$(ASM) $(AFLAGS) dict.asm

clean:
	rm -f *.o