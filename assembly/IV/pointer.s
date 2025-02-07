#include "../aoaa.inc"

.global _main


.data
  ptr: .dword 3

.text
_main:
  lea x0, ptr   // load x0 with the value of the `ptr`
  ldr x0, [x0]  
  ldr x1, [x0]  // fetch the data at which p points
  ret
