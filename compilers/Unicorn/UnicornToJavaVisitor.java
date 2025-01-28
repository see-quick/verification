public class UnicornToJavaVisitor extends UnicornBaseVisitor<String> {

    private StringBuilder javaCode = new StringBuilder();

    @Override
    public String visitProgram(UnicornParser.ProgramContext ctx) {
        javaCode.append("public class GeneratedProgram {\n");
        for (UnicornParser.StatementContext stmt : ctx.statement()) {
            javaCode.append(visit(stmt)).append("\n");
        }
        javaCode.append("public static void main(String[] args) {\n");
        javaCode.append("    System.out.println(main());\n");
        javaCode.append("}\n");
        javaCode.append("}");
        return javaCode.toString();
    }

    @Override
    public String visitFunctionDeclaration(UnicornParser.FunctionDeclarationContext ctx) {
    	// Get the function name (the first IDENTIFIER in the rule)
    	String functionName = ctx.IDENTIFIER(0).getText();

    	// Get the parameters (subsequent IDENTIFIERs after the first)
    	StringBuilder params = new StringBuilder();
    	for (int i = 1; i < ctx.IDENTIFIER().size(); i++) {
        	if (i > 1) params.append(", "); // Add a comma between parameters
        	params.append("int ").append(ctx.IDENTIFIER(i).getText());
    	}

    	// Get the function body (block)
    	String body = visit(ctx.block());

   	 // Return the complete function declaration
    	return String.format("public static int %s(%s) %s", functionName, params, body);
    }

    @Override
    public String visitBlock(UnicornParser.BlockContext ctx) {
        StringBuilder blockCode = new StringBuilder("{\n");
        for (UnicornParser.StatementContext stmt : ctx.statement()) {
            blockCode.append(visit(stmt)).append("\n");
        }
        blockCode.append("}");
        return blockCode.toString();
    }

    @Override
    public String visitVariableDeclaration(UnicornParser.VariableDeclarationContext ctx) {
        String varName = ctx.IDENTIFIER().getText();
        String value = ctx.expression() != null ? visit(ctx.expression()) : "0";
        return String.format("int %s = %s;", varName, value);
    }

    @Override
    public String visitReturnStatement(UnicornParser.ReturnStatementContext ctx) {
        return "return " + visit(ctx.expression()) + ";";
    }

    @Override
    public String visitWhileStatement(UnicornParser.WhileStatementContext ctx) {
        String condition = visit(ctx.expression());
        String body = visit(ctx.block());
        return String.format("while (%s) %s", condition, body);
    }

    @Override
    public String visitExpression(UnicornParser.ExpressionContext ctx) {
        return ctx.getText(); // Simplified expression handling
    }
}
