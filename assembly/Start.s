.global _main
.align 2

_main:
	mov x0, #10 	// return 0
	mov x16, #1	// terminate

	svc #0x80	// syscall

// end of the file
