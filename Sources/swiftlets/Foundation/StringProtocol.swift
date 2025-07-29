//
//  StringProtocol.swift
//  swiftlets
//
//  Created by Kevin Hayes on 2025-04-27.
//

import Foundation

extension StringProtocol {
	
	/// Retrieves the grapheme cluster at the offset provided.

	/// Note this function is slow. Since grapheme clusers have varying byte lenghts,
	/// it must go through each character and calculating whether it is part of a larger grapheme cluster
	/// until the desired one is reached.
	public subscript(clusterAt offset: Int) -> Character? {
		self[safe: index(startIndex, offsetBy: offset)]
	}

	/// Retrieves the subsequence of grapheme clusters using the given range
	///
	/// range: the range of clusters. Must be a valid range within the String
	public subscript(clusterRange range: Range<Int>) -> SubSequence {
		let start = index(self.startIndex, offsetBy: range.lowerBound)
		return self[start..<index(start, offsetBy: range.count)]
	}

	/// Retrieves the subsequence of grapheme clusters using the given range
	///
	/// range: the range of clusters. Must be a valid range within the String
	public subscript(clusterRange range: ClosedRange<Int>) -> SubSequence {
		let start = index(self.startIndex, offsetBy: range.lowerBound)
		return self[start..<index(start, offsetBy: range.count)]
	}
	
	/// Retrieves the subsequence of grapheme clusters using the given range
	///
	/// range: the range of clusters. Must be a valid range within the String
	public subscript(clusterRange range: PartialRangeFrom<Int>) -> SubSequence {
		self[index(startIndex, offsetBy: range.lowerBound)...]
	}

	/// Retrieves the subsequence of grapheme clusters using the given range
	///
	/// range: the range of clusters. Must be a valid range within the String
	public subscript(clusterRange range: PartialRangeUpTo<Int>) -> SubSequence {
		self[..<index(startIndex, offsetBy: range.upperBound)]
	}

	/// Retrieves the subsequence of grapheme clusters using the given range
	///
	/// range: the range of clusters. Must be a valid range within the String
	public subscript(clusterRange range: PartialRangeThrough<Int>) -> SubSequence {
		self[...index(startIndex, offsetBy: range.upperBound)]
	}

	// MARK: - Base64URLSafeDecoding

	/// Takes a base64 encoded, URL Fragment allowed percent escaped string and returns Data struct
	public var base64URLSafeDecoded: Data? {
		var decodedString = String(self)
			.replacingOccurrences(of: "-", with: "+")
			.replacingOccurrences(of: "_", with: "/")

		let paddingCount = self.count % 4
		if paddingCount > 0 {
			decodedString = decodedString
				.appending(String(repeating: "=", count: 4 - paddingCount))
		}
		return Data(base64Encoded: decodedString)
	}
}
