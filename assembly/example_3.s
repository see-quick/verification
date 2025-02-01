.include "aoaa.inc" 

.global _main
.align 2
.data
	val1:  .dword 10

_main:
	lea x0, val1
	ldr x0, [x0]
	
	lea x1, val1
	str x0, [x1]
	
	ret
