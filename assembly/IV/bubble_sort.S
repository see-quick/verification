#include "../aoaa.inc"


stackAlloc  =   64          // Space to allocate on stack
saveLR      =   56          // Save LR here (in stk alloc)
x19Save     =   saveLR - 8  // Save X19 here
x20Save     =   x19Save - 8 // Save X20 here

maxLen      =   256
true        =   1
false       =   0

            .section    .rodata, ""
ttlStr:     .asciz      "Bubble SORT!!!!"
fmtStr:     .asciz      "Sortme[%d] = %d\n"

        
            .data
        
// sortMe - A 16-element array to sort:

sortMe:
    .word 65534, 65533, 65532, 65531, 65530, 65529, 65528, 65527, 65526, 65525
    .rept 65525
        .word 65534 - (. - sortMe) / 4
    .endr
sortSize    =       (. - sortMe) / 4    //Number of elements

// Holds the array element during printing:

valToPrint: .word   .-.
i:          .word   .-.
        
            .text
            .align  2
            .extern printf
        
        

// Return program title to C++ program:

            .global getTitle
getTitle:
            lea     x0, ttlStr
            ret


// Here's the bubblesort function.
//
//       sort( dword *array, qword count )//
//
// array- Address passed in X0
// count- Element count passed in X1
//
// Locals:
//
//  W2 is "didSwap" Boolean flag
//  X3 is index for outer loop
//  W4 is index for inner loop

#define array   x0
#define count   x1
#define didSwap w2
#define index   x3

sort:
        
        sub     count, count, #1    //numElements - 1
        lsl     count, count, #2    //Make byte count
        
// Outer loop

outer:  mov     didSwap, #false

        mov     index, #0          //Outer loop index
inner:  cmp     index, count       //while Outer < count - 1
        bhs     xInner
        
        add     x5, array, index    //W5 = &array[index]        
        ldr     w6, [x5]            //W6 = array[index]
        ldr     w7, [x5, #4]        //W7 = array[index+1]
        cmp     w6, w7              //if W5 > W
        bls     dontSwap            // then swap
        
        // sortMe[index] > sortMe[index + 1], so swap elements
        
        str     w6, [x5, #4]
        str     w7, [x5]
        mov     didSwap, #true
        
dontSwap:
        add     index, index, #4        // Next word 4 BYTES (4)
        b.al    inner

// exited from inner loop, test for repeat
// of outer loop:
        
xInner: cmp     didSwap, #true
        beq     outer
        
        ret

            .global asmMain
asmMain:

            sub     sp, sp, #stackAlloc
            str     lr, [sp, #saveLR]       // Save return address
            str     x19, [sp, #x19Save]     // Save non-volatile X19
            str     x20, [sp, #x20Save]     // and X20

// Sort the "sortMe" array:

        	lea     x0, sortMe
       		mov     x1, #sortSize  //16 elements in array
       		bl      sort

// Display the sorted array.
// Note: uses non-volatile registers X19 and X20
// in loop so printf won't disturb their values.
  // TODO: there was a problem where, error compatible register, symbol or integer in range [0, 4095] cmp x20, #sortSize 
  //      so the solution here is to move to x21 register and then compare it.

        	lea     x19, sortMe
        	mov     x20, xzr                // X20=0 (index)
dispLp: 	ldr     w0, [x19, x20, lsl #2]      // W0=sortMe[X20]
        	lea     x1, valToPrint
        	str     w0, [x1]
        	lea     x1, i
        	str     x20, [x1]

        	lea     x0, fmtStr
        	vparm2  i
        	vparm3  valToPrint
        	bl      printf
        
          add     x20, x20, #1
          mov     x21, #sortSize
          cmp     x20, x21 
        	blo     dispLp

        	ldr     x19, [sp, #x19Save]     // Restore non-volatile
        	ldr     x20, [sp, #x20Save]     // registers
        	ldr     lr, [sp, #saveLR]       // Restore return address
        	add     sp, sp, #stackAlloc     // Restore stack
        	ret     //Returns to caller

