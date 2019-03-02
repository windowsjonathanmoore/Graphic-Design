#pragma once

#include <string>
#include <unordered_map>
#include <vector>
#include <stdexcept>

//JAVA TO C++ CONVERTER NOTE: Forward class declarations:
namespace tl { namespace antlr4 { class Scope; } }
namespace tl { namespace antlr4 { class TLValue; } }

namespace tl
{
	namespace antlr4
	{


		using org::antlr::v4::runtime::tree::ParseTree;
		using org::antlr::v4::runtime::tree::TerminalNode;

		using tl::antlr4::TLParser::ExpressionContext;

		class Function
		{
		private:
			std::wstring id;
			std::vector<TerminalNode*> params;
			ParseTree *block;

		public:
			Function(const std::wstring &id, std::vector<TerminalNode*> &params, ParseTree *block);

			virtual TLValue *invoke(std::vector<ExpressionContext*> &params, std::unordered_map<std::wstring, Function*> &functions, Scope *scope);
		};

	}
}
