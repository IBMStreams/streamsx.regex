/*
 * Regex_re2.h
 *
 *  Created on: Nov 27, 2014
 *      Author: leonid.gorelik
 */

#ifndef REGEX_RE2_H_
#define REGEX_RE2_H_

#include <iostream>
#include "sys/time.h"
#include "re2/re2.h"

#include "SPL/Runtime/Function/SPLFunctions.h"

using re2::StringPiece;

#endif /* REGEX_RE2_H_ */

namespace com {	namespace ibm {	namespace streamsx { namespace regex { namespace re2 {

	namespace {	// this anonymous namespace will be defined for each operator separately

		template<typename Index>
		inline RE2::Options& getRE2Options(const SPL::rstring & pattern, long maxmem) {
			if(pattern.empty())
				SPLAPPTRC(L_WARN, "Regular expression '" + pattern + "' is empty, possibly 'regexCompile' was not called before.", "REGEX");

			static RE2::Options options;
			options.set_log_errors(true);
			options.set_max_mem(maxmem);

			return options;
		}

		template<typename Index>
		inline RE2& getRE2(const SPL::rstring & pattern="", long maxmem=1000000) {
			static RE2 regex(StringPiece(pattern.data(), pattern.size()), getRE2Options<Index>(pattern, maxmem));
			return regex;
		}

		template<typename Index>
		inline bool regexCompile(const SPL::rstring & pattern, const Index & patternIndex, long maxmem=1000000) {
			RE2 const& regex = getRE2<Index>(pattern, maxmem);
			if(!regex.ok())
				THROW(SPL::SPLRuntimeOperator, "Regular expression '" + pattern + "' failed to compile - " + regex.error());

			return true;
		}

		template<typename Index>
		inline bool regexFullMatch(const SPL::rstring & str, const Index & patternIndex) {
			return RE2::FullMatch(StringPiece(str.data(), str.size()), getRE2<Index>());
		}

		inline bool regexFullMatch(const SPL::rstring & str, const SPL::rstring & pattern) {
			return RE2::FullMatch(StringPiece(str.data(), str.size()), StringPiece(pattern.data(), pattern.size()));
		}

		template<typename Index>
		inline bool regexPartialMatch(const SPL::rstring & str, const Index & patternIndex) {
			return RE2::PartialMatch(StringPiece(str.data(), str.size()), getRE2<Index>());
		}

		inline bool regexPartialMatch(const SPL::rstring & str, const SPL::rstring & pattern) {
			return RE2::PartialMatch(StringPiece(str.data(), str.size()), StringPiece(pattern.data(), pattern.size()));
		}

		template<typename Index>
		inline bool regexReplace(SPL::rstring & str, const Index & patternIndex, const SPL::rstring & rewrite) {
			return RE2::Replace(&str, getRE2<Index>(), StringPiece(rewrite.data(), rewrite.size()));
		}

		template<typename Index>
		inline int regexGlobalReplace(SPL::rstring & str, const Index & patternIndex, const SPL::rstring & rewrite) {
			return RE2::GlobalReplace(&str, getRE2<Index>(), StringPiece(rewrite.data(), rewrite.size()));
		}

		template<typename Index>
		inline bool regexExtract(const SPL::rstring & str, const Index & patternIndex, SPL::rstring & rewrite) {
			SPL::rstring ext;
			bool result = RE2::Extract(StringPiece(str.data(), str.size()), getRE2<Index>(), StringPiece(rewrite.data(), rewrite.size()), &ext);
			if(result)
				rewrite = ext;
			return result;
		}
	}
}}}}}
