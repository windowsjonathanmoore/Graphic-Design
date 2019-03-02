#pragma once

#include <string>
#include <stdexcept>

namespace tl
{
	namespace antlr4
	{

		using org::antlr::v4::runtime::ParserRuleContext;

		class EvalException : public std::exception
		{
		public:
			EvalException(ParserRuleContext *ctx);

			EvalException(const std::wstring &msg, ParserRuleContext *ctx);
		};

	}
}
