#pragma once

#include <string>
#include <unordered_map>
#include <vector>
#include <iostream>
#include <cmath>
#include <stdexcept>
#include "stringbuilder.h"

//JAVA TO C++ CONVERTER NOTE: Forward class declarations:
namespace tl { namespace antlr4 { class TLValue; } }
namespace tl { namespace antlr4 { class ReturnValue; } }
namespace tl { namespace antlr4 { class Scope; } }
namespace tl { namespace antlr4 { class Function; } }

namespace tl
{
	namespace antlr4
	{


		using org::antlr::v4::runtime::ParserRuleContext;

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
		using tl::antlr4::TLParser::SubtractExpressionContext;
		using tl::antlr4::TLParser::TernaryExpressionContext;
		using tl::antlr4::TLParser::UnaryMinusExpressionContext;
		using tl::antlr4::TLParser::WhileStatementContext;

		class EvalVisitor : public TLBaseVisitor<TLValue*>
		{
		private:
			static ReturnValue *returnValue;
			Scope *scope;
			std::unordered_map<std::wstring, Function*> functions;

		public:
			EvalVisitor(Scope *scope, std::unordered_map<std::wstring, Function*> &functions);

			// functionDecl
			virtual TLValue *visitFunctionDecl(FunctionDeclContext *ctx) override;

			// list: '[' exprList? ']'
			virtual TLValue *visitList(ListContext *ctx) override;


			// '-' expression                           #unaryMinusExpression
			virtual TLValue *visitUnaryMinusExpression(UnaryMinusExpressionContext *ctx) override;

			// '!' expression                           #notExpression
			virtual TLValue *visitNotExpression(NotExpressionContext *ctx) override;

			// expression '^' expression                #powerExpression
			virtual TLValue *visitPowerExpression(PowerExpressionContext *ctx) override;

			// expression '*' expression                #multiplyExpression
			virtual TLValue *visitMultiplyExpression(MultiplyExpressionContext *ctx) override;

			// expression '/' expression                #divideExpression
			virtual TLValue *visitDivideExpression(DivideExpressionContext *ctx) override;

			// expression '%' expression                #modulusExpression
			virtual TLValue *visitModulusExpression(ModulusExpressionContext *ctx) override;

			// expression '+' expression                #addExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitAddExpression(@NotNull TLParser.AddExpressionContext ctx)
			virtual TLValue *visitAddExpression(TLParser::AddExpressionContext *ctx) override;

			// expression '-' expression                #subtractExpression
			virtual TLValue *visitSubtractExpression(SubtractExpressionContext *ctx) override;

			// expression '>=' expression               #gtEqExpression
			virtual TLValue *visitGtEqExpression(GtEqExpressionContext *ctx) override;

			// expression '<=' expression               #ltEqExpression
			virtual TLValue *visitLtEqExpression(LtEqExpressionContext *ctx) override;

			// expression '>' expression                #gtExpression
			virtual TLValue *visitGtExpression(GtExpressionContext *ctx) override;

			// expression '<' expression                #ltExpression
			virtual TLValue *visitLtExpression(LtExpressionContext *ctx) override;

			// expression '==' expression               #eqExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitEqExpression(@NotNull TLParser.EqExpressionContext ctx)
			virtual TLValue *visitEqExpression(TLParser::EqExpressionContext *ctx) override;

			// expression '!=' expression               #notEqExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitNotEqExpression(@NotNull TLParser.NotEqExpressionContext ctx)
			virtual TLValue *visitNotEqExpression(TLParser::NotEqExpressionContext *ctx) override;

			// expression '&&' expression               #andExpression
			virtual TLValue *visitAndExpression(AndExpressionContext *ctx) override;

			// expression '||' expression               #orExpression
			virtual TLValue *visitOrExpression(OrExpressionContext *ctx) override;

			// expression '?' expression ':' expression #ternaryExpression
			virtual TLValue *visitTernaryExpression(TernaryExpressionContext *ctx) override;

			// expression In expression                 #inExpression
			virtual TLValue *visitInExpression(InExpressionContext *ctx) override;

