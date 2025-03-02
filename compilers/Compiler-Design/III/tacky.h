#ifndef TACKY_H
#define TACKY_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// A TACKY value can be a constant int or a variable name
typedef enum {
  TACKY_VAL_CONST,
  TACKY_VAL_VAR
} TackyValType;

typedef struct {
  TackyValType type;
  union {
    int constant;
    char var[32];
  };
} TackyVal;

typedef enum {
    TACKY_RETURN,
    TACKY_UNARY,
    TACKY_BINARY
} TackyInstrType;

typedef enum {
    UNARY_NEGATE,
    UNARY_COMPLEMENT
} UnaryOp;

typedef enum {
    BINARY_ADD,
    BINARY_SUBTRACT,
    BINARY_MULTIPLY,
    BINARY_DIVIDE,
    BINARY_REMAINDER
} BinaryOp;

typedef struct {
    TackyInstrType type;
    union {
        struct {
            TackyVal val;
        } return_instr;
        struct {
            UnaryOp op;
            TackyVal src;
            TackyVal dst;
        } unary_instr;
        struct {
            BinaryOp op;
            TackyVal left;
            TackyVal right;
            TackyVal dest;
        } binary_instr;
    };
} TackyInstr;

// List to store TACKY instructions
typedef struct TackyInstrList {
    TackyInstr instr;
    struct TackyInstrList *next;
} TackyInstrList;

void add_tacky_instr(TackyInstrList **list, TackyInstr instr);
void print_tacky(TackyInstrList *list);
const char *generate_temp_var(void);

const char *emit_tacky(TackyInstrList **instructions);


#endif // TACKY_H
