#include "EvalVisitor.h"
#include "TLValue.h"
#include "ReturnValue.h"
#include "Scope.h"
#include "Function.h"
#include "EvalException.h"

namespace tl
{
	namespace antlr4
	{
		using org::antlr::v4::runtime::ParserRuleContext;
		using org::antlr::v4::runtime::misc::NotNull;
		using org::antlr::v4::runtime::tree::TerminalNode;
		using tl::antlr4::TLParser::AndExpressionContext;
		using tl::antlr4::TLParser::AssertFunctionCallContext;
		using tl::antlr4::TLParser::BlockContext;
		using tl::antlr4::TLParser::DivideExpressionContext;
		using tl::antlr4::TLParser::ExpressionContext;
		using tl::antlr4::TLParser::ExpressionExpressionContext;
		using tl::antlr4::TLParser::ForStatementContext;
		using tl::antlr4::TLParser::FunctionCallExpressionContext;
		using tl::antlr4::TLParser::FunctionDeclContext;
		using tl::antlr4::TLParser::GtEqExpressionContext;
		using tl::antlr4::TLParser::GtExpressionContext;
		using tl::antlr4::TLParser::IdentifierFunctionCallContext;
		using tl::antlr4::TLParser::InExpressionContext;
		using tl::antlr4::TLParser::InputExpressionContext;
		using tl::antlr4::TLParser::ListContext;
		using tl::antlr4::TLParser::ListExpressionContext;
		using tl::antlr4::TLParser::LtEqExpressionContext;
		using tl::antlr4::TLParser::LtExpressionContext;
		using tl::antlr4::TLParser::ModulusExpressionContext;
		using tl::antlr4::TLParser::MultiplyExpressionContext;
		using tl::antlr4::TLParser::NotExpressionContext;
		using tl::antlr4::TLParser::OrExpressionContext;
		using tl::antlr4::TLParser::PowerExpressionContext;
		using tl::antlr4::TLParser::SizeFunctionCallContext;
		using tl::antlr4::TLParser::StatementContext;
		using tl::antlr4::TLParser::SubtractExpressionContext;
		using tl::antlr4::TLParser::TernaryExpressionContext;
		using tl::antlr4::TLParser::UnaryMinusExpressionContext;
		using tl::antlr4::TLParser::WhileStatementContext;
ReturnValue *EvalVisitor::returnValue = new ReturnValue();

		EvalVisitor::EvalVisitor(Scope *scope, std::unordered_map<std::wstring, Function*> &functions)
		{
			this->scope = scope;
			this->functions = functions;
		}

		TLValue *EvalVisitor::visitFunctionDecl(FunctionDeclContext *ctx)
		{
			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitList(ListContext *ctx)
		{
			std::vector<TLValue*> list;
			if (ctx->exprList() != nullptr)
			{
				for (ExpressionContext *ex : ctx->exprList().expression())
				{
					list.push_back(this->visit(ex));
				}
			}
			return new TLValue(list);
		}

		TLValue *EvalVisitor::visitUnaryMinusExpression(UnaryMinusExpressionContext *ctx)
		{
			TLValue *v = this->visit(ctx->expression());
			if (!v->isNumber())
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}
			return new TLValue(-1 * v->asDouble());
		}

		TLValue *EvalVisitor::visitNotExpression(NotExpressionContext *ctx)
		{
			TLValue *v = this->visit(ctx->expression());
			if (!v->isBoolean())
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}
			return new TLValue(!v->asBoolean());
		}

		TLValue *EvalVisitor::visitPowerExpression(PowerExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(std::pow(lhs->asDouble(), rhs->asDouble()));
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

		TLValue *EvalVisitor::visitMultiplyExpression(MultiplyExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs == nullptr || rhs == nullptr)
			{
				System::err::println(std::wstring(L"lhs ") + lhs + std::wstring(L" rhs ") + rhs);
				EvalException tempVar(ctx);
				throw &tempVar;
			}

			// number * number
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() * rhs->asDouble());
			}

			// string * number
			if (lhs->isString() && rhs->isNumber())
			{
				StringBuilder *str = new StringBuilder();
				int stop = rhs->asDouble().value();
				for (int i = 0; i < stop; i++)
				{
					str->append(lhs->asString());
				}
				return new TLValue(str->toString());
			}

			// list * number
			if (lhs->isList() && rhs->isNumber())
			{
				std::vector<TLValue*> total;
				int stop = rhs->asDouble().value();
				for (int i = 0; i < stop; i++)
				{
					total.addAll(lhs->asList());
				}
				return new TLValue(total);
			}
			EvalException tempVar2(ctx);
			throw &tempVar2;
		}

		TLValue *EvalVisitor::visitDivideExpression(DivideExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() / rhs->asDouble());
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

		TLValue *EvalVisitor::visitModulusExpression(ModulusExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() % rhs->asDouble());
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitAddExpression(@NotNull TLParser.AddExpressionContext ctx)
		TLValue *EvalVisitor::visitAddExpression(TLParser::AddExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));

			if (lhs == nullptr || rhs == nullptr)
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}

			// number + number
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() + rhs->asDouble());
			}

			// list + any
			if (lhs->isList())
			{
				std::vector<TLValue*> &list = lhs->asList();
				list.push_back(rhs);
				return new TLValue(list);
			}

			// string + any
			if (lhs->isString())
			{
//JAVA TO C++ CONVERTER TODO TASK: There is no native C++ equivalent to 'toString':
				return new TLValue(lhs->asString() + std::wstring(L"") + rhs->toString());
			}

			// any + string
			if (rhs->isString())
			{
//JAVA TO C++ CONVERTER TODO TASK: There is no native C++ equivalent to 'toString':
				return new TLValue(lhs->toString() + std::wstring(L"") + rhs->asString());
			}

