// Listing 5-4
//
// Preserving registers (successful) example

#include "../aoaa.inc"

stackSpace  =           64
saveLR      =           56
saveX19     =           48

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 5-4"
space:      .asciz      " "
asterisk:   .asciz      "*, %ld\n"

            .data
loopIndex:  .word       .-.     // Used to print loop index value.

            .code
            .extern     printf

// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle



// print40Spaces-
//
//  Prints out a sequence of 40 spaces
// to the console display.

            proc    print40Spaces
            sub     sp, sp, #stackSpace
            str     lr, [sp, #saveLR]
            str     x19, [sp, #saveX19]

            mov     w19, #40
printLoop:  lea     x0, space
            bl      printf
            subs    w19, w19, #1
            bne     printLoop //Until w19==0
            ldr     lr, [sp, #saveLR]
            ldr     x19, [sp, #saveX19]
            add     sp, sp, #stackSpace
            ret
            endp    print40Spaces


// Here is the "asmMain" function.

            proc    asmMain, public

            sub     sp, sp, #stackSpace
            str     lr, [sp, #saveLR]   // Save return address
            str     x19, [sp, #saveX19] // Must preserve non-volatile register

            mov     x19, #20
astLp:      bl      print40Spaces
            lea     x0, loopIndex
            str     x19, [x0]
            lea     x0, asterisk
            vparm2  loopIndex
            bl      printf
            subs    x19, x19, #1
            bne     astLp

            ldr     lr, [sp, #saveLR]
            ldr     x19, [sp, #saveX19]
            add     sp, sp, #stackSpace
            ret     //Returns to caller
            endp    asmMain
