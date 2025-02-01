	#include "aoaa.inc"
         
.data

title:      .asciz  "GOSH I did it!!!"
hwStr:      .asciz  "ManifiK! something string will be printed on stdout!!!!\n"
saveLR:     .dword  0       // Save LR here.
            
            .text
            
            .align  2       // Code must be 4-byte aligned
getTitle:
            lea     x0, title
            ret
            
asmMain:
            lea     x0, saveLR
            str     lr, [x0]

            lea     x0, hwStr   // hwStr must be in .text
            bl      printf      // Print the string

            lea     x0, saveLR
            ldr     lr, [x0]

            ret

