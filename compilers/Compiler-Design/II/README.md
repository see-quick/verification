Tacky-to-Assembly Compiler

This project is a simple compiler that:
	1.	Lexes and parses minimal C source code (with unary operators).
	2.	Generates TACKY IR (three-address code).
	3.	Converts TACKY IR into an assembly-like IR (with pseudo-registers).
	4.	Replaces pseudo-registers with stack slots.
	5.	Fixes memory-to-memory moves using %r10d.
	6.	Emits final x86-64 assembly code (with a function prologue/epilogue).

File Structure
	•	lexer.c / lexer.h
A simple lexer reading an entire file into memory. It recognizes integers, identifiers, keywords, parentheses, braces, unary operators, etc.
	•	parser.c
Implements a recursive-descent parser for a minimal grammar:

<program>   ::= <function>
<function>  ::= "int" <identifier> "(" "void" ")" "{" <statement> "}"
<statement> ::= "return" <exp> ";"
<exp>       ::= <int> | <unary_operator> <exp> | "(" <exp> ")"

It produces a linked list of TACKY instructions.

	•	tacky.c / tacky.h
Contains the data structures and helper functions for the TACKY IR:
	•	TACKY values (TACKY_VAL_CONST or TACKY_VAL_VAR)
	•	TACKY instructions (TACKY_RETURN or TACKY_UNARY)
	•	Functions to build and print TACKY IR.
	•	assembly.h / assembly.c
Defines an assembly IR (with mov, unary, allocate_stack, ret), plus:
	•	A pass to convert TACKY → assembly with pseudo-registers.
	•	A pass to replace pseudo-registers (tmp.X) with stack slots (-4(%rbp), etc.).
	•	A pass to fix memory-to-memory moves.
	•	A code emission function that prints final assembly instructions with a prologue/epilogue.

Building

Compile all .c files together. For example:

gcc lexer.c parser.c tacky.c assembly.c -o parser

This produces the parser executable.

Usage

./parser <your_file>.c [--tacky] [--asm]

	•	If you pass --tacky, the compiler prints the TACKY IR.
	•	If you pass --asm, the compiler performs:
	1.	TACKY → assembly
	2.	Pseudoreg replacement
	3.	Memory-to-memory mov fixups
	4.	Assembly printing (with function prologue/epilogue)

Example

# For the file example_programs/unary_complement_constant.c
cat example_programs/unary_complement_constant.c
# => int main(void) { return ~2; }

./parser example_programs/unary_complement_constant.c --asm

Outputs something like:

.globl main
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $4, %rsp
  movl $2, -4(%rbp)
  notl -4(%rbp)
  movl -4(%rbp), %eax
  movq %rbp, %rsp
  popq %rbp
  ret

Notes
	•	AT&T syntax is used, so instructions like movl and registers like (%rbp) or %eax appear.
	•	The “pseudo” variables tmp.0, tmp.1, etc. are replaced with stack offsets at or below -4(%rbp).
	•	This is a minimal compiler focusing on unary operations (- and ~) and returns; for more complex C features, additional passes would be required.
