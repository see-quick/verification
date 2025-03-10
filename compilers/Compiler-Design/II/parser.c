/*
 * parser.c
 * Example recursive-descent parser for:
 *   <program>   ::= <function>
 *   <function>  ::= "int" <identifier> "(" "void" ")" "{" <statement> "}"
 *   <statement> ::= "return" <exp> ";"
 *   <exp>       ::= <int> | <unary_operator> <exp> | "(" <exp> ")"
 *   <unary_operator> ::= "~" | "-"
 *
 * Author: Maros Orsak
 * Created: 2025-02-22
 * Description: A simple parser that uses the lexer to parse a minimal grammar.
 */

#include "lexer.h"
#include "tacky.h"
#include "assembly.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// We'll store the "current token" globally for simplicity
static Token currentToken;
static TackyInstrList *tacky_instructions = NULL;

// Forward declarations for grammar-based functions
static void parseProgram(void);
static void parseFunction(void);
static void parseStatement(void);
static void syntaxError(const char *msg);
static void advanceToken(void);

// Emit a TACKY value for the next expression
static TackyVal emit_tacky_expr(TackyInstrList **instructions);

/**
 * parse()
 * Entry point for the parser: parse <program> = <function>
 */
void parse(void) {
  advanceToken(); // Load the first token
  parseProgram();
  if (currentToken.type != TOKEN_EOF) {
    syntaxError("Extra stuff after the valid program");
  }
}

/**
 * <program> ::= <function>
 */
static void parseProgram(void) { parseFunction(); }

/**
 * <function> ::= "int" <identifier> "(" "void" ")" "{" <statement> "}"
 */
static void parseFunction(void) {
  // Expect 'int'
  if (currentToken.type != TOKEN_KEYWORD ||
      strcmp(currentToken.value, "int") != 0) {
      syntaxError("Expected 'int' keyword at start of function");
  }
  advanceToken();

  // Expect identifier
  if (currentToken.type != TOKEN_ID) {
    syntaxError("Expected function name (identifier)");
  }

  advanceToken();

  // Expect '('
  if (currentToken.type != TOKEN_LPAREN) {
    syntaxError("Expected '(' after function name");
  }
  advanceToken();

  // Expect 'void'
  if (currentToken.type != TOKEN_KEYWORD ||
      strcmp(currentToken.value, "void") != 0) {
    syntaxError("Expected 'void' in parameter list");
  }
  advanceToken();

  // Expect ')'
  if (currentToken.type != TOKEN_RPAREN) {
    syntaxError("Expected ')' after 'void'");
  }
  advanceToken();

  // Expect '{'
  if (currentToken.type != TOKEN_LBRACE) {
    syntaxError("Expected '{' before function body");
  }
  advanceToken();

  // parse <statement>
  parseStatement();

  // Expect '}'
  if (currentToken.type != TOKEN_RBRACE) {
    syntaxError("Expected '}' after statement");
  }
  advanceToken();
}

static void parseStatement(void) {
    if (currentToken.type != TOKEN_KEYWORD || strcmp(currentToken.value, "return") != 0) {
        syntaxError("Expected 'return' statement");
    }
    advanceToken();

    // Generate TACKY IR for expression and get the result variable
    TackyVal val = emit_tacky_expr(&tacky_instructions);

    // Emit a Return instruction referencing the computed value
    TackyInstr instr;
    instr.type = TACKY_RETURN;
    instr.return_instr.val = val;  // Convert result to integer
    add_tacky_instr(&tacky_instructions, instr);

    // Expect ';'
    if (currentToken.type != TOKEN_SEMICOLON) {
        syntaxError("Expected ';' after return expression");
    }
    advanceToken();
}

//------------------------------------
// Expression => generate TACKYVal
//------------------------------------
static TackyVal emit_tacky_expr(TackyInstrList **instructions) {
    // Parenthesized expression
    if (currentToken.type == TOKEN_LPAREN) {
        advanceToken();
        TackyVal innerVal = emit_tacky_expr(instructions);
        if (currentToken.type != TOKEN_RPAREN) {
            syntaxError("Expected ')' after expression");
        }
        advanceToken();
        return innerVal;
    }
    // Unary operators '-' or '~'
    else if (currentToken.type == TOKEN_MINUS || currentToken.type == TOKEN_TILDE) {
        TokenType op = currentToken.type;
        advanceToken();

        TackyVal src = emit_tacky_expr(instructions);

        // Allocate a new temp var
        TackyVal dst;
        dst.type = TACKY_VAL_VAR;
        strncpy(dst.var, generate_temp_var(), sizeof(dst.var));

        // Create a Unary instruction
        TackyInstr u;
        u.type = TACKY_UNARY;
        u.unary_instr.op =
            (op == TOKEN_MINUS) ? UNARY_NEGATE : UNARY_COMPLEMENT;
        u.unary_instr.src = src;
        u.unary_instr.dst = dst;
        add_tacky_instr(instructions, u);

        return dst; // result is the newly created temp
    }
    // Integer literal
    else if (currentToken.type == TOKEN_INT) {
        TackyVal val;
        val.type = TACKY_VAL_CONST;
        val.constant = atoi(currentToken.value);
        advanceToken();
        return val;
    }
    // Error
    else {
        syntaxError("Invalid expression");
        // Unreachable
        TackyVal dummy;
        dummy.type = TACKY_VAL_CONST;
        dummy.constant = 0;
        return dummy;
    }
}

//--------------------------------------
// Support functions
//--------------------------------------

static void advanceToken(void) { currentToken = get_token(); }

static void syntaxError(const char *msg) {
  fprintf(stderr, "Syntax Error: %s\n", msg);
  exit(EXIT_FAILURE);
}


/**
 * main() - now locates a .c file among the arguments
 * 1. Finds the first argument containing ".c"
 * 2. Calls read_input() from lexer
 * 3. Then calls parse()
 * 4. If no errors, print "Parsed successfully!"
 */
int main(int argc, char **argv) {
  const char *filename = NULL;
  int output_tacky = 0;
  int output_asm = 0;

  // Find a .c file among the arguments
  for (int i = 1; i < argc; i++) {
    if (strstr(argv[i], ".c")) {
      filename = argv[i];
    } else if (strcmp(argv[i], "--tacky") == 0) {
      output_tacky = 1;
    } else if (strcmp(argv[i], "--asm") == 0) {
      output_asm = 1;
    }
    // Potentially handle other flags here if needed
  }

  if (!filename) {
    fprintf(stderr, "No .c file provided.\n");
    return EXIT_FAILURE;
  }

  FILE *file = fopen(filename, "r");
  if (!file) {
    perror("Error opening file");
    return EXIT_FAILURE;
  }

  // Let the lexer read everything in
  read_input(file);
  fclose(file);

  // Run the parser
  parse();

  if (output_tacky) {
    print_tacky(tacky_instructions);
    return 0;
  }

  if (output_asm) {
    // 1) Convert TACKY -> assembly with pseudo-registers
    AsmInstrList *alist = tacky_to_asm(tacky_instructions);
  
    // try ASM
    finalize_asm(&alist);

    emit_asm_function("main", alist);
    // epilogiue...of ASM
    printf(".section .note.GNU-stack,\"\",@progbits\n");  


    // TODO: free memory here... :) 
  }

  return 0;
}
