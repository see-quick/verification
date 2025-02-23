# Tacky-to-Assembly Compiler

A minimal compiler for a small subset of C that demonstrates:

1. **Lexing** and **Parsing** (unary operators, integer literals, return statements).
2. **TACKY IR** generation (three-address code).
3. **Assembly IR** generation (with pseudo-registers).
4. **Pseudoregister Replacement** (assigning stack slots to each `tmp.X`).
5. **Fixing Memory-to-Memory Moves** (using `%r10d`).
6. **Final Code Emission** (with function prologue/epilogue, e.g., `pushq %rbp`, `movq %rsp, %rbp`, etc.).

Below is a reference implementation with all the relevant source files. You can build it into a single executable (`parser`) that will parse a `.c` file, generate TACKY IR, convert that to assembly, and optionally emit final assembly code.

---

## File Structure

1. **`lexer.h` / `lexer.c`**  
   - Implements a simple lexer that reads an entire file into memory.
   - Identifies tokens: integers, identifiers, keywords (`int`, `void`, `return`), parentheses, braces, unary operators (`-`, `~`), etc.

2. **`parser.c`**  
   - Implements a basic recursive-descent parser for a grammar:
     ```
     <program>   ::= <function>
     <function>  ::= "int" <identifier> "(" "void" ")" "{" <statement> "}"
     <statement> ::= "return" <exp> ";"
     <exp>       ::= <int> | <unary_operator> <exp> | "(" <exp> ")"
     ```
   - Produces TACKY IR instructions (`TACKY_RETURN`, `TACKY_UNARY`) in a linked list.

3. **`tacky.h` / `tacky.c`**  
   - Defines TACKY data structures:  
     - `TackyVal` (constant vs. variable)  
     - `TackyInstr` (return / unary ops)  
   - Functions to add instructions, print TACKY, and generate temporary variable names.

4. **`assembly.h` / `assembly.c`**  
   - Defines an Assembly IR with `mov`, `unary` (`negl`, `notl`), `allocate_stack (subq)`, `ret`.
   - Converts TACKY to assembly with pseudo-registers.
   - Provides passes to:
     - Replace each pseudo-register (`tmp.X`) with a unique stack slot (e.g., `-4(%rbp)`).
     - Fix memory-to-memory moves by using `%r10d`.
   - Emits final x86-64 assembly instructions (AT&T syntax) with function prologue/epilogue.

---

## Building

Compile all the `.c` files together:

```bash
gcc lexer.c parser.c tacky.c assembly.c -o parser
```

This produces the parser executable.

## Usage 
```bash
./parser <source>.c [--tacky] [--asm]
```


```bash
cat example_programs/unary_complement_constant.c
# => int main(void) { return ~2; }

./parser example_programs/unary_complement_constant.c --asm
```

```asm
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
```


