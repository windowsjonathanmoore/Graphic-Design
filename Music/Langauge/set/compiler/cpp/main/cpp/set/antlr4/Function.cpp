#include "Function.h"
#include "Scope.h"
#include "TLValue.h"
#include "EvalVisitor.h"
#include "ReturnValue.h"

namespace tl
{
	namespace antlr4
	{
		using org::antlr::v4::runtime::tree::ParseTree;
		using org::antlr::v4::runtime::tree::TerminalNode;
		using tl::antlr4::TLParser::ExpressionContext;

		Function::Function(const std::wstring &id, std::vector<TerminalNode*> &params, ParseTree *block)
		{
			this->id = id;
			this->params = params;
			this->block = block;
		}

		TLValue *Function::invoke(std::vector<ExpressionContext*> &params, std::unordered_map<std::wstring, Function*> &functions, Scope *scope)
		{
			if (params.size() != this->params.size())
			{
				std::exception tempVar(L"Illegal Function call");
				throw &tempVar;
			}
			scope = new Scope(scope); // create function scope
			EvalVisitor *evalVisitor = new EvalVisitor(scope, functions);
			for (int i = 0; i < this->params.size(); i++)
			{
				TLValue *value = evalVisitor->visit(params[i]);
				scope->assignParam(this->params[i]->getText(), value);
			}
			TLValue *ret = TLValue::VOID;
			try
			{
				evalVisitor->visit(this->block);
			}
			catch (ReturnValue returnValue)
			{
				ret = returnValue->value;
			}
			return ret;
		}
	}
}
