#ifndef ASSEMBLY_H
#define ASSEMBLY_H

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

// We allow these operand forms:
typedef enum {
    OP_IMM,     // Immediate integer
    OP_REG,     // e.g. %eax / %r10d
    OP_PSEUDO,  // a “temporary variable” name
    OP_STACK    // e.g., -4(%rbp)
} OperandType;

typedef enum {
    REG_AX,     // Actually EAX (32-bit) or RAX (64-bit)
    REG_R10     // R10D, etc.
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
        struct {
            AsmOperand src, dst;
        } mov;
        struct {
            AsmUnaryOp op;
            AsmOperand operand;  // same source/destination
        } unary;
        struct {
            int bytes; // how many bytes to sub from %rsp
        } alloc;
        // no fields for RET
    };
} AsmInstr;

typedef struct AsmInstrList {
    AsmInstr instr;
    struct AsmInstrList *next;
} AsmInstrList;

typedef struct {
    // We allow multiple functions; each function has a name and an instruction list
    char name[64];
    AsmInstrList *instrs;
} AsmFunction;

typedef struct {
    // A complete assembly program
    int func_count;
    AsmFunction funcs[16];
} AsmProgram;

AsmInstr *new_mov(AsmOperand s, AsmOperand d);
AsmInstr *new_unary(AsmUnaryOp op, AsmOperand a);
AsmInstr *new_ret(void);
AsmInstr *new_alloc_stack(int bytes);

void append_asm_instr(AsmInstrList **head, AsmInstr instr);

void print_operand(const AsmOperand *op);
void print_asm_list(const AsmInstrList *list);

#endif
