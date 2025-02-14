// Passing a large object by reference

#include "../aoaa.inc"

NumElements =       24

			struct	Pt
			byte	pt.x
			byte	pt.y
			ends	Pt

        
            .data

ttlStr:     .asciz 	"Listing 5-12"
fmtStr1:    .asciz	"RefArrayParm[%d].x=%d "
fmtStr2:    .asciz	"RefArrayParm[%d].y=%d\n"
        
            .code
            .extern	printf
            
// Return program title to C++ program:

    		proc	getTitle, public
            lea     x0, ttlStr
            ret
    		endp	getTitle


// RefAryParm-
//
//	Passed the address of an array of Pt structures.
// Initializes each element of that array.

  			proc	RefAryParm
  			
  			args	rap
  			dword	rap.ptArray		// Reference parameter
  			enda	rap
  			
  			enter	0				// No stack space for this guy!
            
// Get the base address of the array into X1:

            ldr     x1, [fp, #rap.ptArray]
            
// while x0 < NumElements, initialize each
// array element. x = x0/8, y=x0 % 8

			mov		x0, xzr				//Index into array
ForEachEl:  cmp     x0, #NumElements	//While we're not done
            bhs     LoopDone
            
// Compute address of ptArray[x0]
// Element adrs = base address (X1) plus index (X19) * size (2)

			add		x3, x1, x0, lsl #1	// x3=x1 + x0*2
			
// Store index / 8 into X field:

            lsr     x2, x0, #3			// x2=x0 / 8
			strb	w2, [x3, #pt.x]		// ptArray[x0].x = x0/8

// Store index % 8 (mod) into y field:

			and		x2, x0, #0b111		// X2=X0 % 8
			strb	w2, [x3, #pt.y]		// ptArray[x0].y = x0 % 8

// Increment index and repeat

			add		x0, x0, #1
            b.al    ForEachEl
                        
LoopDone:   leave
  			endp	RefAryParm


// Here is the "asmMain" function.

     		proc	asmMain, public
     		
// Easier to access local variables than globals, so let's
// make everything a local variable.

     		locals	am
     		word	saveX19
     		byte	Pts, NumElements * (Pt.size)
     		byte	stackSpace, 64
     		endl	am
     		
     		enter	am.size			// Reserve space
     		
     		str		x19, [fp, #saveX19]	// Preserve non-volatile reg
        
// Initialize the array of points:

            add     x0, fp, #Pts	// Compute address of Pts
            str		x0, [sp]		// Pass address on stack
            bl      RefAryParm

// Display the array:
            
            mov		x19, xzr		// X19 is loop counter
dispLp:     cmp     x19, #NumElements
            bhs     dispDone
            
// Print the x field:

            lea     x0, fmtStr1
            mov		x1, x19
            mstr	x1, [sp]
            add     x3, fp, #Pts            //Get array base address
            add		x3, x3, x19, lsl #1		//Index into array
			ldrb	w2, [x3, #pt.x]			//Get ptArray[x0].x
			str		x2, [sp, #8]
            bl      printf
            
// Print the y field:

            lea     x0, fmtStr2
            mov		x1, x19
            mstr	x1, [sp]
            add     x3, fp, #Pts            //Get array base address
            add		x3, x3, x19, lsl #1		//Index into array
			ldrb	w2, [x3, #pt.y]			//Get ptArray[x0].x
			str		x2, [sp, #8]
            bl      printf
            
// Increment index and repeat.

            add     x19, x19, #1
            b.al    dispLp
            
            
dispDone:
			ldr		x19, [fp, #saveX19]		// Restore X19
            leave
     		endp	asmMain
