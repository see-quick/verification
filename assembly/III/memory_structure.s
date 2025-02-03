// +---------------------------------+  // High addresses
// |  Uninitialized storage          |  // .bss section variables
// |  (.bss section)                 |
// |                                 |
// |  Example:                       |
// |      .section .bss              |
// |      .lcomm uninit_var, 4       |  // 4-byte uninitialized variable
// +---------------------------------+
// |  Static variables               |  // .data section
// |  (.data section)                |
// |                                 |
// |  Example:                       |
// |      .section .data             |
// |  num:  .word  42                |  // Static integer variable
// +---------------------------------+
// |  Read-only data                 |  // .rodata section
// |  (.rodata section)              |
// |                                 |
// |  Example:                       |
// |      .section .rodata           |
// |  pi:     .single  3.1415927      |  // Float (rounded)
// |  e:      .single  2.7182818      |  // Float (rounded)
// |  MaxU16: .hword  65535           |  // Max unsigned 16-bit integer
// |  MaxI16: .hword  32767           |  // Max signed 16-bit integer
// |                                 |
// |  IMPORTANT: .rodata values       |
// |  are memory-based, not           |
// |  immediates!                     |
// |                                 |
// |  Invalid (direct usage in        |
// |  instruction):                   |
// |  add r1, r2, pi  // Invalid      |
// |                                 |
// |  Valid (load address first):     |
// |      ldr r0, =pi                 |  // Load address of pi
// |      ldr s0, [r0]                |  // Read value into FP register
// +---------------------------------+
// |  Code / Program Instructions    |  // .text section
// |  (.text section)                |
// |                                 |
// |  Example:                       |
// |      .section .text             |
// |      .global _start             |
// |  _start:                        |
// |      mov r0, #1                 |  // Example instruction
// |      mov r7, #1                 |
// |      svc #0                     |  // Exit syscall
// +---------------------------------+
// |  Heap                           |  // (Grows upward)
// |                                 |
// +---------------------------------+
// |  Stack                          |  // (Grows downward)
// |                                 |
// +---------------------------------+
// |  Reserved by OS                 |  // (Typically 128KB)
// +---------------------------------+
// |  NULL / Lowest Memory           |  // 0x0
// +---------------------------------+
