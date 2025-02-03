#include "aoaa.inc"

.global _main

.data:

  int1:       .dword 4294967294
  int2:       .dword 5


_main:
    lea x0, int1
    ldr x0, [x0]
    
    lea x1, int2  
    ldr x1, [x1]
    
    adds x1, x0, x1

    bcs _overflowOcc
  
_overflowOcc:
    mov x0, #10
    ret




