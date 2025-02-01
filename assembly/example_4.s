.text

.global _assembly, assembly
.align 2

_assembly:
assembly:
	ret 

getTitle:
	lea	x0, title
	ret

title:
	.asciz "My first return of the x0 register"
