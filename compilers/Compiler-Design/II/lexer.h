/*
 * Author: Maros Orsak
 * Created: 2025-02-21
 * Description: HEADER: A simple lexer for tokenizing arithmetic expressions and
 * keywords
 */
#ifndef LEXER_H
#define LEXER_H

#include <stdio.h>

// Maximum buffer sizes
#define MAX_BUFFER_SIZE 4096
#define MAX_TOKEN_LENGTH 100

// Token types
typedef enum {
    TOKEN_EOF,       // End of file
    TOKEN_INT,       // Integer number
    TOKEN_ID,        // Identifier
    TOKEN_KEYWORD,   // Keyword (int, void, return, etc.)
    TOKEN_OPERATOR,  // Operators: + - * / =
    TOKEN_DECREMENT, // -- (decrement operator)
    TOKEN_SEMICOLON, // ;
    TOKEN_LPAREN,    // (
    TOKEN_RPAREN,    // )
    TOKEN_LBRACE,    // {
    TOKEN_RBRACE,    // }
    TOKEN_ERROR      // Invalid token
} TokenType;

// Token structure
typedef struct {
    TokenType type;
    char value[MAX_TOKEN_LENGTH];
} Token;

/**
 * Reads the entire file (or stdin) into an internal buffer.
 * Must be called before get_token().
 *
 * @param file An opened FILE* (e.g., from fopen or stdin).
 */
void read_input(FILE *file);

/**
 * Retrieves the next token from the internal buffer.
 * 
 * @return The next Token.
 */
Token get_token(void);

#endif // LEXER_H
