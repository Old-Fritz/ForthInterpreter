
extern read_word
extern parse_int
extern find_word
extern string_copy
extern string_length

; params
native 'state', state
	push state
	jmp next
native 'here', here
	push here
	jmp next
native 'stack', stack
	push rsp
	jmp next
native 'word_buf', word_buf
	push qword[word_buf]
	jmp next
native 'word_buf_size', word_buf_size
	push WORD_BUF_SIZE
	jmp next

native 'parse_int', parse_int ; ( str -- value len)
	pop rdi
	call parse_int
	push rax
	push rdx
	jmp next
native 'read_word', read_word
	pop rdx
	pop rsi
	pop rdi
	call read_word
	push rax
	jmp next
	
native 'find', find
	mov rsi, last_word
	pop rdi
	call find_word
	push rax
	jmp next
	
native 'cfa', cfa
	pop rax
	add rax, 8
	.loop:
	inc rax
	mov cl, byte[rax]
	test cl, cl
	jnz .loop
	add rax, 2
	push rax
	jmp next
	
native 'create', create
	mov rax, [last_word]
	mov rcx, [here]
	mov [last_word], rcx
	mov [rcx], rax
	add rcx, 8 ; last_word address
	mov byte[rcx], 0 ; 0 between address and word
	inc rcx
	mov [here], rcx ; upfdate here value
	mov rsi, rcx ; prepare for copy str
	pop rdi
	mov rdx, WORD_BUF_SIZE
	call string_copy
	mov rdi, [here] ; calc len
	call string_length
	mov rcx, [here] 
	add rcx, rax 
	mov byte [rcx], 0 ; 0 between word and flag
	inc rcx
	pop rax  ; flag
	mov byte[rcx], al
	inc rcx
	mov [here], rcx ; update here
	jmp next


colon ':', colon
	.read:
	dq xt_fd, xt_word_buf, xt_word_buf_size, xt_read_word
	dq xt_branch0, .read
	dq xt_lit, 0,  xt_word_buf, xt_create
	dq xt_lit, FORTH_COMPILE, xt_state, xt_write
	dq xt_lit, i_docol, xt_comma
	dq xt_exit

colon ';', semicolon
	dq xt_lit, FORTH_INTERPRET, xt_state, xt_write
	dq xt_lit, xt_exit, xt_comma
	dq xt_exit
	
colon 'interpret', interpret
	.read:  ; read next word
	dq xt_fd, xt_word_buf, xt_word_buf_size, xt_read_word
	dq xt_branch0, .read
	dq xt_word_buf, xt_find, xt_dup, xt_not, xt_branch0, .cfa ; find in dictionary and process command
	dq xt_drop, xt_word_buf, xt_parse_int, xt_branch0, .not_found ; else try parse
	dq xt_state, xt_fetch, xt_branch0, .compile_stack
	dq xt_exit
	.compile_stack:
	; check if previus is branch
	dq xt_here, xt_lit, 8, xt_sub, xt_fetch
	dq xt_dup, xt_lit, xt_branch, xt_equal, xt_not, xt_branch0, .is_branch  	; branch
	dq xt_dup, xt_lit, xt_branch0, xt_equal, xt_not, xt_branch0, .is_branch  	; branch0
	dq xt_drop
	dq xt_lit, xt_lit, xt_comma, xt_comma, xt_exit ; add xt_lit and number to command
	.is_branch:
	dq xt_drop, xt_comma, xt_exit
	.cfa:
	dq xt_cfa
	dq xt_state, xt_fetch, xt_branch0, .compile_command
	dq xt_execute, xt_exit
	.compile_command:
		dq xt_dup, xt_lit, xt_semicolon, xt_equal, xt_not
		dq xt_branch0, .compile_end
		dq xt_comma, xt_exit
	.compile_end:
		dq xt_semicolon, xt_drop, xt_exit
	.not_found:
		dq xt_drop, xt_exit