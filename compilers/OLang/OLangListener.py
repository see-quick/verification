# Generated from OLang.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .OLangParser import OLangParser
else:
    from OLangParser import OLangParser

# This class defines a complete listener for a parse tree produced by OLangParser.
class OLangListener(ParseTreeListener):

    # Enter a parse tree produced by OLangParser#prog.
    def enterProg(self, ctx:OLangParser.ProgContext):
        pass

    # Exit a parse tree produced by OLangParser#prog.
    def exitProg(self, ctx:OLangParser.ProgContext):
        pass


    # Enter a parse tree produced by OLangParser#expr.
    def enterExpr(self, ctx:OLangParser.ExprContext):
        pass

    # Exit a parse tree produced by OLangParser#expr.
    def exitExpr(self, ctx:OLangParser.ExprContext):
        pass



del OLangParser