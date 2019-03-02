#pragma once

#include <string>
#include <unordered_map>
#include <vector>

//JAVA TO C++ CONVERTER NOTE: Forward class declarations:
namespace tl { namespace antlr4 { class TLValue; } }
namespace tl { namespace antlr4 { class Function; } }

namespace tl
{
	namespace antlr4
	{



		using tl::antlr4::TLParser::FunctionDeclContext;

		class SymbolVisitor : public TLBaseVisitor<TLValue*>
		{
		public:
			std::unordered_map<std::wstring, Function*> functions;

			SymbolVisitor(std::unordered_map<std::wstring, Function*> &functions);

			virtual TLValue *visitFunctionDecl(FunctionDeclContext *ctx) override;
		};

	}
}
