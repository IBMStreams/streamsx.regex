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

	inline RE2::Options& getRE2Options(int maxmem){
		static RE2::Options options;
		options.set_log_errors(false);
		options.set_max_mem(maxmem);
		return options;
	}

	inline RE2& getRE2(const string & pattern, int maxmem){
		static RE2 regex(pattern, getRE2Options(maxmem));
		return regex;
	}

	inline bool regexFullMatch(const string & str, const string & pattern="", int maxmem=1000000){
		return RE2::FullMatch(str, getRE2(pattern, maxmem)) == 1;
	}

	inline bool regexPartialMatch(const string & str, const string & pattern="", int maxmem=1000000){
		return RE2::PartialMatch(str, getRE2(pattern, maxmem)) == 1;
	}

	inline bool regexSimpleMatch(const string & str, const string & pattern){
		return RE2::PartialMatch(str, pattern) == 1;
	}
}

#endif /* REGEX_H_ */