			// Number                                   #numberExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitNumberExpression(@NotNull TLParser.NumberExpressionContext ctx)
			virtual TLValue *visitNumberExpression(TLParser::NumberExpressionContext *ctx) override;

			// Bool                                     #boolExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitBoolExpression(@NotNull TLParser.BoolExpressionContext ctx)
			virtual TLValue *visitBoolExpression(TLParser::BoolExpressionContext *ctx) override;

			// Null                                     #nullExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitNullExpression(@NotNull TLParser.NullExpressionContext ctx)
			virtual TLValue *visitNullExpression(TLParser::NullExpressionContext *ctx) override;

		private:
			TLValue *resolveIndexes(ParserRuleContext *ctx, TLValue *val, std::vector<ExpressionContext*> &indexes);

			void setAtIndex(ParserRuleContext *ctx, std::vector<ExpressionContext*> &indexes, TLValue *val, TLValue *newVal);

			// functionCall indexes?                    #functionCallExpression
		public:
			virtual TLValue *visitFunctionCallExpression(FunctionCallExpressionContext *ctx) override;

			// list indexes?                            #listExpression
			virtual TLValue *visitListExpression(ListExpressionContext *ctx) override;

			// Identifier indexes?                      #identifierExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitIdentifierExpression(@NotNull TLParser.IdentifierExpressionContext ctx)
			virtual TLValue *visitIdentifierExpression(TLParser::IdentifierExpressionContext *ctx) override;

			// String indexes?                          #stringExpression
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitStringExpression(@NotNull TLParser.StringExpressionContext ctx)
			virtual TLValue *visitStringExpression(TLParser::StringExpressionContext *ctx) override;

			// '(' expression ')' indexes?              #expressionExpression
			virtual TLValue *visitExpressionExpression(ExpressionExpressionContext *ctx) override;

			// Input '(' String? ')'                    #inputExpression
			virtual TLValue *visitInputExpression(InputExpressionContext *ctx) override;


			// assignment
			// : Identifier indexes? '=' expression
			// ;
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitAssignment(@NotNull TLParser.AssignmentContext ctx)
			virtual TLValue *visitAssignment(TLParser::AssignmentContext *ctx) override;

			// Identifier '(' exprList? ')' #identifierFunctionCall
			virtual TLValue *visitIdentifierFunctionCall(IdentifierFunctionCallContext *ctx) override;

			// Println '(' expression? ')'  #printlnFunctionCall
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitPrintlnFunctionCall(@NotNull TLParser.PrintlnFunctionCallContext ctx)
			virtual TLValue *visitPrintlnFunctionCall(TLParser::PrintlnFunctionCallContext *ctx) override;

			// Print '(' expression ')'     #printFunctionCall
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitPrintFunctionCall(@NotNull TLParser.PrintFunctionCallContext ctx)
			virtual TLValue *visitPrintFunctionCall(TLParser::PrintFunctionCallContext *ctx) override;

			// Assert '(' expression ')'    #assertFunctionCall
			virtual TLValue *visitAssertFunctionCall(AssertFunctionCallContext *ctx) override;

			// Size '(' expression ')'      #sizeFunctionCall
			virtual TLValue *visitSizeFunctionCall(SizeFunctionCallContext *ctx) override;

			// ifStatement
			//  : ifStat elseIfStat* elseStat? End
			//  ;
			//
			// ifStat
			//  : If expression Do block
			//  ;
			//
			// elseIfStat
			//  : Else If expression Do block
			//  ;
			//
			// elseStat
			//  : Else Do block
			//  ;
//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @Override public TLValue visitIfStatement(@NotNull TLParser.IfStatementContext ctx)
			virtual TLValue *visitIfStatement(TLParser::IfStatementContext *ctx) override;

			// block
			// : (statement | functionDecl)* (Return expression)?
			// ;
			virtual TLValue *visitBlock(BlockContext *ctx) override;

			// forStatement
			// : For Identifier '=' expression To expression OBrace block CBrace
			// ;
			virtual TLValue *visitForStatement(ForStatementContext *ctx) override;

			// whileStatement
			// : While expression OBrace block CBrace
			// ;
			virtual TLValue *visitWhileStatement(WhileStatementContext *ctx) override;

		};

	}
}
