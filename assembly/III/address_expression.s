
// Listing 3-1
//
// Demonstrate address expressions

#include "../aoaa.inc"

            .data
saveLR:     .dword      0
outputVal:  .word       0

ttlStr:     .asciz      "Listing 3-1"
fmtStr1:    .asciz      "i[0]=%d "
fmtStr2:    .asciz      "i[1]=%d "
fmtStr3:    .asciz      "i[2]=%d "           
fmtStr4:    .asciz      "i[3]=%d\n"


            .text
            .extern     printf

            .align      2
i:          .word       0, 1, 2, 3

// Return program title to C++ program:

            .global     getTitle
getTitle:
            lea         x0, ttlStr
            ret
   
// Here is the "asmMain" function.

            .global     asmMain
asmMain:

// "Magic" instruction offered without
// explanation at this point:

            sub     sp, sp, #256
            
// Save LR so we can return to the C++
// program later:

            lea     x0, saveLR
            str     lr, [x0]

// Demonstrate the use of address expressions.

            lea     x0, fmtStr1
            ldr     w1, i + 0
            lea     x2, outputVal
            str     w1, [x2]
            vparm2  outputVal
            bl      printf
                
            lea     x0, fmtStr2
            ldr     w1, i + 4
            lea     x2, outputVal
            str     w1, [x2]
            vparm2  outputVal
            bl      printf
                
            lea     x0, fmtStr3
            ldr     w1, i + 8
            lea     x2, outputVal
            str     w1, [x2]
            vparm2  outputVal
            bl      printf
                
            lea     x0, fmtStr4
            ldr     w1, i + 12
            lea     x2, outputVal
            str     w1, [x2]
            vparm2  outputVal
            bl      printf
                
            lea     x0, saveLR
            ldr     lr, [x0]
            add     sp, sp, #256
            ret
