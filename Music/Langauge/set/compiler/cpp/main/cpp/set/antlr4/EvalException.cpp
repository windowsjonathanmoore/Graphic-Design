#include "EvalException.h"

namespace tl
{
	namespace antlr4
	{
		using org::antlr::v4::runtime::ParserRuleContext;

		EvalException::EvalException(ParserRuleContext *ctx) : EvalException(L"Illegal expression: " + ctx->getText(), ctx)
		{
		}

		EvalException::EvalException(const std::wstring &msg, ParserRuleContext *ctx) : RuntimeException(msg + L" line:" + ctx->start.getLine())
		{
		}
	}
}
