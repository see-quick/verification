#include "../aoaa.inc"

maxLen       =     256

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 4-4"
prompt:     .asciz      "Input a string: "
fmtStr:     .asciz      "%d: Hex value of char read: %x\n"
        
            .data
valToPrint: .word       .-.
bufIndex:   .dword      .-.
bufPtr:     .dword      .-.
bytesRead:  .dword      .-.
        
            .text
            .align      2
            .extern     readLine
            .extern     printf
            .extern     malloc
            .extern     free


// Return program title to C++ program:

            .global     getTitle
getTitle:
            lea         x0, ttlStr
            ret

// Here is the "asmMain" function.
        
            .global     asmMain
asmMain:

            sub     sp, sp, #64     // Reserve stack space
            str     lr, [sp, #56]   // Save return address

// C standard library malloc function
// Allocate sufficient characters
// to hold a line of text input
// by the user:

            mov     x0, #maxLen     // Allocate 256 bytes
            bl      malloc
            lea     x1, bufPtr      // Save pointer to buffer
            str     x0, [x1]
        
// Read a line of text from the user and place in
// the newly allocated buffer:

        lea     x0, prompt      // Prompt user to input
        bl      printf          //  a line of text.

        lea     x0, bufPtr
        ldr     x0, [x0]        // Pointer to input buffer
        mov     x1, #maxLen     // Maximum input buffer length
        bl      readLine        // Read text from user
        cmp     x0, #-1         // Skip output if error
        beq     allDone
        lea     x1, bytesRead
        str     x0, [x1]        //Save number of chars read
        
// Display the data input by the user:

        mov     x1, #0          //Set index to zero
        lea     x0, bufIndex
        str     x1, [x0]
dispLp: lea     x0, bufIndex    //Get buffer index
        ldr     x1, [x0]        // into X1.
        lea     x2, bufPtr      //Get pointer to buffer
        ldr     x2, [x2]
        ldr     w0, [x2, x1]    //Read word rather than byte!
        lea     x1, valToPrint
        str     w0, [x1]
        lea     x0, fmtStr
        vparm2  bufIndex
        vparm3  valToPrint
        bl      printf
        
        lea     x0, bufIndex    // Increment index by 1
        ldr     x1, [x0]
        add     x1, x1, #1
        str     x1, [x0]

        lea     x0, bytesRead   //Repeat until
        ldr     x0, [x0]        // we've processed "bytesRead"
        cmp     x1, x0          // bytes.
        blo     dispLp

// Free the storage by calling
// C standard library free function.
//
// free( bufPtr )//

allDone:
        lea     x0, bufPtr
        ldr     x0, [x0]
        bl      free

        ldr     lr, [sp, #56]   // Restore return address
        add     sp, sp, #64
        ret     //Returns to caller
