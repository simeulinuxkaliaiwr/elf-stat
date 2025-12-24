bits 64

section .bss
	buffer resb 32
section .text
	global print_uint
	global strlen
	extern sys_write
; print_uint(rax = num)
print_uint:
	mov rcx, buffer + 31
	mov byte [rcx], 0
	mov r8, 10
.loop:
	xor rdx, rdx
	div r8
	add dl, '0'
	dec rcx
	mov [rcx], dl
	test rax, rax
	jnz .loop

	mov rsi, rcx
	mov rdx, buffer + 31
	sub rdx, rcx
	mov rdi, 1
	mov rax, 1
	syscall
	ret
strlen:
	xor rax, rax
.lp:
	cmp byte [rdi + rax], 0
	je .out
	inc rax
	jmp .lp
.out:
	ret
