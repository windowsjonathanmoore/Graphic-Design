#pragma once

#include <stdexcept>

//JAVA TO C++ CONVERTER NOTE: Forward class declarations:
namespace tl { namespace antlr4 { class TLValue; } }

namespace tl
{
	namespace antlr4
	{

		class ReturnValue : public std::exception
		{
		public:
			TLValue *value;
		};

	}
}
