%include "asmwords.asm"

global _start

%define pc r15
%define w r14
%define rstack r13

section .bss
resq 1023
rstack_start: resq 1

section .text

_start:
	mov rstack, rstack_start
	mov pc, program
	push 7
	push 8
	jmp next

next:
	mov w, [pc]
	add pc, 8
	jmp [w]
	
program:
	dq xt_less, xt_dot, xt_bye