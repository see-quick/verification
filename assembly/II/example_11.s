#include "aoaa.inc"

.data

  titleStr:     .asciz    "My godness this is kinda very cool!!"
  saveLR:       .dword    0

getTitle:
    lea x0, titleStr
    ret


.text
.align 2
.extern   printf // printf is outside of this code :))


.global _asmMain

_asmMain:
  sp, sp, #64

  lea x0, saveLR
  str lr, [x0]

  // ....

  lea x0, titleStr
  bl printf

  // restore LR so we can return C++ pogram
  lea x0, saveLR
  ldr lr, [x0]
  add sp, sp, #64
  ret
