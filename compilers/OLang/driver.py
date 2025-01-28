from antlr4 import *
from OLangLexer import OLangLexer
from OLangParser import OLangParser
from AssemblyCodeGenVisitor import AssemblyCodeGenVisitor

def main():
    """
    Main function to parse an OLang expression and generate x86 assembly code.
    """
    input_expr = "3 + 5"  # Example expression
    input_stream = InputStream(input_expr)

    # Lexical and syntax analysis
    lexer = OLangLexer(input_stream)
    tokens = CommonTokenStream(lexer)
    parser = OLangParser(tokens)
    tree = parser.prog()

    # Generate assembly code
    codegen_visitor = AssemblyCodeGenVisitor()
    codegen_visitor.visit(tree)

    # Print the generated assembly code
    print("; Generated x86 Assembly Code")
    print(codegen_visitor.get_assembly_code())

if __name__ == "__main__":
    main()
