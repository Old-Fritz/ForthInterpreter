AFLAGS=-felf64
ASM=nasm

all: forth

forth: interpreter.o lib.o
	ld -o forth interpreter.o lib.o

interpreter.o: interpreter.asm lib.asm asmwords.asm
	$(ASM) $(AFLAGS) interpreter.asm


lib.o: lib.asm 
	$(ASM) $(AFLAGS) lib.asm

dict.o: dict.asm 
	$(ASM) $(AFLAGS) dict.asm

clean:
	rm -f main.o lib.o dict.o main