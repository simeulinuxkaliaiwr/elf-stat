bits 64

section .text
	global sys_stat
	global sys_write
	global sys_exit
sys_stat:
	mov rax, 4
	syscall
	ret
sys_write:
	mov rax, 1
	syscall
	ret
sys_exit:
	mov rax, 60
	syscall
