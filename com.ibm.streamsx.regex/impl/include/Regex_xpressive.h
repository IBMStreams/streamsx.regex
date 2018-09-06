/*
 * Regex_xpressive.h
 *
 *  Created on: Nov 27, 2014
 *      Author: leonid.gorelik
 */

#ifndef REGEX_XPRESSIVE_H_
#define REGEX_XPRESSIVE_H_

#include <iostream>
#include <streams_boost/xpressive/xpressive_dynamic.hpp>

#include "SPL/Runtime/Function/SPLFunctions.h"

//using namespace std;
using streams_boost::xpressive::cregex;
using streams_boost::xpressive::regex_match;
using streams_boost::xpressive::regex_search;

namespace com {	namespace ibm {	namespace streamsx { namespace regex { namespace xpressive {

	namespace {	// this anonymous namespace will be defined for each operator separately

		inline cregex getCRegexImpl(const SPL::rstring & pattern){
			if(pattern.empty())
				SPLAPPTRC(L_WARN, "Regular expression '" + pattern + "' is empty, possibly 'regexCompile' was not called before.", "REGEX");

			return cregex::compile(pattern.begin(), pattern.end());
		}

		template<typename Index>
		inline cregex& getCRegex(const SPL::rstring & pattern=""){
			static cregex regex = getCRegexImpl(pattern);
			return regex;
		}

		template<typename Index>
		inline bool regexCompile(const SPL::rstring & pattern, const Index & patternIndex){
			getCRegex<Index>(pattern);
			return true;
		}

		inline bool regexFullMatch(const SPL::rstring & str, const SPL::rstring & pattern){
			cregex regex = cregex::compile(pattern.begin(), pattern.end());
			return regex_match(str.c_str(), regex);
		}

		template<typename Index>
		inline bool regexFullMatch(const SPL::rstring & str, const Index & patternIndex){
			return regex_match(str.c_str(), getCRegex<Index>());
		}

		inline bool regexPartialMatch(const SPL::rstring & str, const SPL::rstring & pattern){
			cregex regex = cregex::compile(pattern.begin(), pattern.end());
			return regex_search(str.c_str(), regex);
		}

		template<typename Index>
		inline bool regexPartialMatch(const SPL::rstring & str, const Index & patternIndex){
			return regex_search(str.c_str(), getCRegex<Index>());
		}

		template<typename Index>
		inline SPL::rstring regexGlobalReplace(const SPL::rstring & str, const Index & patternIndex, const SPL::rstring & rewrite){
			return regex_replace(str.c_str(), getCRegex<Index>(), rewrite.c_str());
		}
	}
}}}}}

#endif /* REGEX_XPRESSIVE_H_ */
