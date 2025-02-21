/*
 * Author: Maros Orsak
 * Created: 2025-02-20
 * Description: A simple lexer for tokenizing arithmetic expressions and
 * keywords.
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUFFER_SIZE 4096
#define MAX_TOKEN_LENGTH 100

// Token Types
typedef enum {
  TOKEN_EOF,       // End of file
  TOKEN_INT,       // Integer number
  TOKEN_ID,        // Identifier
  TOKEN_KEYWORD,   // Keyword (if, else, while, return)
  TOKEN_OPERATOR,  // Operators: + - * / =
  TOKEN_SEMICOLON, // ;
  TOKEN_LPAREN,    // (
  TOKEN_RPAREN,    // )
  TOKEN_LBRACE,    // {
  TOKEN_RBRACE,    // }
  TOKEN_ERROR      // Invalid token
} TokenType;

typedef struct {
  TokenType type;
  char value[MAX_TOKEN_LENGTH];
} Token;

const char *keywords[] = {"int", "void", "return", NULL};

char *input;
size_t pos = 0;

Token get_token(void);
void skip_whitespace(void);
void skip_single_comment(void);
void skip_multiline_comment(void);
int is_keyword(const char *str);
void print_token(Token token);
void read_input(FILE *file);

// Main Function - Read input from file or stdin and tokenize
int main(int argc, char *argv[]) {
  const char *filename = NULL;

  // Allocate memory for input buffer
  input = (char *)malloc(MAX_BUFFER_SIZE);
  if (!input) {
    perror("Memory allocation failed");
    return EXIT_FAILURE;
  }

  for (int i = 1; i < argc; i++) {
    if (strstr(argv[i], ".c")) {
      filename = argv[i];
    }
    // or check if argv[i] starts with '-' if you want to process flags
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

  int foundError = 0;

  // Read the input into buffer
  read_input(file);
  if (file != stdin)
    fclose(file); // Close file if opened

  // Tokenize input
  Token token;
  do {
    token = get_token();
    if (token.type == TOKEN_ERROR) {
      foundError = 1;
    }

    print_token(token);
  } while (token.type != TOKEN_EOF);

  return foundError ? EXIT_FAILURE : EXIT_SUCCESS;
}

// Function to safely read input from file or stdin into a buffer
void read_input(FILE *file) {
  size_t length = fread(input, 1, MAX_BUFFER_SIZE - 1, file);

  if (length == 0) {
    if (feof(file)) {
      fprintf(stderr, "Warning: Input file is empty.\n");
    } else {
      perror("Error reading file");
      exit(EXIT_FAILURE);
    }
  }

  input[length] = '\0'; // Ensure null termination
  pos = 0;              // Reset lexer position
}

// Function to get the next token
Token get_token(void) {
  Token token;
  token.value[0] = '\0';

  skip_whitespace();

  if (input[pos] == '\0') {
    token.type = TOKEN_EOF;
    strcpy(token.value, "EOF");
    return token;
  }

  if (isdigit(input[pos])) {
    // Save the starting position
    int start = pos;

    // Consume all digits
    while (isdigit(input[pos])) {
      pos++;
    }

    // If the next character is alpha or underscore, this is invalid
    if (isalpha(input[pos]) || input[pos] == '_') {
      // Consume the rest of that contiguous alphanumeric section
      while (isalnum(input[pos]) || input[pos] == '_') {
        pos++;
      }

      // Mark as TOKEN_ERROR
      token.type = TOKEN_ERROR;
      strncpy(token.value, &input[start], pos - start);
      token.value[pos - start] = '\0';
    } else {
      // It's a valid integer literal
      token.type = TOKEN_INT;
      strncpy(token.value, &input[start], pos - start);
      token.value[pos - start] = '\0';
    }
    return token;
  }

  if (isalpha(input[pos]) || input[pos] == '_') {
    int start = pos;
    while (isalnum(input[pos]) || input[pos] == '_')
      pos++;
    strncpy(token.value, &input[start], pos - start);
    token.value[pos - start] = '\0';
    token.type = is_keyword(token.value) ? TOKEN_KEYWORD : TOKEN_ID;
    return token;
  }

  // Handle comments before operators
  if (input[pos] == '/' && input[pos + 1] == '/') {
    skip_single_comment();
    return get_token();
  }

  if (input[pos] == '/' && input[pos + 1] == '*') {
    skip_multiline_comment();
    return get_token();
  }

  switch (input[pos]) {
  case '+':
  case '-':
  case '*':
  case '/':
  case '=':
    token.type = TOKEN_OPERATOR;
    token.value[0] = input[pos];
    token.value[1] = '\0';
    pos++;
    return token;
  case ';':
    token.type = TOKEN_SEMICOLON;
    token.value[0] = ';';
    token.value[1] = '\0';
    pos++;
    return token;
  case '(':
    token.type = TOKEN_LPAREN;
    token.value[0] = '(';
    token.value[1] = '\0';
    pos++;
    return token;
  case ')':
    token.type = TOKEN_RPAREN;
    token.value[0] = ')';
    token.value[1] = '\0';
    pos++;
    return token;

  case '{': // Handle '{' as a separate token type
    token.type = TOKEN_LBRACE;
    token.value[0] = '{';
    token.value[1] = '\0';
    pos++;
    return token;
  case '}': // Handle '}' as a separate token type
    token.type = TOKEN_RBRACE;
    token.value[0] = '}';
    token.value[1] = '\0';
    pos++;
    return token;
  }
  token.type = TOKEN_ERROR;
  token.value[0] = input[pos];
  token.value[1] = '\0';
  pos++;
  return token;
}

// Skip whitespace characters
void skip_whitespace(void) {
  while (input[pos] == ' ' || input[pos] == '\t' || input[pos] == '\r' ||
         input[pos] == '\n') {
    pos++;
  }
}

// Skip single-line comments `//`
void skip_single_comment(void) {
  while (input[pos] != '\n' && input[pos] != '\0') {
    pos++;
  }
}

// Skip multi-line comments `/* ... */`
void skip_multiline_comment(void) {
  // We know we're at '/' followed by '*', so step past those two
  pos += 2;
  // Keep going until we find "*/" or reach the end of input
  while (input[pos] != '\0' && !(input[pos] == '*' && input[pos + 1] == '/')) {
    pos++;
  }
  // If not end of input, skip past "*/"
  if (input[pos] != '\0') {
    pos += 2;
  }
}

// Check if a word is a keyword
int is_keyword(const char *str) {
  for (int i = 0; keywords[i] != NULL; i++) {
    if (strcmp(str, keywords[i]) == 0) {
      return 1;
    }
  }
  return 0;
}

// Print Token Information
void print_token(Token token) {
  const char *type_names[] = {"EOF",          "INT",      "ID",
                              "KEYWORD",      "OPERATOR", "SEMICOLON",
                              "LPAREN",       "RPAREN",   "TOKEN_LBRACE",
                              "TOKEN_RBRACE", "ERROR"};
  printf("Token(Type: %s, Value: '%s')\n", type_names[token.type], token.value);
}
