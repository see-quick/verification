# Assembly on macOS M3 (aarch64)

## Building
To assemble and link the `Start.s` file into a Mach-O 64-bit executable for arm64:

```sh
clang -arch arm64 -o Start Start.s
```

This produces an executable:

```sh
file Start
Start: Mach-O 64-bit executable arm64
```

## Debugging with LLDB
Since `gdb` is not available on macOS, use `lldb` for debugging:

```sh
lldb ./Start
```

Example session:

```
(lldb) target create "./Start"
(lldb) run
Process 81079 exited with status = 10 (0x0000000a) 
```

## Source Code

`Start.s`:

```assembly
.global _main
.align 2

_main:
    mov X0, #10    // return 10
    mov X16, #1    // terminate
    
    svc #0x80      // syscall

// end of the file

