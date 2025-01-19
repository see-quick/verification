from OLangParser import OLangParser
from OLangVisitor import OLangVisitor

class EvalVisitor(OLangVisitor):
    def visitInt(self, ctx: OLangParser.IntContext):
        return int(ctx.getText())  # Return integer value

    def visitExpr(self, ctx: OLangParser.ExprContext):
        if ctx.getChildCount() == 3:  # Binary operation
            left = self.visit(ctx.getChild(0))
            right = self.visit(ctx.getChild(2))
            op = ctx.getChild(1).getText()
            if op == '+':
                return left + right
            elif op == '-':
                return left - right
            elif op == '*':
                return left * right
            elif op == '/':
                return left / right
        elif ctx.getChildCount() == 1:  # Single operand (e.g., INT)
            return self.visit(ctx.getChild(0))
