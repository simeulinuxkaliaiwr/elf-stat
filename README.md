# 📄 README.md

## **ELF-STAT: Linux x86_64 File Metadata (No-Libc)**

**ELF-STAT** is a low-level utility designed to inspect file metadata in Linux. The distinguishing feature of this project is its implementation in pure **NASM (x86_64) assembly**, without any dependency on the standard C library (`libc`). All communication with the hardware and file system is done via direct calls to the Kernel (Syscalls).

---

## 🚀 Engineering Highlights

1. **Library Independence**
Unlike conventional binaries, this project does not use dynamic linking. The result is a minimalist, static, and self-contained executable that operates directly on the Linux ABI (Application Binary Interface).

2. **Bridge C-to-ASM** (Portability)
To avoid the common error of hardcoding memory offsets (which can change between kernel versions), the project uses an auxiliary C tool (`tools/gen_offsets.c`). This tool extracts the exact layout of the `struct stat` from the host system and generates a `.inc` header file for NASM during compilation.

3. **Memory managemenent**

* **Section** `.text`: Optimized code with direct record manipulation.
* **Section** `.bss`: Static allocation of buffers to avoid costly calls to `brk` or `mmap`.
* **Stack**: Manual parsing of the system stack for `argc` and `argv` recovery.

---

## 📁 Project structure

```
elf-stat/
├── Makefile                # Build orchestrator and offset generation
├── tools/
│   └── gen_offsets.c       # Metadata extractor for the C stat struct.
├── include/
│   ├── stat.inc            # Offsets generated automatically (Auto-gen)
│   └── syscalls.inc        # Definitions of x86_64 syscall IDs
├── src/
│   ├── _start.asm          # Entry Point and Stack Logic
│   ├── syscalls.asm        # System call wrappers (stat, write, exit)
│   ├── stat.asm            # Lógica de decodificação de permissões POSIX
│   └── string_utils.asm    # Integer to ASCII (ITOA) conversion functions
├── tests/
│   └── run_tests.sh        # Automated test suite in Bash
└── docs/                   # Detailed documentation of the components

```

### 🛠️ Compilation and use

**Prerequisites**

* `nasm` compiler

* `ld` linker (binutils)

* `gcc` compiler (Just for the build tool)

* GNU `make`

**How to compile**

To build the project from scratch, run:

```bash
make
```

**How to execute**
Pass the path of any file or directory as an argument:
```bash
./build/elf-stat /etc/passwd
```

---

## 🧪 Test automation

The project includes a test suite that validates the outputs of elf-stat against the official system binary.

To run the tests:
```bash
chmod +x tests/run_tests.sh
./tests/run_tests.sh # Make sure you've run make before
```

---

## 📖 **Implementation Notes**

**Decoding Permissions**
The logic in `stat.asm` realizes bitmask operations (`AND`, `TEST`) In the `st_mode` field, convert octal values into a readable string like `drwxr-xr-x`.

| Bitmask | Character | Meaning
| :----: | :----: | :----: |
| `0040000o` | `d` | Directory |
| `00400o` | `a` | Reading (Owner) |
| `00200o` | `w` | Writing (Owner) |
| `00100o` | `x` | Execution (Owner) |

**Number Conversion**

Since we don't have `printf`, the file size (which can reach 64 bits) is converted to ASCII using successive divisions by 10 and reverse buffering, ensuring that the binary remains lightweight and fast.

---

## 📜 **License**
Distributed under `MIT` license. Read `LICENSE` for details.
