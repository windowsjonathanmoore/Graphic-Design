#pragma once

#include <string>
#include <unordered_map>
#include "stringbuilder.h"

//JAVA TO C++ CONVERTER NOTE: Forward class declarations:
namespace tl { namespace antlr4 { class TLValue; } }

namespace tl
{
	namespace antlr4
	{


		class Scope
		{

		private:
//JAVA TO C++ CONVERTER NOTE: Fields cannot have the same name as methods:
			Scope *parent_Renamed;
			std::unordered_map<std::wstring, TLValue*> variables;

		public:
			Scope();

			Scope(Scope *p);

			virtual void assignParam(const std::wstring &var, TLValue *value);

			virtual void assign(const std::wstring &var, TLValue *value);

			virtual Scope *copy();

			virtual bool isGlobalScope();

			virtual Scope *parent();

		private:
			void reAssign(const std::wstring &identifier, TLValue *value);

		public:
			virtual TLValue *resolve(const std::wstring &var);

			virtual std::wstring toString() override;
		};

	}
}