//JAVA TO C++ CONVERTER TODO TASK: There is no native C++ equivalent to 'toString':
			return new TLValue(lhs->toString() + rhs->toString());
		}

		TLValue *EvalVisitor::visitSubtractExpression(SubtractExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() - rhs->asDouble());
			}
			if (lhs->isList())
			{
				std::vector<TLValue*> &list = lhs->asList();
				list.erase(list.begin() + rhs);
				return new TLValue(list);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

		TLValue *EvalVisitor::visitGtEqExpression(GtEqExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() >= rhs->asDouble());
			}
			if (lhs->isString() && rhs->isString())
			{
				return new TLValue(lhs->asString().compare(rhs->asString()) >= 0);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

		TLValue *EvalVisitor::visitLtEqExpression(LtEqExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() <= rhs->asDouble());
			}
			if (lhs->isString() && rhs->isString())
			{
				return new TLValue(lhs->asString().compare(rhs->asString()) <= 0);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

		TLValue *EvalVisitor::visitGtExpression(GtExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() > rhs->asDouble());
			}
			if (lhs->isString() && rhs->isString())
			{
				return new TLValue(lhs->asString().compare(rhs->asString()) > 0);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

		TLValue *EvalVisitor::visitLtExpression(LtExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs->isNumber() && rhs->isNumber())
			{
				return new TLValue(lhs->asDouble() < rhs->asDouble());
			}
			if (lhs->isString() && rhs->isString())
			{
				return new TLValue(lhs->asString().compare(rhs->asString()) < 0);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitEqExpression(@NotNull TLParser.EqExpressionContext ctx)
		TLValue *EvalVisitor::visitEqExpression(TLParser::EqExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			if (lhs == nullptr)
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}
			return new TLValue(lhs->equals(rhs));
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitNotEqExpression(@NotNull TLParser.NotEqExpressionContext ctx)
		TLValue *EvalVisitor::visitNotEqExpression(TLParser::NotEqExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));
			return new TLValue(!lhs->equals(rhs));
		}

		TLValue *EvalVisitor::visitAndExpression(AndExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));

			if (!lhs->isBoolean() || !rhs->isBoolean())
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}
			return new TLValue(lhs->asBoolean() && rhs->asBoolean());
		}

		TLValue *EvalVisitor::visitOrExpression(OrExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));

			if (!lhs->isBoolean() || !rhs->isBoolean())
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}
			return new TLValue(lhs->asBoolean() || rhs->asBoolean());
		}

		TLValue *EvalVisitor::visitTernaryExpression(TernaryExpressionContext *ctx)
		{
			TLValue *condition = this->visit(ctx->expression(0));
			if (condition->asBoolean())
			{
				return new TLValue(this->visit(ctx->expression(1)));
			}
			else
			{
				return new TLValue(this->visit(ctx->expression(2)));
			}
		}

		TLValue *EvalVisitor::visitInExpression(InExpressionContext *ctx)
		{
			TLValue *lhs = this->visit(ctx->expression(0));
			TLValue *rhs = this->visit(ctx->expression(1));

			if (rhs->isList())
			{
				for (auto val : rhs->asList())
				{
					if (val->equals(lhs))
					{
						return new TLValue(true);
					}
				}
				return new TLValue(false);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitNumberExpression(@NotNull TLParser.NumberExpressionContext ctx)
		TLValue *EvalVisitor::visitNumberExpression(TLParser::NumberExpressionContext *ctx)
		{
			return new TLValue(static_cast<Double>(ctx->getText()));
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitBoolExpression(@NotNull TLParser.BoolExpressionContext ctx)
		TLValue *EvalVisitor::visitBoolExpression(TLParser::BoolExpressionContext *ctx)
		{
			return new TLValue(static_cast<Boolean>(ctx->getText()));
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitNullExpression(@NotNull TLParser.NullExpressionContext ctx)
		TLValue *EvalVisitor::visitNullExpression(TLParser::NullExpressionContext *ctx)
		{
			return TLValue::NULL;
		}

		TLValue *EvalVisitor::resolveIndexes(ParserRuleContext *ctx, TLValue *val, std::vector<ExpressionContext*> &indexes)
		{
			for (auto ec : indexes)
			{
				TLValue *idx = this->visit(ec);
				if (!idx->isNumber() || (!val->isList() && !val->isString()))
				{
					EvalException tempVar(std::wstring(L"Problem resolving indexes on ") + val + std::wstring(L" at ") + idx, ec);
					throw &tempVar;
				}
				int i = idx->asDouble().value();
				if (val->isString())
				{
					val = new TLValue(val->asString().substr(i, 1));
				}
				else
				{
					val = val->asList()[i];
				}
			}
			return val;
		}

		void EvalVisitor::setAtIndex(ParserRuleContext *ctx, std::vector<ExpressionContext*> &indexes, TLValue *val, TLValue *newVal)
		{
			if (!val->isList())
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}
			// TODO some more list size checking in here
			for (int i = 0; i < indexes.size() - 1; i++)
			{
				TLValue *idx = this->visit(indexes[i]);
				if (!idx->isNumber())
				{
					EvalException tempVar2(ctx);
					throw &tempVar2;
				}
				val = val->asList()[idx->asDouble().value()];
			}
			TLValue *idx = this->visit(indexes[indexes.size() - 1]);
			if (!idx->isNumber())
			{
				EvalException tempVar3(ctx);
				throw &tempVar3;
			}
			val->asList()[idx->asDouble().value()] = newVal;
		}

		TLValue *EvalVisitor::visitFunctionCallExpression(FunctionCallExpressionContext *ctx)
		{
			TLValue *val = this->visit(ctx->functionCall());
			if (ctx->indexes() != nullptr)
			{
				std::vector<ExpressionContext*> exps = ctx->indexes().expression();
				val = resolveIndexes(ctx, val, exps);
			}
			return val;
		}

		TLValue *EvalVisitor::visitListExpression(ListExpressionContext *ctx)
		{
			TLValue *val = this->visit(ctx->list());
			if (ctx->indexes() != nullptr)
			{
				std::vector<ExpressionContext*> exps = ctx->indexes().expression();
				val = resolveIndexes(ctx, val, exps);
			}
			return val;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitIdentifierExpression(@NotNull TLParser.IdentifierExpressionContext ctx)
		TLValue *EvalVisitor::visitIdentifierExpression(TLParser::IdentifierExpressionContext *ctx)
		{
			std::wstring id = ctx->Identifier().getText();
			TLValue *val = scope->resolve(id);

			if (ctx->indexes() != nullptr)
			{
				std::vector<ExpressionContext*> exps = ctx->indexes().expression();
				val = resolveIndexes(ctx, val, exps);
			}
			return val;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitStringExpression(@NotNull TLParser.StringExpressionContext ctx)
		TLValue *EvalVisitor::visitStringExpression(TLParser::StringExpressionContext *ctx)
		{
			std::wstring text = ctx->getText();
			text = text.substr(1, (text.length() - 1) - 1)->replaceAll(L"\\\\(.)", L"$1");
			TLValue *val = new TLValue(text);
			if (ctx->indexes() != nullptr)
			{
				std::vector<ExpressionContext*> exps = ctx->indexes().expression();
				val = resolveIndexes(ctx, val, exps);
			}
			return val;
		}

		TLValue *EvalVisitor::visitExpressionExpression(ExpressionExpressionContext *ctx)
		{
			TLValue *val = this->visit(ctx->expression());
			if (ctx->indexes() != nullptr)
			{
				std::vector<ExpressionContext*> exps = ctx->indexes().expression();
				val = resolveIndexes(ctx, val, exps);
			}
			return val;
		}

		TLValue *EvalVisitor::visitInputExpression(InputExpressionContext *ctx)
		{
			TerminalNode *inputString = ctx->String();
			try
			{
				if (inputString != nullptr)
				{
					std::wstring text = inputString->getText();
					text = text.substr(1, (text.length() - 1) - 1)->replaceAll(L"\\\\(.)", L"$1");
					return new TLValue(std::wstring(Files::readAllBytes(Paths->get(text))));
				}
				else
				{
					InputStreamReader tempVar(System::in);
					BufferedReader *buffer = new BufferedReader(&tempVar);
					return new TLValue(buffer->readLine());
				}
			}
			catch (IOException e)
			{
				std::exception tempVar2(e);
				throw &tempVar2;
			}
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitAssignment(@NotNull TLParser.AssignmentContext ctx)
		TLValue *EvalVisitor::visitAssignment(TLParser::AssignmentContext *ctx)
		{
			TLValue *newVal = this->visit(ctx->expression());
			if (ctx->indexes() != nullptr)
			{
				TLValue *val = scope->resolve(ctx->Identifier().getText());
				std::vector<ExpressionContext*> exps = ctx->indexes().expression();
				setAtIndex(ctx, exps, val, newVal);
			}
			else
			{
				std::wstring id = ctx->Identifier().getText();
				scope->assign(id, newVal);
			}
			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitIdentifierFunctionCall(IdentifierFunctionCallContext *ctx)
		{
			std::vector<ExpressionContext*> params = ctx->exprList() != nullptr ? ctx->exprList().expression() : std::vector<ExpressionContext*>();
			std::wstring id = ctx->Identifier().getText() + params.size();
			Function *function;
			if ((function = functions[id]) != nullptr)
			{
				return function->invoke(params, functions, scope);
			}
			EvalException tempVar(ctx);
			throw &tempVar;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitPrintlnFunctionCall(@NotNull TLParser.PrintlnFunctionCallContext ctx)
		TLValue *EvalVisitor::visitPrintlnFunctionCall(TLParser::PrintlnFunctionCallContext *ctx)
		{
			std::wcout << this->visit(ctx->expression()) << std::endl;
			return TLValue::VOID;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitPrintFunctionCall(@NotNull TLParser.PrintFunctionCallContext ctx)
		TLValue *EvalVisitor::visitPrintFunctionCall(TLParser::PrintFunctionCallContext *ctx)
		{
			std::wcout << this->visit(ctx->expression());
			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitAssertFunctionCall(AssertFunctionCallContext *ctx)
		{
			TLValue *value = this->visit(ctx->expression());

			if (!value->isBoolean())
			{
				EvalException tempVar(ctx);
				throw &tempVar;
			}

			if (!value->asBoolean())
			{
				AssertionError tempVar2(std::wstring(L"Failed Assertion ") + ctx->expression().getText() + std::wstring(L" line:") + ctx->start.getLine());
				throw &tempVar2;
			}

			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitSizeFunctionCall(SizeFunctionCallContext *ctx)
		{
			TLValue *value = this->visit(ctx->expression());

			if (value->isString())
			{
				return new TLValue(value->asString().length());
			}

			if (value->isList())
			{
				return new TLValue(value->asList().size());
			}

			EvalException tempVar(ctx);
			throw &tempVar;
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitIfStatement(@NotNull TLParser.IfStatementContext ctx)
		TLValue *EvalVisitor::visitIfStatement(TLParser::IfStatementContext *ctx)
		{

			// if ...
			if (this->visit(ctx->ifStat().expression()).asBoolean())
			{
				return this->visit(ctx->ifStat().block());
			}

			// else if ...
			for (int i = 0; i < ctx->elseIfStat()->size(); i++)
			{
				if (this->visit(ctx->elseIfStat(i).expression()).asBoolean())
				{
					return this->visit(ctx->elseIfStat(i).block());
				}
			}

			// else ...
			if (ctx->elseStat() != nullptr)
			{
				return this->visit(ctx->elseStat().block());
			}

			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitBlock(BlockContext *ctx)
		{

			scope = new Scope(scope); // create new local scope
			for (StatementContext *sx : ctx->statement())
			{
				this->visit(sx);
			}
			ExpressionContext *ex;
			if ((ex = ctx->expression()) != nullptr)
			{
				returnValue->value = this->visit(ex);
				scope = scope->parent();
				throw returnValue;
			}
			scope = scope->parent();
			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitForStatement(ForStatementContext *ctx)
		{
			int start = this->visit(ctx->expression(0)).asDouble().intValue();
			int stop = this->visit(ctx->expression(1)).asDouble().intValue();
			for (int i = start; i <= stop; i++)
			{
				TLValue tempVar(i);
				scope->assign(ctx->Identifier().getText(), &tempVar);
				TLValue *returnValue = this->visit(ctx->block());
				if (returnValue != TLValue::VOID)
				{
					return returnValue;
				}
			}
			return TLValue::VOID;
		}

		TLValue *EvalVisitor::visitWhileStatement(WhileStatementContext *ctx)
		{
			while (this->visit(ctx->expression()).asBoolean())
			{
				TLValue *returnValue = this->visit(ctx->block());
				if (returnValue != TLValue::VOID)
				{
					return returnValue;
				}
			}
			return TLValue::VOID;
		}
	}
}
