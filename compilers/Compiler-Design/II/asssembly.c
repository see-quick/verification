#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asssembly.h"
#include "tacky.h"

//------------------------------------------------
// Creating new instructions
//------------------------------------------------
AsmInstr *new_mov(AsmOperand s, AsmOperand d) {
    AsmInstr *i = calloc(1, sizeof(*i));
    i->type = ASM_MOV;
    i->mov.src = s;
    i->mov.dst = d;
    return i;
}

AsmInstr *new_unary(AsmUnaryOp op, AsmOperand a) {
    AsmInstr *i = calloc(1, sizeof(*i));
    i->type = ASM_UNARY;
    i->unary.op = op;
    i->unary.operand = a;
    return i;
}

AsmInstr *new_ret(void) {
    AsmInstr *i = calloc(1, sizeof(*i));
    i->type = ASM_RET;
    return i;
}

AsmInstr *new_alloc_stack(int bytes) {
    AsmInstr *i = calloc(1, sizeof(*i));
    i->type = ASM_ALLOCATE_STACK;
    i->alloc.bytes = bytes;
    return i;
}

//------------------------------------------------
// Adding instructions to the end of a list
//------------------------------------------------
void append_asm_instr(AsmInstrList **head, AsmInstr instr) {
    // Make a new node for the list
    AsmInstrList *node = malloc(sizeof(*node));
    node->instr = instr;  // copy the struct
    node->next = NULL;

    if (!*head) {
        *head = node;
    } else {
        AsmInstrList *cur = *head;
        while (cur->next) cur = cur->next;
        cur->next = node;
    }
}

//------------------------------------------------
// Debug printing
//------------------------------------------------
void print_operand(const AsmOperand *op) {
    switch (op->kind) {
        case OP_IMM:
            printf("$%d", op->imm);
            break;
        case OP_REG:
            if (op->reg == REG_AX)  printf("%%eax");
            else                    printf("%%r10d");
            break;
        case OP_PSEUDO:
            printf("<pseudo:%s>", op->pseudo);
            break;
        case OP_STACK:
            printf("%d(%%rbp)", op->offset);
            break;
    }
}

void print_asm_list(const AsmInstrList *list) {
    for (; list; list = list->next) {
        const AsmInstr *i = &list->instr;
        switch (i->type) {
            case ASM_MOV:
                printf("movl ");
                print_operand(&i->mov.src);
                printf(", ");
                print_operand(&i->mov.dst);
                printf("\n");
                break;
            case ASM_UNARY:
                if (i->unary.op == UNARY_NEG) printf("negl ");
                else                          printf("notl ");
                print_operand(&i->unary.operand);
                printf("\n");
                break;
            case ASM_ALLOCATE_STACK:
                printf("subq $%d, %%rsp\n", i->alloc.bytes);
                break;
            case ASM_RET:
                printf("ret\n");
                break;
        }
    }
}

// ---------_ CONVERT tacky -> Assembly Pseudo- registers
//
static AsmOperand operand_from_tacky_val(TackyVal v) {
    AsmOperand op;
    if (v.type == TACKY_VAL_CONST) {
        op.kind = OP_IMM;
        op.imm  = v.constant;
    } else {
        op.kind = OP_PSEUDO;
        strncpy(op.pseudo, v.var, sizeof(op.pseudo)-1);
        op.pseudo[sizeof(op.pseudo)-1] = '\0';
    }
    return op;
}

static AsmUnaryOp convert_tacky_unary(UnaryOp u) {
    return (u == UNARY_NEGATE) ? UNARY_NEG : UNARY_NOT;
}

AsmInstr *tacky_to_asm(TackyInstrList *tlist) {
    AsmInstr *alist = NULL;
    for (; tlist; tlist = tlist->next) {
        TackyInstr *ti = &tlist->instr;
        if (ti->type == TACKY_RETURN) {
            // mov val -> %eax, then ret
            AsmOperand src = operand_from_tacky_val(ti->return_instr.val);
            AsmOperand dst = { .kind = OP_REG, .reg = REG_AX };
            append_asm_instr(&alist, new_mov(src, dst));
            append_asm_instr(&alist, new_ret());
        }
        else if (ti->type == TACKY_UNARY) {
            // mov src->dst; unary(op, dst)
            AsmOperand src = operand_from_tacky_val(ti->unary_instr.src);
            AsmOperand dst = operand_from_tacky_val(ti->unary_instr.dst);

            append_asm_instr(&alist, new_mov(src, dst));
            append_asm_instr(&alist, new_unary(
                convert_tacky_unary(ti->unary_instr.op),
                dst
            ));
        }
    }
    return alist;
}
