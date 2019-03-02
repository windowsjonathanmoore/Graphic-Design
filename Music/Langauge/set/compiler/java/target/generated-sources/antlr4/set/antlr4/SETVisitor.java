// Generated from set\antlr4\SET.g4 by ANTLR 4.1
package set.antlr4;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link SETParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface SETVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link SETParser#identifierFunctionCall}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdentifierFunctionCall(@NotNull SETParser.IdentifierFunctionCallContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#divideExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDivideExpression(@NotNull SETParser.DivideExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#modulusExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModulusExpression(@NotNull SETParser.ModulusExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#forStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForStatement(@NotNull SETParser.ForStatementContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#eqExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEqExpression(@NotNull SETParser.EqExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#addExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddExpression(@NotNull SETParser.AddExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#sizeFunctionCall}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSizeFunctionCall(@NotNull SETParser.SizeFunctionCallContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock(@NotNull SETParser.BlockContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#orExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOrExpression(@NotNull SETParser.OrExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#powerExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPowerExpression(@NotNull SETParser.PowerExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#idList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdList(@NotNull SETParser.IdListContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#andExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAndExpression(@NotNull SETParser.AndExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#boolExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBoolExpression(@NotNull SETParser.BoolExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#ltExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLtExpression(@NotNull SETParser.LtExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#expressionExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpressionExpression(@NotNull SETParser.ExpressionExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#nullExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNullExpression(@NotNull SETParser.NullExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#parse}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParse(@NotNull SETParser.ParseContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#ltEqExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLtEqExpression(@NotNull SETParser.LtEqExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#inputExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInputExpression(@NotNull SETParser.InputExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#exprList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprList(@NotNull SETParser.ExprListContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#stringExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStringExpression(@NotNull SETParser.StringExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#printlnFunctionCall}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrintlnFunctionCall(@NotNull SETParser.PrintlnFunctionCallContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#elseIfStat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElseIfStat(@NotNull SETParser.ElseIfStatContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#identifierExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdentifierExpression(@NotNull SETParser.IdentifierExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#indexes}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIndexes(@NotNull SETParser.IndexesContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#gtEqExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGtEqExpression(@NotNull SETParser.GtEqExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#notExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNotExpression(@NotNull SETParser.NotExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#elseStat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElseStat(@NotNull SETParser.ElseStatContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#list}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitList(@NotNull SETParser.ListContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#notEqExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNotEqExpression(@NotNull SETParser.NotEqExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#subtractExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSubtractExpression(@NotNull SETParser.SubtractExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#ternaryExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTernaryExpression(@NotNull SETParser.TernaryExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#multiplyExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMultiplyExpression(@NotNull SETParser.MultiplyExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#gtExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitGtExpression(@NotNull SETParser.GtExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#ifStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfStatement(@NotNull SETParser.IfStatementContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#functionDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionDecl(@NotNull SETParser.FunctionDeclContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement(@NotNull SETParser.StatementContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#inExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInExpression(@NotNull SETParser.InExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#assignment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignment(@NotNull SETParser.AssignmentContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#whileStatement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWhileStatement(@NotNull SETParser.WhileStatementContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#ifStat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfStat(@NotNull SETParser.IfStatContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#unaryMinusExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUnaryMinusExpression(@NotNull SETParser.UnaryMinusExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#printFunctionCall}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrintFunctionCall(@NotNull SETParser.PrintFunctionCallContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#functionCallExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionCallExpression(@NotNull SETParser.FunctionCallExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#numberExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNumberExpression(@NotNull SETParser.NumberExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#listExpression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitListExpression(@NotNull SETParser.ListExpressionContext ctx);

	/**
	 * Visit a parse tree produced by {@link SETParser#assertFunctionCall}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertFunctionCall(@NotNull SETParser.AssertFunctionCallContext ctx);
}