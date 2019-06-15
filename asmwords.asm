
extern print_newline
extern print_int

; stack
native 'drop', drop
	pop rax
	jmp next
	
native 'swap', swap
	pop rax
	pop rdx
	push rax
	push rdx
	jmp next
native 'dup', dup
	push qword [rsp]
	jmp next
	
; arifmetic
native '+', add
	pop rax
	add [rsp], rax
	jmp next
native '*', mul
	pop rax
	pop rdx
	imul rdx
	push rax
	jmp next
native '/', div
	pop rcx
	pop rax
	cqo
	idiv rcx
	push rax
	jmp next
native '%', mod
	pop rcx
	pop rax
	cqo
	idiv rcx
	push rdx
	jmp next
native '-', sub
	pop rax
	sub [rsp], rax
	jmp next
native '=', equal
	pop rax
	pop rdx
	cmp rax, rdx
	je .eq
	push 0
	jmp next
	.eq:
	push 1
	jmp next
native '<', less
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
native 'not', not
	pop rax
	cmp rax, 0
	je .zero
	push 0
	jmp next
	.zero:
	push 1
	jmp next
native 'and', and
	pop rax
	and [rsp], rax
	jmp next
native 'or', or
	pop rax
	or [rsp], rax
	jmp next
native 'land', land
	pop rax
	and [rsp], rax
	jz .not
	push 1
	jmp next
	.not:
	push 0
	jmp next
native 'lor', lor
	pop rax
	or [rsp], rax
	jz .not
	push 1
	jmp next
	.not:
	push 0
	jmp next
	
; r stack
native '>r', rpush
	sub rstack, 8
	pop qword[rstack]
	jmp next
native 'r>', rpop
	push qword[rstack]
	add rstack, 8
	jmp next
native 'r@', rfetch
	push qword[rstack]
	jmp next

; memory
native '@', fetch
	pop rax
	push qword [rax]
	jmp next
native '!', write
	pop rax
	pop rdx
	mov qword [rax], rdx
	jmp next
native 'c!', char_write
	pop rax
	pop rdx
	mov [rax], dl
	jmp next
native 'c@', char_fetch
	pop rax
	xor rdx, rdx
	mov dl, byte [rax]
	push rdx
	jmp next
native ',', comma
	mov rax, [here]
    pop qword [rax]
    add qword [here], 8
    jmp next
native 'c,', char_comma
	pop rax
	mov [here], al
    add qword [here], 8
    jmp next
native 'forth_dp', forth_dp
	push qword dp
	jmp next

; running control
native 'docol', docol
	sub rstack, 8
	mov [rstack], pc
	add w, 8
	mov pc, w
	jmp next
native 'branch', branch
	mov pc, [pc]
	jmp next
native '0branch', branch0
	pop rax
	test rax, rax
	jz .goto
	add pc, 8
	jmp next
	.goto:
	mov pc, [pc]
	jmp next
native 'exit', exit, 0
	mov pc, [rstack]
	add rstack, 8
	jmp next

; utils
native 'lit', lit
	push qword [pc]
	add pc, 8
	jmp next
native '.S', show_stack
    mov rcx, rsp
    .loop:
        cmp rcx, [stack_start] 
        jae next
        mov rdi, [rcx]
        push rcx
        call print_int
        call print_newline
        pop rcx
        add rcx, 8
        jmp .loop
native 'syscall', syscall
	pop r9
    pop r8
    pop r10
    pop rdx
    pop rsi
    pop rdi
    pop rax
    syscall
    push rax
    push rdx
    jmp next
native 'bye', bye
	mov rax, 60
	xor rdi, rdi
	syscall
native '.', dot
	pop rdi
	call print_int
	call print_newline
	jmp next
native 'execute', execute
	pop rax
    mov w, rax
    jmp [rax]

native 'forth_input_fd', fd
    push qword 0
    jmp next