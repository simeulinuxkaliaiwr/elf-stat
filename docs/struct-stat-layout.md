# Layout of the struct stat

The `struct stat` is not uniform across architectures. On x86_64, it has fields aligned to 8 bytes.

## Mapped Fields
    - **st_mode**: Contains the file type (bits 12-15) and permissions (bits 0-8).

    - **st_size**: Size in bytes (64-bit integer).

    - **st_uid/st_gid**: Owner and group identifiers (32-bit).

The utility `tools/gen_offsets.c` extracts the exact positions of these fields and generates the file `include/stat.inc`, ensuring that the Assembly accesses the correct byte regardless of the Kernel version.

