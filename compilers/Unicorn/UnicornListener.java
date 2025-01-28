// Generated from Unicorn.g4 by ANTLR 4.13.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link UnicornParser}.
 */
public interface UnicornListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link UnicornParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(UnicornParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(UnicornParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(UnicornParser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(UnicornParser.StatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#variableDeclaration}.
	 * @param ctx the parse tree
	 */
	void enterVariableDeclaration(UnicornParser.VariableDeclarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#variableDeclaration}.
	 * @param ctx the parse tree
	 */
	void exitVariableDeclaration(UnicornParser.VariableDeclarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#functionDeclaration}.
	 * @param ctx the parse tree
	 */
	void enterFunctionDeclaration(UnicornParser.FunctionDeclarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#functionDeclaration}.
	 * @param ctx the parse tree
	 */
	void exitFunctionDeclaration(UnicornParser.FunctionDeclarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#ifStatement}.
	 * @param ctx the parse tree
	 */
	void enterIfStatement(UnicornParser.IfStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#ifStatement}.
	 * @param ctx the parse tree
	 */
	void exitIfStatement(UnicornParser.IfStatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#whileStatement}.
	 * @param ctx the parse tree
	 */
	void enterWhileStatement(UnicornParser.WhileStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#whileStatement}.
	 * @param ctx the parse tree
	 */
	void exitWhileStatement(UnicornParser.WhileStatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#returnStatement}.
	 * @param ctx the parse tree
	 */
	void enterReturnStatement(UnicornParser.ReturnStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#returnStatement}.
	 * @param ctx the parse tree
	 */
	void exitReturnStatement(UnicornParser.ReturnStatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#expressionStatement}.
	 * @param ctx the parse tree
	 */
	void enterExpressionStatement(UnicornParser.ExpressionStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#expressionStatement}.
	 * @param ctx the parse tree
	 */
	void exitExpressionStatement(UnicornParser.ExpressionStatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression(UnicornParser.ExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression(UnicornParser.ExpressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#assignment}.
	 * @param ctx the parse tree
	 */
	void enterAssignment(UnicornParser.AssignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#assignment}.
	 * @param ctx the parse tree
	 */
	void exitAssignment(UnicornParser.AssignmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#equality}.
	 * @param ctx the parse tree
	 */
	void enterEquality(UnicornParser.EqualityContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#equality}.
	 * @param ctx the parse tree
	 */
	void exitEquality(UnicornParser.EqualityContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#comparison}.
	 * @param ctx the parse tree
	 */
	void enterComparison(UnicornParser.ComparisonContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#comparison}.
	 * @param ctx the parse tree
	 */
	void exitComparison(UnicornParser.ComparisonContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#term}.
	 * @param ctx the parse tree
	 */
	void enterTerm(UnicornParser.TermContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#term}.
	 * @param ctx the parse tree
	 */
	void exitTerm(UnicornParser.TermContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#factor}.
	 * @param ctx the parse tree
	 */
	void enterFactor(UnicornParser.FactorContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#factor}.
	 * @param ctx the parse tree
	 */
	void exitFactor(UnicornParser.FactorContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#unary}.
	 * @param ctx the parse tree
	 */
	void enterUnary(UnicornParser.UnaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#unary}.
	 * @param ctx the parse tree
	 */
	void exitUnary(UnicornParser.UnaryContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#primary}.
	 * @param ctx the parse tree
	 */
	void enterPrimary(UnicornParser.PrimaryContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#primary}.
	 * @param ctx the parse tree
	 */
	void exitPrimary(UnicornParser.PrimaryContext ctx);
	/**
	 * Enter a parse tree produced by {@link UnicornParser#block}.
	 * @param ctx the parse tree
	 */
	void enterBlock(UnicornParser.BlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link UnicornParser#block}.
	 * @param ctx the parse tree
	 */
	void exitBlock(UnicornParser.BlockContext ctx);
}