#include "SymbolVisitor.h"
#include "TLValue.h"
#include "Function.h"

namespace tl
{
	namespace antlr4
	{
		using org::antlr::v4::runtime::tree::ParseTree;
		using org::antlr::v4::runtime::tree::TerminalNode;
		using tl::antlr4::TLParser::FunctionDeclContext;

		SymbolVisitor::SymbolVisitor(std::unordered_map<std::wstring, Function*> &functions)
		{
			this->functions = functions;
		}

		TLValue *SymbolVisitor::visitFunctionDecl(FunctionDeclContext *ctx)
		{
			std::vector<TerminalNode*> params = ctx->idList() != nullptr ? ctx->idList().Identifier() : std::vector<TerminalNode*>();
			ParseTree *block = ctx->block();
			std::wstring id = ctx->Identifier().getText() + params.size();
			functions[id] = new Function(id, params, block);
			return TLValue::VOID;
		}
	}
}
