#include "Scope.h"
#include "TLValue.h"

namespace tl
{
	namespace antlr4
	{

		Scope::Scope() : Scope(nullptr)
		{
			// only for the global scope, the parent is null
		}

		Scope::Scope(Scope *p)
		{
			parent_Renamed = p;
			variables = std::unordered_map<std::wstring, TLValue*>();
		}

		void Scope::assignParam(const std::wstring &var, TLValue *value)
		{
			variables[var] = value;
		}

		void Scope::assign(const std::wstring &var, TLValue *value)
		{
			if (resolve(var) != nullptr)
			{
				// There is already such a variable, re-assign it
				this->reAssign(var, value);
			}
			else
			{
				// A newly declared variable
				variables[var] = value;
			}
		}

		Scope *Scope::copy()
		{
			// Create a shallow copy of this scope. Used in case functions are
			// are recursively called. If we wouldn't create a copy in such cases,
			// changing the variables would result in changes ro the Maps from
			// other "recursive scopes".
			Scope *s = new Scope();
			s->variables = std::unordered_map<std::wstring, TLValue*>(this->variables);
			s->parent_Renamed = this->parent_Renamed;
			return s;
		}

		bool Scope::isGlobalScope()
		{
			return parent_Renamed == nullptr;
		}

		Scope *Scope::parent()
		{
			return parent_Renamed;
		}

		void Scope::reAssign(const std::wstring &identifier, TLValue *value)
		{
			if (variables.find(identifier) != variables.end())
			{
				// The variable is declared in this scope
				variables[identifier] = value;
			}
			else if (parent_Renamed != nullptr)
			{
				// The variable was not declared in this scope, so let
				// the parent scope re-assign it
				parent_Renamed->reAssign(identifier, value);
			}
		}

		TLValue *Scope::resolve(const std::wstring &var)
		{
			TLValue *value = variables[var];
			if (value != nullptr)
			{
				// The variable resides in this scope
				return value;
			}
			else if (!isGlobalScope())
			{
				// Let the parent scope look for the variable
				return parent_Renamed->resolve(var);
			}
			else
			{
				// Unknown variable
				return nullptr;
			}
		}

		std::wstring Scope::toString()
		{
			StringBuilder *sb = new StringBuilder();
			for (auto var : variables)
			{
				sb->append(var.first + std::wstring(L"->") + var.second + std::wstring(L","));
			}
			return sb->toString();
		}
	}
}
