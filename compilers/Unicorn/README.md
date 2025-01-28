# Unicorn Language Compiler

Unicorn Language is a custom programming language designed for experimentation with ANTLR-based compilers. The syntax is similar to Java, but it uses the special character `🦄` instead of `;` as the statement terminator. This project compiles Unicorn-language programs into Java code for testing purposes.

## Project Structure

```
.
├── Unicorn.g4                # ANTLR grammar for Unicorn language
├── UnicornLexer.java         # ANTLR-generated lexer
├── UnicornParser.java        # ANTLR-generated parser
├── UnicornVisitor.java       # ANTLR visitor interface
├── UnicornBaseVisitor.java   # ANTLR base visitor class
├── UnicornToJavaVisitor.java # Custom visitor to translate Unicorn code to Java
├── Main.java                 # Entry point for the compiler
├── examples                  # Sample Unicorn-language programs
│   ├── 00_variable_declaration.unicorn
│   ├── 01_function_definition.unicorn
│   ├── 02_while_loop.unicorn
│   └── 03_function_call.unicorn
```

## Features
- **Variable declarations**: Example - `var x = 10🦄`
- **Function definitions**: Example - `function sayHello() { return "Hello"🦄 }`
- **While loops**: Example - `while (x > 0) { x = x - 1🦄 }`
- **Main function support**: `function main() { ... }`

## Getting Started

### Prerequisites
- **Java Development Kit (JDK)**: Version 8+
- **ANTLR Tool**: Version 4.13.2
- ANTLR runtime library (`antlr-4.13.2-complete.jar`)

### Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Generate ANTLR classes:
   ```bash
   antlr4 -visitor Unicorn.g4
   ```

3. Compile the source code:
   ```bash
   javac -cp .:/path/to/antlr-4.13.2-complete.jar *.java
   ```

### Running the Compiler
To compile a Unicorn-language program, run:
```bash
java -cp .:/path/to/antlr-4.13.2-complete.jar Main examples/<filename>.unicorn
```

For example:
```bash
java -cp .:/path/to/antlr-4.13.2-complete.jar Main examples/00_variable_declaration.unicorn
```

The compiler will generate Java code based on the Unicorn program and print it to the console.

### Example Unicorn Program
Here’s an example of a Unicorn program:
```unicorn
// Function to calculate factorial
function factorial(n) {
  var result = 1🦄
  while (n > 1) {
    result = result * n🦄
    n = n - 1🦄
  }
  return result🦄
}

// Main function
function main() {
  var number = 5🦄
  var fact = factorial(number)🦄
  return "Factorial of " + number + " is " + fact🦄
}
```

The generated Java code will look like this:
```java
public class GeneratedProgram {
    public static int factorial(int n) {
        int result = 1;
        while (n > 1) {
            result = result * n;
            n = n - 1;
        }
        return result;
    }

    public static String main() {
        int number = 5;
        int fact = factorial(number);
        return "Factorial of " + number + " is " + fact;
    }

    public static void main(String[] args) {
        System.out.println(main());
    }
}
```

### Testing
To verify the generated code, save it as a `.java` file (e.g., `GeneratedProgram.java`), compile it, and run:
```bash
javac GeneratedProgram.java
java GeneratedProgram
```

### Future Enhancements
- Add direct execution (interpreter) support for Unicorn programs.
- Extend syntax to support more constructs (e.g., arrays, objects).
- Generate machine code or custom bytecode instead of Java.

