#include "tacky.h"

static int temp_counter = 0;

void add_tacky_instr(TackyInstrList **list, TackyInstr instr) {
  TackyInstrList *new_node = malloc(sizeof(TackyInstrList));
  new_node->instr = instr;
  new_node->next = NULL;

  if (*list == NULL) {
    // First node
    *list = new_node;
  } else {
    // Walk to the end
    TackyInstrList *cur = *list;
    while (cur->next) {
      cur = cur->next;
    }
    cur->next = new_node;
  }
}

static void print_val(TackyVal v) {
  if (v.type == TACKY_VAL_CONST) {
    printf("Constant(%d)", v.constant);
  } else {
    printf("Var(%s)", v.var);
  }
}

void print_tacky(TackyInstrList *list) {
  while (list) {
    if (list->instr.type == TACKY_RETURN) {
      printf("Return(");
      print_val(list->instr.return_instr.val);
      printf(")\n");
    } else if (list->instr.type == TACKY_UNARY) {
      printf("Unary(");
      if (list->instr.unary_instr.op == UNARY_NEGATE) {
        printf("Negate, ");
      } else {
        printf("Complement, ");
      }
      print_val(list->instr.unary_instr.src);
      printf(", ");
      print_val(list->instr.unary_instr.dst);
      printf(")\n");
    }
    list = list->next;
  }
}

/**
 * Generates a unique temporary variable name.
 */
const char *generate_temp_var(void) {
  static char buffer[32];
  snprintf(buffer, sizeof(buffer), "tmp.%d", temp_counter++);
  return buffer;
}
