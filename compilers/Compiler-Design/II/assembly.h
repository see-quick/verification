#ifndef ASSEMBLY_H
#define ASSEMBLY_H

#include <stdio.h>
#include "tacky.h" // for TackyInstrList if needed

typedef enum {
    ASM_MOV,
    ASM_UNARY,
    ASM_ALLOCATE_STACK,
    ASM_RET
} AsmInstrType;

typedef enum {
    UNARY_NEG,  // neg
    UNARY_NOT   // not
} AsmUnaryOp;

typedef enum {
    OP_IMM,     // e.g. $5
    OP_REG,     // e.g. %eax, %r10d
    OP_PSEUDO,  // e.g. <pseudo:tmp.0>
    OP_STACK    // e.g. -4(%rbp)
} OperandType;

typedef enum {
    REG_AX,  // we'll treat it like 32-bit EAX
    REG_R10  // we'll treat it like 32-bit R10D
} RegName;

typedef struct {
    OperandType kind;
    union {
        int imm;         // OP_IMM
        RegName reg;     // OP_REG
        char pseudo[32]; // OP_PSEUDO
        int offset;      // OP_STACK => offset from %rbp
    };
} AsmOperand;

typedef struct {
    AsmInstrType type;
    union {
        struct { AsmOperand src, dst; } mov;   // ASM_MOV
        struct { AsmUnaryOp op; AsmOperand operand; } unary; // ASM_UNARY
        struct { int bytes; } alloc;           // ASM_ALLOCATE_STACK
        // ASM_RET has no fields
    };
} AsmInstr;

typedef struct AsmInstrList {
    AsmInstr instr;              
    struct AsmInstrList *next;   
} AsmInstrList;

// Creation (by value)
AsmInstr new_mov(AsmOperand s, AsmOperand d);
AsmInstr new_unary(AsmUnaryOp op, AsmOperand a);
AsmInstr new_ret(void);
AsmInstr new_alloc_stack(int bytes);

// Add an instruction to the linked list
void append_asm_instr(AsmInstrList **head, AsmInstr instr);

// Debug printing
void print_operand(const AsmOperand *op);
void print_asm_list(const AsmInstrList *list);

// Convert from TACKY IR to an assembly-instruction list
AsmInstrList *tacky_to_asm(TackyInstrList *tlist);
void finalize_asm(AsmInstrList **alist);

#endif
