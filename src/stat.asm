bits 64

%include "include/stat.inc"

section .text
	global format_permissions
format_permissions:
	push rbx
	mov ebx, edi

	mov byte [rsi], '-'
	mov eax, ebx
	and eax, 0170000o

	cmp eax, 0040000o
	jne .f1
	mov byte [rsi], 'd'
.f1: cmp rax, 0120000o
	jne .f2
	mov byte [rsi], 'l'
.f2: 
    ; User
    test ebx, 00400o
    setnz al
    mov byte [rsi+1], 'r'
    jnz .u2
    mov byte [rsi+1], '-'
.u2: test ebx, 00200o
    setnz al
    mov byte [rsi+2], 'w'
    jnz .u3
    mov byte [rsi+2], '-'
.u3: test ebx, 00100o
    setnz al
    mov byte [rsi+3], 'x'
    jnz .g1
    mov byte [rsi+3], '-'

    ; Group
.g1: test ebx, 00040o
    mov byte [rsi+4], 'r'
    jnz .g2
    mov byte [rsi+4], '-'
.g2: test ebx, 00020o
    mov byte [rsi+5], 'w'
    jnz .g3
    mov byte [rsi+5], '-'
.g3: test ebx, 00010o
    mov byte [rsi+6], 'x'
    jnz .o1
    mov byte [rsi+6], '-'

.o1: test ebx, 00004o
    mov byte [rsi+7], 'r'
    jnz .o2
    mov byte [rsi+7], '-'
.o2: test ebx, 00002o
    mov byte [rsi+8], 'w'
    jnz .o3
    mov byte [rsi+8], '-'
.o3: test ebx, 00001o
    mov byte [rsi+9], 'x'
    jnz .done
    mov byte [rsi+9], '-'

.done:
    mov byte [rsi+10], 0
    pop rbx
    ret
