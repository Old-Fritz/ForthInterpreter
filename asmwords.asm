%include "macros.asm"
%include "lib.asm"

; stack
native 'drop', drop, 0
	pop rax
	jmp next
	
native 'swap', swap, 0
	pop rax
	pop rdx
	push rax
	push rdx
	jmp next
native 'dup', dup, 0
	push qword [rsp]
	jmp next
	
; arifmetic
native '+', add, 0
	pop rax
	add [rsp], rax
	jmp next
native '*', mul, 0
	pop rax
	pop rdx
	imul rdx
	push rax
	jmp next
native '/', div, 0
	pop rcx
	pop rax
	cqo
	idiv rcx
	push rax
	jmp next
native '%', mod, 0
	pop rcx
	pop rax
	cqo
	idiv rcx
	push rdx
	jmp next
native '-', sub, 0
	pop rax
	sub [rsp], rax
	jmp next
native '=', equal, 0
	pop rax
	pop rdx
	cmp rax, rdx
	je .eq
	push 0
	jmp next
	.eq:
	push 1
	jmp next
native '<', less, 0
	pop rax
	pop rdx
	cmp rdx, rax
	jl .less
	push 0
	jmp next
	.less:
	push 1
	jmp next
	
; logic
native 'not', not, 0
native 'and', and, 0
native 'or', or, 0
native 'land', land, 0
native 'lor', lor, 0

; r stack
native '>r', rpush, 0
native 'r>', rpop, 0
native 'r@', rfetch, 0

; memory
native '@', fetch, 0
native '!', write, 0
native 'c!', c_write, 0
native 'c@', char_fetch, 0
native 'execute', execute, 0
native 'forth-dp', forth_dp, 0

; running control
native 'docol', docol, 0
native 'branch', branch, 0
native '0branch', 0branch, 0
native 'exit', exit, 0

; utils
native 'lit', lit, 0
native 'forth-sp', forth_sp, 0
native 'forth-stack-base', forth_stack_base, 0
native 'syscall', syscall, 0
native 'bye', bye, 0
	mov rax, 60
	xor rdi, rdi
	syscall
native '.', dot, 0
	pop rdi
	call print_int
	call print_newline
	jmp next

