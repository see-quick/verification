// Listing2-1.S
//
// Displays some numeric values on the console
#include "aoaa.inc"

            .data
// Program title, required by C++ code:

titleStr:   .asciz      "It's gonna be legend.....!!"

// Format strings for three calls to printf():

fmtStrI:    .asciz      "i=%d, converted to hex=%x\n"
fmtStrJ:    .asciz      "j=%d, converted to hex=%x\n"
fmtStrK:    .asciz      "k=%d, converted to hex=%x\n"

// Some values to print in decimal and hexadecimal form:

            .align      2  // Be nice and word-align.
i:          .dword      1
j:          .dword      123
k:          .dword      456789
saveLR:     .dword      0

            .text
            .align      2      // Code must be word-aligned.
            .extern     printf // printf is outside this code.

// Return program title to C++ program:

getTitle:

// Load address of "titleStr" into the X0 register (X0 holds
// the function return result) and return back to the caller:

            lea x0, titleStr
            ret

// Here is the asmMain function:

            .global     asmMain
asmMain:
            sub         sp, sp, #64 // Magic instruction

// Save LR so we can return to C++ program:

            lea         x0, saveLR
            str         lr, [x0]

// Call printf three times to print the three values
// i, j, and k:
//
// printf("i=%d, converted to hex=%x\n", i, i);

            lea         x0, fmtStrI
            vparm2      i           // Get parameter 2
            vparm3      i           // Get parameter 3
            bl          printf

// printf("j=%d, converted to hex=%x\n", j, j);

            lea         x0, fmtStrJ
            vparm2      j
            vparm3      j
            bl          printf

// printf("k=%d, converted to hex=%x\n", k, k);

            lea         x0, fmtStrK
            vparm2      k
            vparm3      k
            bl          printf

// Restore LR so we can return to C++ program:

            lea         x0, saveLR
            ldr         lr, [x0]

            add         sp, sp, #64  // Magic instruction
            ret                      // Returns to caller
