#include "assembly.h"

//------------------------------------------------
// Creating new instructions (return by value!)
//------------------------------------------------
AsmInstr new_mov(AsmOperand s, AsmOperand d) {
  AsmInstr i;
  i.type = ASM_MOV;
  i.mov.src = s;
  i.mov.dst = d;
  return i;
}

AsmInstr new_unary(AsmUnaryOp op, AsmOperand a) {
  AsmInstr i;
  i.type = ASM_UNARY;
  i.unary.op = op;
  i.unary.operand = a;
  return i;
}

AsmInstr new_ret(void) {
  AsmInstr i;
  i.type = ASM_RET;
  return i;
}

AsmInstr new_alloc_stack(int bytes) {
  AsmInstr i;
  i.type = ASM_ALLOCATE_STACK;
  i.alloc.bytes = bytes;
  return i;
}

//------------------------------------------------
// Adding instructions to a linked list
//------------------------------------------------
void append_asm_instr(AsmInstrList **head, AsmInstr instr) {
  AsmInstrList *node = malloc(sizeof(*node));
  node->instr = instr; // store by value
  node->next = NULL;

  if (!*head) {
    *head = node;
  } else {
    AsmInstrList *cur = *head;
    while (cur->next)
      cur = cur->next;
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
    if (op->reg == REG_AX)
      printf("%%eax");
    else
      printf("%%r10d");
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
  while (list) {
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
      if (i->unary.op == UNARY_NEG)
        printf("negl ");
      else
        printf("notl ");
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
    list = list->next;
  }
}

//------------------------------------------------
// TACKY -> Assembly with pseudo-registers
//------------------------------------------------
static AsmOperand operand_from_tacky_val(TackyVal v) {
  AsmOperand op;
  if (v.type == TACKY_VAL_CONST) {
    op.kind = OP_IMM;
    op.imm = v.constant;
  } else {
    op.kind = OP_PSEUDO;
    strncpy(op.pseudo, v.var, sizeof(op.pseudo) - 1);
    op.pseudo[sizeof(op.pseudo) - 1] = '\0';
  }
  return op;
}

static AsmUnaryOp convert_tacky_unary(UnaryOp u) {
  return (u == UNARY_NEGATE) ? UNARY_NEG : UNARY_NOT;
}

AsmInstrList *tacky_to_asm(TackyInstrList *tlist) {
  AsmInstrList *alist = NULL; // head of the assembly list

  for (; tlist; tlist = tlist->next) {
    TackyInstr *ti = &tlist->instr;
    if (ti->type == TACKY_RETURN) {
      // mov val -> %eax, then ret
      AsmOperand src = operand_from_tacky_val(ti->return_instr.val);
      AsmOperand dst = {.kind = OP_REG, .reg = REG_AX};

      append_asm_instr(&alist, new_mov(src, dst));
      append_asm_instr(&alist, new_ret());
    } else if (ti->type == TACKY_UNARY) {
      // mov src->dst; unary(op, dst)
      AsmOperand src = operand_from_tacky_val(ti->unary_instr.src);
      AsmOperand dst = operand_from_tacky_val(ti->unary_instr.dst);

      append_asm_instr(&alist, new_mov(src, dst));
      append_asm_instr(&alist,
                       new_unary(convert_tacky_unary(ti->unary_instr.op), dst));
    }
  }
  return alist;
}

// ----- TRASSLATE PSEUDO_REGISTERs to normal system ones'
//
//
//
//
static struct {
  char pseudoName[32];
  int offset;
} pseudoMap[100]; // it's for 100 pseudo-registers...

static int pseudoCount = 0;
static int nextOffset =
    -4; // start with -4(%rbp) (it's because we have int's which are 4-bytes

static int get_stack_offset_for_pseudo(const char *name) {
  // Check if it's already in the map
  for (int i = 0; i < pseudoCount; i++) {
    if (strcmp(pseudoMap[i].pseudoName, name) == 0) {
      return pseudoMap[i].offset;
    }
  }
  // Otherwise, assign a new offset
  strncpy(pseudoMap[pseudoCount].pseudoName, name, 31);
  pseudoMap[pseudoCount].offset = nextOffset;
  pseudoCount++;
  int assigned = nextOffset;
  nextOffset -= 4; // each pseudo is 4 bytes
  return assigned;
}

static void replace_pseudo_operand(AsmOperand *op) {
    if (op->kind == OP_PSEUDO) {
        int off = get_stack_offset_for_pseudo(op->pseudo);
        op->kind = OP_STACK;
        op->offset = off;
    }
}

static int replace_pseudoregs_in_list(AsmInstrList *head) {
    // Reset the offset each time
    pseudoCount = 0;
    nextOffset  = -4;

    for (AsmInstrList *node = head; node; node = node->next) {
        AsmInstr *inst = &node->instr;
        switch (inst->type) {
            case ASM_MOV:
                replace_pseudo_operand(&inst->mov.src);
                replace_pseudo_operand(&inst->mov.dst);
                break;
            case ASM_UNARY:
                replace_pseudo_operand(&inst->unary.operand);
                break;
            case ASM_ALLOCATE_STACK:
            case ASM_RET:
                // no pseudo here
                break;
        }
    }

    // total bytes used = -(nextOffset + 4).
    int used = -(nextOffset + 4);
    return (used < 0) ? 0 : used;
}

static void insert_alloc_stack(AsmInstrList **head, int bytes) {
    if (bytes <= 0) return;
    // Make a new node
    AsmInstrList *node = malloc(sizeof(*node));
    node->instr = new_alloc_stack(bytes);
    node->next  = *head;
    *head = node;
}

static void fix_memory_to_memory(AsmInstrList *head) {
    AsmInstrList *cur = head;
    while (cur) {
        if (cur->instr.type == ASM_MOV) {
            AsmOperand s = cur->instr.mov.src;
            AsmOperand d = cur->instr.mov.dst;

            if (s.kind == OP_STACK && d.kind == OP_STACK) {
                // current node becomes: movl [src], %r10d
                cur->instr.mov.src = s; // same
                cur->instr.mov.dst.kind = OP_REG;
                cur->instr.mov.dst.reg  = REG_R10;

                // create a new node after it => movl %r10d, [dst]
                AsmInstrList *extra = malloc(sizeof(*extra));
                extra->instr = new_mov(
                    (AsmOperand){.kind=OP_REG, .reg=REG_R10},
                    (AsmOperand){.kind=OP_STACK, .offset=d.offset}
                );
                extra->next = cur->next;
                cur->next = extra;

                // skip past the newly inserted node
                cur = extra;
            }
        }
        cur = cur ? cur->next : NULL;
    }
}

void finalize_asm(AsmInstrList **alist) {
    // 1) Replace pseudo => stack
    int total = replace_pseudoregs_in_list(*alist);

    // 2) Insert subq $N, %rsp at front
    insert_alloc_stack(alist, total);

    // 3) Rewrite any memory->memory mov
    fix_memory_to_memory(*alist);
}

// Helper to print a single AsmOperand in AT&T syntax
static void emit_operand(const AsmOperand *op) {
    switch (op->kind) {
        case OP_IMM:
            printf("$%d", op->imm);       // e.g. $2
            break;
        case OP_REG:
            if (op->reg == REG_AX)  printf("%%eax");
            else                    printf("%%r10d");
            break;
        case OP_STACK:
            // e.g. -4(%rbp)
            printf("%d(%%rbp)", op->offset);
            break;
        case OP_PSEUDO:
            // Should never exist here if you replaced pseudoregs
            printf("<pseudo:%s>", op->pseudo);
            break;
    }
}


void emit_asm_function(const char *funcName, const AsmInstrList *list) {
    // 1) Print a global symbol and label
    printf(".globl %s\n", funcName);
    printf("%s:\n", funcName);

    // 2) Function prologue
    printf("  pushq %%rbp\n");
    printf("  movq %%rsp, %%rbp\n");

    // 3) Now walk the instructions
    for (; list; list = list->next) {
        const AsmInstr *ins = &list->instr;
        switch (ins->type) {
            case ASM_ALLOCATE_STACK:
                // subq $n, %rsp
                printf("  subq $%d, %%rsp\n", ins->alloc.bytes);
                break;

            case ASM_MOV:
                // movl src, dst
                printf("  movl ");
                emit_operand(&ins->mov.src);
                printf(", ");
                emit_operand(&ins->mov.dst);
                printf("\n");
                break;

            case ASM_UNARY:
                // notl or negl <operand>
                if (ins->unary.op == UNARY_NOT) {
                    printf("  notl ");
                } else { 
                    // UNARY_NEG
                    printf("  negl ");
                }
                emit_operand(&ins->unary.operand);
                printf("\n");
                break;

            case ASM_RET:
                // 4) Epilogue for 'Ret'
                printf("  movq %%rbp, %%rsp\n");
                printf("  popq %%rbp\n");
                printf("  ret\n");
                break;
        }
    }
}
