/*
 * Regex.h
 *
 *  Created on: Nov 27, 2011
 *      Author: leonid.gorelik
 */

#ifndef REGEX_H_
#define REGEX_H_

#include <iostream>
#include <string>
#include "sys/time.h"
// Define RE2 regular expression engine
#include "re2/re2.h"
// Define SPL types and functions.
#include "SPL/Runtime/Function/SPLFunctions.h"

using namespace std;

namespace regex {

	template<typename Index>
	inline RE2::Options& getRE2Options(int maxmem){
		static RE2::Options options;
		options.set_log_errors(false);
		options.set_max_mem(maxmem);
		return options;
	}

	template<typename Index>
	inline RE2& getRE2(const string & pattern="", int maxmem=1000000){
		static RE2 regex(pattern, getRE2Options<Index>(maxmem));
		return regex;
	}

	template<typename Index>
	inline void regexCompile(const SPL::rstring & pattern, const Index & patternIndex, int maxmem=1000000){
		getRE2<Index>(pattern, maxmem);
	}

	inline bool regexFullMatch(const string & str, const SPL::rstring & pattern){
		return RE2::FullMatch(str, pattern) == 1;
	}

	template<typename Index>
	inline bool regexFullMatch(const string & str, const Index & patternIndex){
		return RE2::FullMatch(str, getRE2<Index>()) == 1;
	}

	inline bool regexPartialMatch(const string & str, const SPL::rstring & pattern){
		return RE2::PartialMatch(str, pattern) == 1;
	}

	template<typename Index>
	inline bool regexPartialMatch(const string & str, const Index & patternIndex){
		return RE2::PartialMatch(str, getRE2<Index>()) == 1;
	}
}

#endif /* REGEX_H_ */
