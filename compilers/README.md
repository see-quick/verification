# OLang - A Simple Arithmetic Language

OLang is a simple arithmetic programming language designed for educational purposes. It supports basic arithmetic operations (`+`, `-`, `*`, `/`) with integers, enabling users to understand lexical analysis, parsing, semantic analysis, and code generation concepts.

---

## Features

### Core Language
- **Arithmetic Operations**:
  - Addition (`+`)
  - Subtraction (`-`)
  - Multiplication (`*`)
  - Division (`/`)
- **Integer Support**:
  - Operates on non-negative integers.

### Compiler Components
1. **Lexical Analysis**:
   - Tokenizes input expressions into meaningful components (e.g., integers, operators).
2. **Syntax Analysis**:
   - Parses tokens into a structured representation based on a predefined grammar.
3. **Code Generation**:
   - Generates x86 assembly code for the parsed expression.

---

## Language Grammar

```antlr
// Grammar definition for OLang

grammar OLang;

prog : expr EOF ;

expr
    : expr ('*' | '/') expr
    | expr ('+' | '-') expr
    | INT
    ;

// Lexer rules
NEWLINE : [\r\n]+ -> skip ;
INT     : [0-9]+ ;
WS      : [ \t]+ -> skip ;
```

---

## Example: Input and Output

### Input Expression
```
3 + 5 * 2 / 8
```

### Parse Tree Representation
```
         expr
      /    |    \
   expr    +   expr
   /       |      \
INT      expr      expr
 |        /  \      /
3      expr   *   expr
       / \        /
     INT  /     INT
      5  2      8
```

### Generated x86 Assembly Code
```asm
; Generated x86 Assembly Code
MOV EAX, 3
PUSH EAX
MOV EAX, 5
PUSH EAX
MOV EAX, 2
PUSH EAX
POP EBX
POP EAX
IMUL EAX, EBX
PUSH EAX
MOV EAX, 8
PUSH EAX
POP EBX
POP EAX
IDIV EBX
PUSH EAX
POP EBX
POP EAX
ADD EAX, EBX
PUSH EAX
```

### Explanation
- **MOV EAX, 3**: Load the value `3` into register `EAX`.
- **PUSH EAX**: Push `3` onto the stack.
- **MOV EAX, 5**: Load `5` into `EAX`.
- **PUSH EAX**: Push `5` onto the stack.
- **IMUL EAX, EBX**: Multiply `EAX` (`5`) and `EBX` (`2`), storing the result in `EAX`.
- **IDIV EBX**: Divide `EAX` (`10`) by `EBX` (`8`), storing the quotient in `EAX`.
- **ADD EAX, EBX**: Add the top values from the stack, resulting in `4`.

---

## Architecture Diagram

### Compiler Workflow
```plaintext
 +--------------------+
 |  Input Expression  |
 +--------------------+
            |
            v
 +--------------------+
 | Lexical Analysis   |
 | (Tokenization)     |
 +--------------------+
            |
            v
 +--------------------+
 | Syntax Analysis    |
 | (Parse Tree)       |
 +--------------------+
            |
            v
 +--------------------+
 | Code Generation    |
 | (x86 Assembly)     |
 +--------------------+
```

---

## Usage Instructions

### Prerequisites
- **Python 3**
- **ANTLR**
  - Install the ANTLR tool and runtime:
    ```bash
    pip install antlr4-python3-runtime
    ```

### Steps to Run
1. **Generate Lexer and Parser**:
   ```bash
   antlr4 -Dlanguage=Python3 -visitor OLang.g4
   ```

2. **Write Input Code**:
   Example input: `3 + 5 * 2 / 8`

3. **Run the Driver Script**:
   ```bash
   python driver.py
   ```

4. **View Generated Assembly**:
   ```
   ; Generated x86 Assembly Code
   MOV EAX, 3
   PUSH EAX
   MOV EAX, 5
   PUSH EAX
   MOV EAX, 2
   PUSH EAX
   POP EBX
   POP EAX
   IMUL EAX, EBX
   PUSH EAX
   MOV EAX, 8
   PUSH EAX
   POP EBX
   POP EAX
   IDIV EBX
   PUSH EAX
   POP EBX
   POP EAX
   ADD EAX, EBX
   PUSH EAX
   ```

---

## Limitations
- Does not support parentheses.
- Operates only on integers.
- Supports basic arithmetic without variables or functions.
