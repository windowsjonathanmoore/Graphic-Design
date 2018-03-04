// Generated from set\antlr4\SET.g4 by ANTLR 4.1
package set.antlr4;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link SETParser}.
 */
public interface SETListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link SETParser#identifierFunctionCall}.
	 * @param ctx the parse tree
	 */
	void enterIdentifierFunctionCall(@NotNull SETParser.IdentifierFunctionCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#identifierFunctionCall}.
	 * @param ctx the parse tree
	 */
	void exitIdentifierFunctionCall(@NotNull SETParser.IdentifierFunctionCallContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#divideExpression}.
	 * @param ctx the parse tree
	 */
	void enterDivideExpression(@NotNull SETParser.DivideExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#divideExpression}.
	 * @param ctx the parse tree
	 */
	void exitDivideExpression(@NotNull SETParser.DivideExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#modulusExpression}.
	 * @param ctx the parse tree
	 */
	void enterModulusExpression(@NotNull SETParser.ModulusExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#modulusExpression}.
	 * @param ctx the parse tree
	 */
	void exitModulusExpression(@NotNull SETParser.ModulusExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#forStatement}.
	 * @param ctx the parse tree
	 */
	void enterForStatement(@NotNull SETParser.ForStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#forStatement}.
	 * @param ctx the parse tree
	 */
	void exitForStatement(@NotNull SETParser.ForStatementContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#eqExpression}.
	 * @param ctx the parse tree
	 */
	void enterEqExpression(@NotNull SETParser.EqExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#eqExpression}.
	 * @param ctx the parse tree
	 */
	void exitEqExpression(@NotNull SETParser.EqExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#addExpression}.
	 * @param ctx the parse tree
	 */
	void enterAddExpression(@NotNull SETParser.AddExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#addExpression}.
	 * @param ctx the parse tree
	 */
	void exitAddExpression(@NotNull SETParser.AddExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#sizeFunctionCall}.
	 * @param ctx the parse tree
	 */
	void enterSizeFunctionCall(@NotNull SETParser.SizeFunctionCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#sizeFunctionCall}.
	 * @param ctx the parse tree
	 */
	void exitSizeFunctionCall(@NotNull SETParser.SizeFunctionCallContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#block}.
	 * @param ctx the parse tree
	 */
	void enterBlock(@NotNull SETParser.BlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#block}.
	 * @param ctx the parse tree
	 */
	void exitBlock(@NotNull SETParser.BlockContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#orExpression}.
	 * @param ctx the parse tree
	 */
	void enterOrExpression(@NotNull SETParser.OrExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#orExpression}.
	 * @param ctx the parse tree
	 */
	void exitOrExpression(@NotNull SETParser.OrExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#powerExpression}.
	 * @param ctx the parse tree
	 */
	void enterPowerExpression(@NotNull SETParser.PowerExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#powerExpression}.
	 * @param ctx the parse tree
	 */
	void exitPowerExpression(@NotNull SETParser.PowerExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#idList}.
	 * @param ctx the parse tree
	 */
	void enterIdList(@NotNull SETParser.IdListContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#idList}.
	 * @param ctx the parse tree
	 */
	void exitIdList(@NotNull SETParser.IdListContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#andExpression}.
	 * @param ctx the parse tree
	 */
	void enterAndExpression(@NotNull SETParser.AndExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#andExpression}.
	 * @param ctx the parse tree
	 */
	void exitAndExpression(@NotNull SETParser.AndExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#boolExpression}.
	 * @param ctx the parse tree
	 */
	void enterBoolExpression(@NotNull SETParser.BoolExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#boolExpression}.
	 * @param ctx the parse tree
	 */
	void exitBoolExpression(@NotNull SETParser.BoolExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#ltExpression}.
	 * @param ctx the parse tree
	 */
	void enterLtExpression(@NotNull SETParser.LtExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#ltExpression}.
	 * @param ctx the parse tree
	 */
	void exitLtExpression(@NotNull SETParser.LtExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#expressionExpression}.
	 * @param ctx the parse tree
	 */
	void enterExpressionExpression(@NotNull SETParser.ExpressionExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#expressionExpression}.
	 * @param ctx the parse tree
	 */
	void exitExpressionExpression(@NotNull SETParser.ExpressionExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#nullExpression}.
	 * @param ctx the parse tree
	 */
	void enterNullExpression(@NotNull SETParser.NullExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#nullExpression}.
	 * @param ctx the parse tree
	 */
	void exitNullExpression(@NotNull SETParser.NullExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#parse}.
	 * @param ctx the parse tree
	 */
	void enterParse(@NotNull SETParser.ParseContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#parse}.
	 * @param ctx the parse tree
	 */
	void exitParse(@NotNull SETParser.ParseContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#ltEqExpression}.
	 * @param ctx the parse tree
	 */
	void enterLtEqExpression(@NotNull SETParser.LtEqExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#ltEqExpression}.
	 * @param ctx the parse tree
	 */
	void exitLtEqExpression(@NotNull SETParser.LtEqExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#inputExpression}.
	 * @param ctx the parse tree
	 */
	void enterInputExpression(@NotNull SETParser.InputExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#inputExpression}.
	 * @param ctx the parse tree
	 */
	void exitInputExpression(@NotNull SETParser.InputExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#exprList}.
	 * @param ctx the parse tree
	 */
	void enterExprList(@NotNull SETParser.ExprListContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#exprList}.
	 * @param ctx the parse tree
	 */
	void exitExprList(@NotNull SETParser.ExprListContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#stringExpression}.
	 * @param ctx the parse tree
	 */
	void enterStringExpression(@NotNull SETParser.StringExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#stringExpression}.
	 * @param ctx the parse tree
	 */
	void exitStringExpression(@NotNull SETParser.StringExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#printlnFunctionCall}.
	 * @param ctx the parse tree
	 */
	void enterPrintlnFunctionCall(@NotNull SETParser.PrintlnFunctionCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#printlnFunctionCall}.
	 * @param ctx the parse tree
	 */
	void exitPrintlnFunctionCall(@NotNull SETParser.PrintlnFunctionCallContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#elseIfStat}.
	 * @param ctx the parse tree
	 */
	void enterElseIfStat(@NotNull SETParser.ElseIfStatContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#elseIfStat}.
	 * @param ctx the parse tree
	 */
	void exitElseIfStat(@NotNull SETParser.ElseIfStatContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#identifierExpression}.
	 * @param ctx the parse tree
	 */
	void enterIdentifierExpression(@NotNull SETParser.IdentifierExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#identifierExpression}.
	 * @param ctx the parse tree
	 */
	void exitIdentifierExpression(@NotNull SETParser.IdentifierExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#indexes}.
	 * @param ctx the parse tree
	 */
	void enterIndexes(@NotNull SETParser.IndexesContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#indexes}.
	 * @param ctx the parse tree
	 */
	void exitIndexes(@NotNull SETParser.IndexesContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#gtEqExpression}.
	 * @param ctx the parse tree
	 */
	void enterGtEqExpression(@NotNull SETParser.GtEqExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#gtEqExpression}.
	 * @param ctx the parse tree
	 */
	void exitGtEqExpression(@NotNull SETParser.GtEqExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#notExpression}.
	 * @param ctx the parse tree
	 */
	void enterNotExpression(@NotNull SETParser.NotExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#notExpression}.
	 * @param ctx the parse tree
	 */
	void exitNotExpression(@NotNull SETParser.NotExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#elseStat}.
	 * @param ctx the parse tree
	 */
	void enterElseStat(@NotNull SETParser.ElseStatContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#elseStat}.
	 * @param ctx the parse tree
	 */
	void exitElseStat(@NotNull SETParser.ElseStatContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#list}.
	 * @param ctx the parse tree
	 */
	void enterList(@NotNull SETParser.ListContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#list}.
	 * @param ctx the parse tree
	 */
	void exitList(@NotNull SETParser.ListContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#notEqExpression}.
	 * @param ctx the parse tree
	 */
	void enterNotEqExpression(@NotNull SETParser.NotEqExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#notEqExpression}.
	 * @param ctx the parse tree
	 */
	void exitNotEqExpression(@NotNull SETParser.NotEqExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#subtractExpression}.
	 * @param ctx the parse tree
	 */
	void enterSubtractExpression(@NotNull SETParser.SubtractExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#subtractExpression}.
	 * @param ctx the parse tree
	 */
	void exitSubtractExpression(@NotNull SETParser.SubtractExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#ternaryExpression}.
	 * @param ctx the parse tree
	 */
	void enterTernaryExpression(@NotNull SETParser.TernaryExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#ternaryExpression}.
	 * @param ctx the parse tree
	 */
	void exitTernaryExpression(@NotNull SETParser.TernaryExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#multiplyExpression}.
	 * @param ctx the parse tree
	 */
	void enterMultiplyExpression(@NotNull SETParser.MultiplyExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#multiplyExpression}.
	 * @param ctx the parse tree
	 */
	void exitMultiplyExpression(@NotNull SETParser.MultiplyExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#gtExpression}.
	 * @param ctx the parse tree
	 */
	void enterGtExpression(@NotNull SETParser.GtExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#gtExpression}.
	 * @param ctx the parse tree
	 */
	void exitGtExpression(@NotNull SETParser.GtExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#ifStatement}.
	 * @param ctx the parse tree
	 */
	void enterIfStatement(@NotNull SETParser.IfStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#ifStatement}.
	 * @param ctx the parse tree
	 */
	void exitIfStatement(@NotNull SETParser.IfStatementContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#functionDecl}.
	 * @param ctx the parse tree
	 */
	void enterFunctionDecl(@NotNull SETParser.FunctionDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#functionDecl}.
	 * @param ctx the parse tree
	 */
	void exitFunctionDecl(@NotNull SETParser.FunctionDeclContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(@NotNull SETParser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(@NotNull SETParser.StatementContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#inExpression}.
	 * @param ctx the parse tree
	 */
	void enterInExpression(@NotNull SETParser.InExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#inExpression}.
	 * @param ctx the parse tree
	 */
	void exitInExpression(@NotNull SETParser.InExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#assignment}.
	 * @param ctx the parse tree
	 */
	void enterAssignment(@NotNull SETParser.AssignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#assignment}.
	 * @param ctx the parse tree
	 */
	void exitAssignment(@NotNull SETParser.AssignmentContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#whileStatement}.
	 * @param ctx the parse tree
	 */
	void enterWhileStatement(@NotNull SETParser.WhileStatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#whileStatement}.
	 * @param ctx the parse tree
	 */
	void exitWhileStatement(@NotNull SETParser.WhileStatementContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#ifStat}.
	 * @param ctx the parse tree
	 */
	void enterIfStat(@NotNull SETParser.IfStatContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#ifStat}.
	 * @param ctx the parse tree
	 */
	void exitIfStat(@NotNull SETParser.IfStatContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#unaryMinusExpression}.
	 * @param ctx the parse tree
	 */
	void enterUnaryMinusExpression(@NotNull SETParser.UnaryMinusExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#unaryMinusExpression}.
	 * @param ctx the parse tree
	 */
	void exitUnaryMinusExpression(@NotNull SETParser.UnaryMinusExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#printFunctionCall}.
	 * @param ctx the parse tree
	 */
	void enterPrintFunctionCall(@NotNull SETParser.PrintFunctionCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#printFunctionCall}.
	 * @param ctx the parse tree
	 */
	void exitPrintFunctionCall(@NotNull SETParser.PrintFunctionCallContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#functionCallExpression}.
	 * @param ctx the parse tree
	 */
	void enterFunctionCallExpression(@NotNull SETParser.FunctionCallExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#functionCallExpression}.
	 * @param ctx the parse tree
	 */
	void exitFunctionCallExpression(@NotNull SETParser.FunctionCallExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#numberExpression}.
	 * @param ctx the parse tree
	 */
	void enterNumberExpression(@NotNull SETParser.NumberExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#numberExpression}.
	 * @param ctx the parse tree
	 */
	void exitNumberExpression(@NotNull SETParser.NumberExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#listExpression}.
	 * @param ctx the parse tree
	 */
	void enterListExpression(@NotNull SETParser.ListExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#listExpression}.
	 * @param ctx the parse tree
	 */
	void exitListExpression(@NotNull SETParser.ListExpressionContext ctx);

	/**
	 * Enter a parse tree produced by {@link SETParser#assertFunctionCall}.
	 * @param ctx the parse tree
	 */
	void enterAssertFunctionCall(@NotNull SETParser.AssertFunctionCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link SETParser#assertFunctionCall}.
	 * @param ctx the parse tree
	 */
	void exitAssertFunctionCall(@NotNull SETParser.AssertFunctionCallContext ctx);
}