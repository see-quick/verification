#include "../aoaa.inc"

stackSpace	  =			64
saveLR		    =			56

.section  	.rodata, ""


  ttlStr:   	.asciz    	"Procedure without a ret instruction :))"
  fpMsg:     	.asciz    	"followingProc was called\n"
        
.code
.extern   printf

// Return program title to C++ program:

  proc  	getTitle, public
  lea 	x0, ttlStr
  ret
  endp 	getTitle

// no_ret-
// 
//  Demonstrates what happens when a procedure
// does not have a return instruction.
  proc 	no_ret
  endp 	no_ret

	proc	following_proc
	sub		sp, sp, #stackSpace
	str		lr, [sp, #saveLR]
			
  lea  	x0, fpMsg
  bl 		printf
            
  ldr		lr, [sp, #saveLR]
  add		sp, sp, #stackSpace
  ret
 	endp	following_proc


// Here is the "asmMain" function.

	proc	asmMain, public
	sub		sp, sp, #stackSpace
	str		lr, [sp, #saveLR]
                

  bl    	no_ret
              
  ldr		lr, [sp, #saveLR]
  add		sp, sp, #stackSpace
  ret
  endp	asmMain
