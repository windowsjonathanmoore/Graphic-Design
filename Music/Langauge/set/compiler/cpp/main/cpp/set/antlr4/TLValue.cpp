#include "TLValue.h"

namespace tl
{
	namespace antlr4
	{

TLValue *const TLValue::NULL = new TLValue();
TLValue *const TLValue::VOID = new TLValue();

		TLValue::TLValue()
		{
			// private constructor: only used for NULL and VOID
			value = new Object();
		}

		TLValue::TLValue(void *v)
		{
			if (v == nullptr)
			{
				std::exception tempVar(L"v == null");
				throw &tempVar;
			}
			value = v;
			// only accept boolean, list, number or string types
			if (!(isBoolean() || isList() || isNumber() || isString()))
			{
				std::exception tempVar2(std::wstring(L"invalid data type: ") + v + std::wstring(L" (") + v->getClass() + std::wstring(L")"));
				throw &tempVar2;
			}
		}

		boost::optional<bool> TLValue::asBoolean()
		{
			return static_cast<boost::optional<bool>*>(value);
		}

		boost::optional<double> TLValue::asDouble()
		{
			return (static_cast<Number*>(value))->doubleValue();
		}

		boost::optional<long long> TLValue::asLong()
		{
			return (static_cast<Number*>(value))->longValue();
		}

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @SuppressWarnings("unchecked") public java.util.List<TLValue> asList()
		std::vector<TLValue*> TLValue::asList()
		{
			return static_cast<std::vector<TLValue*>>(value);
		}

		std::wstring TLValue::asString()
		{
			return static_cast<std::wstring>(value);
		}

		int TLValue::compareTo(TLValue *that)
		{
			if (this->isNumber() && that->isNumber())
			{
				if (this->equals(that))
				{
					return 0;
				}
				else
				{
					return this->asDouble().compare(that->asDouble());
				}
			}
			else if (this->isString() && that->isString())
			{
				return this->asString().compare(that->asString());
			}
			else
			{
				std::exception tempVar(std::wstring(L"illegal expression: can't compare `") + this + std::wstring(L"` to `") + that + std::wstring(L"`"));
				throw &tempVar;
			}
		}

		bool TLValue::equals(void *o)
		{
			if (this == VOID || o == VOID)
			{
				std::exception tempVar(std::wstring(L"can't use VOID: ") + this + std::wstring(L" ==/!= ") + o);
				throw &tempVar;
			}
			if (this == o)
			{
				return true;
			}
			if (o == nullptr || this->getClass() != o->getClass())
			{
				return false;
			}
			TLValue *that = static_cast<TLValue*>(o);
			if (this->isNumber() && that->isNumber())
			{
				double diff = std::abs(this->asDouble() - that->asDouble());
				return diff < 0.00000000001;
			}
			else
			{
				return this->value->equals(that->value);
			}
		}

		int TLValue::hashCode()
		{
			return value->hashCode();
		}

		bool TLValue::isBoolean()
		{
			return dynamic_cast<boost::optional<bool>*>(value) != nullptr;
		}

		bool TLValue::isNumber()
		{
			return dynamic_cast<Number*>(value) != nullptr;
		}

		bool TLValue::isList()
		{
//JAVA TO C++ CONVERTER TODO TASK: Java wildcard generics are not converted to C++:
//ORIGINAL LINE: return value instanceof java.util.List<?>;
			return dynamic_cast<std::vector<?>>(value) != nullptr;
		}

		bool TLValue::isNull()
		{
			return this == NULL;
		}

		bool TLValue::isVoid()
		{
			return this == VOID;
		}

		bool TLValue::isString()
		{
			return dynamic_cast<std::wstring>(value) != nullptr;
		}

		std::wstring TLValue::toString()
		{
			return isNull() ? L"NULL" : isVoid() ? L"VOID" : static_cast<std::wstring>(value);
		}
	}
}
