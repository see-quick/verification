// Generated from Unicorn.g4 by ANTLR 4.13.2
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link UnicornParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface UnicornVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link UnicornParser#program}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram(UnicornParser.ProgramContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement(UnicornParser.StatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#variableDeclaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaration(UnicornParser.VariableDeclarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#functionDeclaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionDeclaration(UnicornParser.FunctionDeclarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#ifStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfStatement(UnicornParser.IfStatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#whileStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWhileStatement(UnicornParser.WhileStatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#returnStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReturnStatement(UnicornParser.ReturnStatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#expressionStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpressionStatement(UnicornParser.ExpressionStatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression(UnicornParser.ExpressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment(UnicornParser.AssignmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#equality}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEquality(UnicornParser.EqualityContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#comparison}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitComparison(UnicornParser.ComparisonContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#term}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTerm(UnicornParser.TermContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#factor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFactor(UnicornParser.FactorContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#unary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnary(UnicornParser.UnaryContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#primary}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrimary(UnicornParser.PrimaryContext ctx);
	/**
	 * Visit a parse tree produced by {@link UnicornParser#block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock(UnicornParser.BlockContext ctx);
}