/*
 * Regex.h
 *
 *  Created on: Nov 27, 2014
 *      Author: leonid.gorelik
 */

#ifndef REGEX_H_
#define REGEX_H_

#include <iostream>
#include "sys/time.h"
#include "re2/re2.h"

#include "SPL/Runtime/Function/SPLFunctions.h"

using namespace std;

namespace regex {

	namespace {
		struct OperatorInstance {};
	}

	template<typename Index, typename OP>
	inline RE2::Options& getRE2Options(int maxmem){
		static RE2::Options options;
		options.set_log_errors(true);
		options.set_max_mem(maxmem);
		return options;
	}

	template<typename Index>
	inline RE2::Options& getRE2OptionsStatic(int maxmem){
		static RE2::Options options;
		options.set_log_errors(true);
		options.set_max_mem(maxmem);
		return options;
	}

	template<typename Index, typename OP>
	inline RE2& getRE2(const SPL::rstring & pattern="", int maxmem=1000000){
		static RE2 regex(re2::StringPiece(pattern.data(), pattern.size()), getRE2Options<Index,OP>(maxmem));
		return regex;
	}

	template<typename Index>
	inline RE2& getRE2Static(const SPL::rstring & pattern="", int maxmem=1000000){
		static RE2 regex(re2::StringPiece(pattern.data(), pattern.size()), getRE2OptionsStatic<Index>(maxmem));
		return regex;
	}

	template<typename Index>
	inline void regexCompile(const SPL::rstring & pattern, const Index & patternIndex, int maxmem=1000000){
		getRE2<Index,OperatorInstance>(pattern, maxmem);
	}

	template<typename Index>
	inline void regexCompileStatic(const SPL::rstring & pattern, const Index & patternIndex, int maxmem=1000000){
		getRE2Static<Index>(pattern, maxmem);
	}

	inline bool regexFullMatch(const SPL::rstring & str, const SPL::rstring & pattern){
		return RE2::FullMatch(re2::StringPiece(str.data(), str.size()), re2::StringPiece(pattern.data(), pattern.size())) == 1;
	}

	template<typename Index>
	inline bool regexFullMatch(const SPL::rstring & str, const Index & patternIndex){
		return RE2::FullMatch(re2::StringPiece(str.data(), str.size()), getRE2<Index,OperatorInstance>()) == 1;
	}

	template<typename Index>
	inline bool regexFullMatchStatic(const SPL::rstring & str, const Index & patternIndex){
		return RE2::FullMatch(re2::StringPiece(str.data(), str.size()), getRE2Static<Index>()) == 1;
	}

	inline bool regexPartialMatch(const SPL::rstring & str, const SPL::rstring & pattern){
		return RE2::PartialMatch(re2::StringPiece(str.data(), str.size()), re2::StringPiece(pattern.data(), pattern.size())) == 1;
	}

	template<typename Index>
	inline bool regexPartialMatch(const SPL::rstring & str, const Index & patternIndex){
		return RE2::PartialMatch(re2::StringPiece(str.data(), str.size()), getRE2<Index,OperatorInstance>()) == 1;
	}

	template<typename Index>
	inline bool regexPartialMatchStatic(const SPL::rstring & str, const Index & patternIndex){
		return RE2::PartialMatch(re2::StringPiece(str.data(), str.size()), getRE2Static<Index>()) == 1;
	}
}

#endif /* REGEX_H_ */
