#pragma once

#include <string>
#include <vector>
#include <cmath>
#include <stdexcept>
#include <boost/optional.hpp>

namespace tl
{
	namespace antlr4
	{


		class TLValue : public Comparable<TLValue*>
		{

		public:
			static TLValue *const NULL;
			static TLValue *const VOID;

		private:
			void *value;

			TLValue();

		public:
			TLValue(void *v);

			virtual boost::optional<bool> asBoolean();

			virtual boost::optional<double> asDouble();

			virtual boost::optional<long long> asLong();

//JAVA TO C++ CONVERTER TODO TASK: Most Java annotations will not have direct C++ equivalents:
//ORIGINAL LINE: @SuppressWarnings("unchecked") public java.util.List<TLValue> asList()
			virtual std::vector<TLValue*> asList();

			virtual std::wstring asString();

			//@Override
			virtual int compareTo(TLValue *that);

			virtual bool equals(void *o) override;

			virtual int hashCode() override;

			virtual bool isBoolean();

			virtual bool isNumber();

			virtual bool isList();

			virtual bool isNull();

			virtual bool isVoid();

			virtual bool isString();

			virtual std::wstring toString() override;
		};

	}
}
