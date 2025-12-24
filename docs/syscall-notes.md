# Notes about Syscalls (Linux x86_64)

In the project ['elf-stat'](https://www.github.com/simeulinuxkaliaiwr/elf-stat/), as chamadas de sistema são feitas diretamente via instrução `syscall`.

## Syscalls used
1. **sys_write (ID: 1)**:
    - RDI: File Descriptor (0 for stdin, 1 for stdout, 2 for stderr)
    - RSI: Pointer for the memory buffer
    - RDX: Number of bytes to write
    - Return: Number of bytes writed in RAX.

2. **sys_stat (ID: 4)**:
    - RDI: Pointer to path string (null-terminated)
    - RSI: Pointer to the `stat` structure in `.bss`

    - Note: We use syscall #4 which populates the standard kernel `struct stat` structure.

3. **sys_exit (ID: 60)**:
    - RDI: Exit code (0 for success).
