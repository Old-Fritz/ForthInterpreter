%include "macros.asm"
%include "lib.asm"

native '+', plus, 0
	pop rax
	add [rsp], rax
	jmp next
	
native '.', dot, 0
	pop rdi
	call print_int
	jmp next

native 'bye', bye, 0
	mov rax, 60
	xor rdi, rdi
	syscall