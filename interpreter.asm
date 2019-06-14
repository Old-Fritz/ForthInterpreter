

global _start

%define pc r15
%define w r14
%define rstack r13

section .bss
resq 1023
rstack_start: resq 1
user_mem: resq 65536 

section .data
dp: dq user_mem 
stack_start: dq 0


%include "asmwords.asm"

section .text

_start:
	mov rstack, rstack_start
	mov [stack_start], rsp
	mov pc, program
	push 7
	push 9
	jmp next

next:
	mov w, [pc]
	add pc, 8
	jmp [w]
	
program:
	dq xt_show_stack,  xt_bye