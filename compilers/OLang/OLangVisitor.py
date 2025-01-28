# Generated from OLang.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .OLangParser import OLangParser
else:
    from OLangParser import OLangParser

# This class defines a complete generic visitor for a parse tree produced by OLangParser.

class OLangVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by OLangParser#prog.
    def visitProg(self, ctx:OLangParser.ProgContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by OLangParser#expr.
    def visitExpr(self, ctx:OLangParser.ExprContext):
        return self.visitChildren(ctx)



del OLangParser