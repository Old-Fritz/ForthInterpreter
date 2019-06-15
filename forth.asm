%include "macros.asm"

global _start

%define pc r15
%define w r14
%define rstack r13
%define WORD_BUF_SIZE 1024
%define FORTH_COMPILE 0
%define FORTH_INTERPRET 1

%include "asmwords.asm"
%include "interpreter.asm"

section .bss
resq 1023
rstack_start: resq 1
user_mem: resq 65536 
word_buf_start: resq WORD_BUF_SIZE

section .data
dp: dq user_mem 
here: dq user_mem
state: dq FORTH_INTERPRET
word_buf: dq word_buf_start
stack_start: dq 0
last_word: dq _lw

section .text

_start:
	mov rstack, rstack_start
	mov [stack_start], rsp
	mov pc, program
	jmp next

next:
	mov w, [pc]
	add pc, 8
	jmp [w]
	

program:
	dq xt_interpret, xt_bye
	
colon 'sq', sq
	dq xt_dup, xt_mul, xt_exit