from OLangVisitor import OLangVisitor
from OLangParser import OLangParser

class AssemblyCodeGenVisitor(OLangVisitor):
    """
    Visitor class to generate x86 assembly code for arithmetic expressions.
    Traverses the parse tree and emits assembly using a stack-based approach.
    """

    def __init__(self):
        self.assembly_code = []

    def add_instruction(self, instruction: str):
        self.assembly_code.append(instruction)

    def visitExpr(self, ctx: OLangParser.ExprContext):
        child_count = ctx.getChildCount()

        # Binary operation: expr op expr
        if child_count == 3:
            # Visit left (expr) and right (expr)
            self.visit(ctx.getChild(0))
            self.visit(ctx.getChild(2))
            operator = ctx.getChild(1).getText()

            # Pop right, pop left
            self.add_instruction("POP EBX")
            self.add_instruction("POP EAX")

            if operator == "+":
                self.add_instruction("ADD EAX, EBX")
            elif operator == "-":
                self.add_instruction("SUB EAX, EBX")
            elif operator == "*":
                self.add_instruction("IMUL EAX, EBX")
            elif operator == "/":
                self.add_instruction("IDIV EBX")

            self.add_instruction("PUSH EAX")
            return "stack"

        # Single child: could be INT or '(' expr ')'
        elif child_count == 1:
            token_text = ctx.getChild(0).getText()

            # If it's digits, handle as INT
            if token_text.isdigit():
                self.add_instruction(f"MOV EAX, {token_text}")
                self.add_instruction("PUSH EAX")
                return "stack"
            else:
                # e.g., might be variables or other constructs if extended
                # For now, do nothing or raise an error
                pass

        # Parenthesized expression: '(' expr ')'
        # Actually child_count=3, but the middle child is expr
        # and the first/last children are '(' and ')'.
        # The existing logic covers it (the top if-statement sees 3 children).
        # But if you want to be explicit, you could:
        # elif child_count == 3 and ctx.getChild(0).getText() == '(':
        #    return self.visit(ctx.getChild(1))

        return super().visitChildren(ctx)

    def get_assembly_code(self):
        return "\n".join(self.assembly_code)
