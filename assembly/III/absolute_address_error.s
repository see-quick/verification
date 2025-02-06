.global _main


.data 
var: .word 55

_main:
  ldr x0, =var
  ret
