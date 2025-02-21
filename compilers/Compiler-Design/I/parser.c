/*
 * parser.c
 * Example recursive-descent parser for:
 *   <program>   ::= <function>
 *   <function>  ::= "int" <identifier> "(" "void" ")" "{" <statement> "}"
 *   <statement> ::= "return" <exp> ";"
 *   <exp>       ::= <int>
 *
 * Author: Maros Orsak
 * Created: 2025-02-21
 * Description: A simple parser that uses the lexer to parse a minimal grammar.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lexer.h"

// We'll store the "current token" globally for simplicity
static Token currentToken;

// Forward declarations for grammar-based functions
static void parseProgram(void);
static void parseFunction(void);
static void parseStatement(void);
static void parseExp(void);
static void syntaxError(const char *msg);
static void advanceToken(void);

/**
 * parse()
 * Entry point for the parser: parse <program> = <function>
 */
void parse(void) {
    advanceToken();   // Load the first token
    parseProgram();
    if (currentToken.type != TOKEN_EOF) {
        syntaxError("Extra stuff after the valid program");
    }
}

/**
 * <program> ::= <function>
 */
static void parseProgram(void) {
    parseFunction();
}

/**
 * <function> ::= "int" <identifier> "(" "void" ")" "{" <statement> "}"
 */
static void parseFunction(void) {
    // Expect 'int'
    if (currentToken.type != TOKEN_KEYWORD || strcmp(currentToken.value, "int") != 0) {
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
    if (currentToken.type != TOKEN_KEYWORD || strcmp(currentToken.value, "void") != 0) {
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

/**
 * <statement> ::= "return" <exp> ";"
 */
static void parseStatement(void) {
    if (currentToken.type != TOKEN_KEYWORD || strcmp(currentToken.value, "return") != 0) {
        syntaxError("Expected 'return' statement");
    }
    advanceToken();

    // parse <exp>
    parseExp();

    // Expect ';'
    if (currentToken.type != TOKEN_SEMICOLON) {
        syntaxError("Expected ';' after return expression");
    }
    advanceToken();
}

/**
 * <exp> ::= <int>
 */
static void parseExp(void) {
    if (currentToken.type == TOKEN_INT) {
        advanceToken();
    } else {
        syntaxError("Expected integer literal in expression");
    }
}

//--------------------------------------
// Support functions
//--------------------------------------

static void advanceToken(void) {
    currentToken = get_token();
}

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

    // Find a .c file among the arguments
    for (int i = 1; i < argc; i++) {
        if (strstr(argv[i], ".c")) {
            filename = argv[i];
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

    printf("Parsed successfully!\n");
    return 0;
}
