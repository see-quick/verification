#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

#define MAX_TOKENS 100
#define MAX_TOKEN_LENGTH 50

typedef struct {
    char *type;
    char *value;
} Token;

const char *TOKEN_PATTERNS[][2] = {
    {"Identifier", "^[a-zA-Z_]\\w*\\b"},
    {"Constant", "^[0-9]+\\b"},
    {"int", "^int\\b"},
    {"void", "^void\\b"},
    {"return", "^return\\b"},
    {"OpenParenthesis", "^\\("},
    {"CloseParenthesis", "^\\)"},
    {"OpenBrace", "^\\{"},
    {"CloseBrace", "^\\}"},
    {"Semicolon", "^;"}
};

#define TOKEN_COUNT (sizeof(TOKEN_PATTERNS) / sizeof(TOKEN_PATTERNS[0]))

void add_token(Token tokens[], int *count, const char *type, const char *value) {
    tokens[*count].type = strdup(type);
    tokens[*count].value = strdup(value);
    (*count)++;
}

void tokenize(const char *input) {
    Token tokens[MAX_TOKENS];
    int token_count = 0;
    
    while (*input) {
        while (*input == ' ' || *input == '\t' || *input == '\n') {
            input++; // Skip whitespace
        }
        
        if (*input == '\0') {
            break;
        }

        int matched = 0;
        for (size_t i = 0; i < TOKEN_COUNT; i++) {
            regex_t regex;
            regmatch_t match;
            if (regcomp(&regex, TOKEN_PATTERNS[i][1], REG_EXTENDED) != 0) {
                fprintf(stderr, "Failed to compile regex\n");
                exit(1);
            }

            if (regexec(&regex, input, 1, &match, 0) == 0) {
                int len = match.rm_eo - match.rm_so;
                if (len == 0) {
                    regfree(&regex);
                    continue;
                }
                char *token_value = strndup(input, len);
                add_token(tokens, &token_count, TOKEN_PATTERNS[i][0], token_value);
                free(token_value);
                input += len;
                matched = 1;
            }
            regfree(&regex);
            if (matched) break;
        }
        
        if (!matched) {
            fprintf(stderr, "Lexer error: Unrecognized token at '%s'\n", input);
            exit(1);
        }
    }

    for (int i = 0; i < token_count; i++) {
        printf("%s: %s\n", tokens[i].type, tokens[i].value);
        free(tokens[i].type);
        free(tokens[i].value);
    }
}

int main() {
    char input[256];
    printf("Enter code: ");
    fgets(input, sizeof(input), stdin);
    tokenize(input);
    return 0;
}
