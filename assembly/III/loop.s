#include "../aoaa.inc"

  .global _main

.align 2
.data
  var: .dword 10


.text
_main:
  lea x0, var
  ldr x0, [x0]
  cmp x0, #10
  b.eq _loop
  ret

_loop:
  sub x0, x0, #1
  cmp x0, #0
  b.ne _loop
  ret
  
