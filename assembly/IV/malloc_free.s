// Demonstration of calls
// to C standard library malloc
// and free functions.

#include "../aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "malloc() and free() functions demonstration"
fmtStr:     .asciz     "Addresses returned by malloc: %p, %p\n"
        
            .data
ptrVar:     .dword      .-.
ptrVar2:    .dword      .-.
        
            .text
            .align      2
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
            sub         sp, sp, #64     // Space on stack
            str         lr, [sp, #56]   // Save return address

// C standard library malloc function
//
// ptr = malloc( byteCnt );
//
// Note: malloc has only a single parameter, it
// is passed in X0 as per ARM/macOS ABI.

            mov         x0, #256        // Allocate 256 bytes
            bl          malloc
            lea         x1, ptrVar      // Store pointer ito
            str         x0, [x1]        // ptrVar variable

            mov         x0, #1024       // Allocate 1,024 bytes
            bl          malloc
            lea         x1, ptrVar2     // Store pointer into
            str         x0, [x1]        // ptrVar2 variable
            
// Print the addresses of the two malloc'd blocks:
    
            lea         x0, fmtStr
            vparm2      ptrVar
            vparm3      ptrVar2
            bl          printf


// Free the storage by calling
// C standard library free function.
//
// free( ptrToFree );
//
// Once again, the single parameter gets passed in X0.

            lea         x0, ptrVar
            ldr         x0, [x0]
            bl          free

            lea         x0, ptrVar2
            ldr         x0, [x0]
            bl          free

            ldr         lr, [sp, #56]   // Get return address
            add         sp, sp, #64     // Clean up stack
            ret
        
