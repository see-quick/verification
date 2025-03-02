/*
 * Author: Maros Orsak
 * Created: 2025-02-20
 * Description: Implementation of a simple lexer for arithmetic expressions and
 * keywords.
 */

#include "lexer.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

// The input buffer and position, hidden from outside
static char *input = NULL;
static size_t pos = 0;

// Internal prototypes
static void skip_whitespace(void);
static void skip_single_comment(void);
static void skip_multiline_comment(void);
static int is_keyword(const char *str);

// A small array of recognized keywords
static const char *keywords[] = {"int", "void", "return", NULL};

void read_input(FILE *file) {
  // Allocate memory for the input buffer if not allocated yet
  if (!input) {
    input = (char *)malloc(MAX_BUFFER_SIZE);
    if (!input) {
      perror("Memory allocation failed");
      exit(EXIT_FAILURE);
    }
  }

  // Read up to MAX_BUFFER_SIZE - 1 characters into 'input'
  size_t length = fread(input, 1, MAX_BUFFER_SIZE - 1, file);
  if (length == 0) {
    if (feof(file)) {
      fprintf(stderr, "Warning: Input file is empty.\n");
    } else {
      perror("Error reading file");
      exit(EXIT_FAILURE);
    }
  }

  // Null-terminate and reset position
  input[length] = '\0';
  pos = 0;
}

Token get_token(void) {
  Token token;
  token.value[0] = '\0';

  skip_whitespace();

  // If we've reached the end of the input
  if (input[pos] == '\0') {
    token.type = TOKEN_EOF;
    strcpy(token.value, "EOF");
    return token;
  }

  // Check if it's an integer or a malformed integer+identifier
  if (isdigit(input[pos])) {
    int start = pos;
    // Consume all digits
    while (isdigit(input[pos])) {
      pos++;
    }
    // If there's an alphabetic or underscore right after digits => error token
    if (isalpha(input[pos]) || input[pos] == '_') {
      while (isalnum(input[pos]) || input[pos] == '_') {
        pos++;
      }
      token.type = TOKEN_ERROR;
    } else {
      token.type = TOKEN_INT;
    }
    strncpy(token.value, &input[start], pos - start);
    token.value[pos - start] = '\0';
    return token;
  }

  // Check if it's an identifier or keyword
  if (isalpha(input[pos]) || input[pos] == '_') {
    int start = pos;
    while (isalnum(input[pos]) || input[pos] == '_') {
      pos++;
    }
    int length = pos - start;
    strncpy(token.value, &input[start], length);
    token.value[length] = '\0';
    token.type = is_keyword(token.value) ? TOKEN_KEYWORD : TOKEN_ID;
    return token;
  }

  // Handle single-line and multi-line comments
  if (input[pos] == '/' && input[pos + 1] == '/') {
    skip_single_comment();
    return get_token();
  }
  if (input[pos] == '/' && input[pos + 1] == '*') {
    skip_multiline_comment();
    return get_token();
  }

  // Operators and special characters
  if (input[pos] == '-') {
    if (input[pos + 1] == '-') { // Handle '--'
      token.type = TOKEN_DECREMENT;
      strcpy(token.value, "--");
      pos += 2;
      return token;
    }
    token.type = TOKEN_MINUS;
    token.value[0] = '-';
    token.value[1] = '\0';
    pos++;
    return token;
  }

  if (input[pos] == '~') {
    token.type = TOKEN_TILDE;
    token.value[0] = input[pos];
    token.value[1] = '\0';
    pos++;
    return token;
  }

  // Check single-character tokens
  switch (input[pos]) {
  case '+':
  case '*':
  case '/':
  case '=':
  case '%':
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
  case '{':
    token.type = TOKEN_LBRACE;
    token.value[0] = '{';
    token.value[1] = '\0';
    pos++;
    return token;
  case '}':
    token.type = TOKEN_RBRACE;
    token.value[0] = '}';
    token.value[1] = '\0';
    pos++;
    return token;
  default:
    // Anything else is an error
    token.type = TOKEN_ERROR;
    token.value[0] = input[pos];
    token.value[1] = '\0';
    pos++;
    return token;
  }
}

//--------------------------------------
// Internal helper functions
//--------------------------------------

static void skip_whitespace(void) {
  while (input[pos] == ' ' || input[pos] == '\t' || input[pos] == '\r' ||
         input[pos] == '\n') {
    pos++;
  }
}

static void skip_single_comment(void) {
  // Skip until newline or end of file
  pos += 2; // skip "//"
  while (input[pos] != '\n' && input[pos] != '\0') {
    pos++;
  }
}

static void skip_multiline_comment(void) {
  // We know we're at '/' followed by '*'
  pos += 2; // skip "/*"
  while (input[pos] != '\0' && !(input[pos] == '*' && input[pos + 1] == '/')) {
    pos++;
  }
  // If not end of input, skip past "*/"
  if (input[pos] != '\0') {
    pos += 2;
  }
}

static int is_keyword(const char *str) {
  for (int i = 0; keywords[i] != NULL; i++) {
    if (strcmp(str, keywords[i]) == 0) {
      return 1;
    }
  }
  return 0;
}

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

  Token token;
  do {
    token = get_token();
    if (token.type == TOKEN_ERROR) {
      return EXIT_FAILURE;
    }
    printf("Token: Type=%d, Value='%s'\n", token.type, token.value);
  } while (token.type != TOKEN_EOF);

  return EXIT_SUCCESS;
}
