%include "include/stat.inc"

extern sys_stat
extern sys_write
extern sys_exit
extern format_permissions
extern print_uint
extern strlen

section .data
	msg_usage db "Use: ./elf-stat <pathname>", 10, 0
	len_usage equ $ - msg_usage
	
	msg_err db "Error reading file.", 10, 0
	len_err equ $ - msg_err

	lbl_mode db "Mode:    ", 0
	lbl_size db 10, "Size:    ", 0
	lbl_uid db 10, "UID:     ", 0
	newline db 10
section .bss
	stat_buf resb STAT_SIZE
	perm_str resb 12
section .text
	global _start
_start:
	mov rdi, [rsp]
	cmp rdi, 2
	jne .show_usage

	mov rdi, [rsp + 16]
	mov rsi, stat_buf
	call sys_stat

	test rax, rax
	js .show_error

	mov rsi, lbl_mode
	mov rdx, 9
	call print_label

	movzx rdi, word [stat_buf + ST_MODE_OFF]
	mov rsi, perm_str
	call format_permissions

	mov rsi, perm_str
	mov rdx, 10
	call print_label

	mov rsi, lbl_size
	mov rdx, 10
	call print_label

	mov rax, [stat_buf + ST_SIZE_OFF]
	call print_uint

	mov rsi, lbl_uid
	mov rdx, 10
	call print_label

	mov eax, [stat_buf + ST_UID_OFF]
	call print_uint

	mov rsi, newline
	mov rdx, 1
	call print_label

	xor rdi, rdi
	call sys_exit
.show_usage:
	mov rsi, msg_usage
	mov rdx, len_usage
	call print_label
	mov rdi, 1
	call sys_exit
.show_error:
	mov rsi, msg_err
	mov rdx, len_err
	call print_label
	mov rdi, 1
	call sys_exit
print_label:
	mov rdi, 1
	call sys_write
	ret
