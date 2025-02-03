// Listing 2-3
// 
// Demonstrate two's complement operation and input of numeric values.

#include "aoaa.inc"


			.equ		maxLen, 256

         	.data
titleStr:	.asciz		"Listing 2-3"

prompt1:  	.asciz   	"Enter an integer between 0 and 127:"
fmtStr1:  	.asciz   	"Value in hexadecimal: %x\n"
fmtStr2:  	.asciz   	"Invert all the bits (hexadecimal): %x\n"
fmtStr3:  	.asciz   	"Add 1 (hexadecimal): %x\n"
fmtStr4:  	.asciz   	"Output as signed integer: %d\n"
fmtStr5:  	.ascii   	"Negate again and output as signed integer:"
			.asciz		" %d\n"
			
fmtStr6:  	.asciz   	"Using neg instruction: %d\n"

intValue:	.dword		0
saveLR:		.dword		0


// The following reserves 256 bytes of storage to hold a string
// read from the user.

input:    	.space   	maxLen, 0
            
            
            
            .text
            .align		2
            .extern 	printf
            .extern 	atoi
            .extern 	readLine

// Return program title to C++ program:

            .global		getTitle
getTitle:
            lea 		x0, titleStr
            ret

        
// Here is the "asmMain" function.

        
            .global		asmMain
asmMain:
                           
// "Magic" instruction offered without explanation at this point:

            sub     sp, sp, #128
            
// Save LR so we can return to C++ program:

			lea		x0, saveLR
			str		lr, [x0]
                
// Read an unsigned integer from the user: This code will blindly
// assume that the user's input was correct. The atoi function returns
// zero if there was some sort of error on the user input. Later
// chapters in AoAA will describe how to check for errors from the
// user.

            lea     x0, prompt1
            bl      printf
        
            lea     x0, input
            mov     x1, #maxLen
            bl      readLine
        
// Call C stdlib strtol function.
//
// i = strtol( str, NULL, 10 )
        
            lea     x0, input
            mov		x1, xzr
            mov		x2, #10
            bl      strtol
            lea		x1, intValue
            str		x0, [x1]
        
// Print the input value (in decimal) as a hexadecimal number:
        
            lea     x0, fmtStr1
            vparm2	intValue
            bl    	printf
        
// Perform the two's complement operation on the input number. 
// Begin by inverting all the bits.
        
        	lea		x1, intValue
        	ldr		x0, [x1]
            mvn		x0, x0		// not X0
            str		x0, [x1]	// Store back into intValue
            lea     x0, fmtStr2
            vparm2	intValue
            bl		printf
        
// Invert all the bits and add 1 (inverted value is in intValue)
        
            lea     x0, intValue
            ldr		x1, [x0]
            add     x1, x1, #1
            str		x1, [x0]	// Store back into intValue
            lea     x0, fmtStr3
            vparm2	intValue
            bl      printf
        
            lea     x0, fmtStr4	// Output as integer rather
            vparm2	intValue	// than hexadecimal
            bl      printf
        
// Negate the value and print as a signed integer. Note that
// intValue already contains the negated value, so this code
// will print the original value:
        
        	lea		x0, intValue
            ldr     x1, [x0]
            mvn     x1, x1
            add     x1, x1, #1
            str		x1, [x0]
            lea     x0, fmtStr5
            vparm2	intValue
            bl      printf
        
// Negate the value using the neg instruction.
        
        	lea		x0, intValue
        	ldr		x1, [x0]
            neg     x1, x1
            str		x1, [x0]
            lea     x0, fmtStr6
            vparm2	intValue
            bl      printf

// Another "magic" instruction that undoes the effect of the previous
// one before this procedure returns to its caller.
       
       		lea		x0, saveLR
       		ldr		lr, [x0]
            add     sp, sp, #128
            ret     //Returns to caller
