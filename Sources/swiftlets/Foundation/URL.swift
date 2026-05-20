//
//  File.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2026-05-02.
//

import Foundation

public extension URL {
	/// Returns true if this URL is a parent directory of the given URL
	func isParent(of childURL: URL, allowExactMatch: Bool = true) -> Bool {
		// Both URLs must be file URLs
		guard self.isFileURL && childURL.isFileURL else {
			return false
		}

		// Get the absolute paths
		let selfPath = self.path
		let childPath = childURL.path

		if allowExactMatch,
		   selfPath == childPath {
			return true
		}

		// The parent path should be a prefix of the child path
		// and the child path should have more components than the parent
		guard childPath.hasPrefix(selfPath) else {
			return false
		}

		// Ensure that the parent path ends with "/" to properly handle directory matching
		let normalizedSelfPath = selfPath.hasSuffix("/") ? selfPath : "\(selfPath)/"

		// Check that the child path is actually within the parent directory
		guard childPath.hasPrefix(normalizedSelfPath) else {
			return false
		}

		// Additional check: if the paths are equal, it's not a "parent" relationship
		return (normalizedSelfPath != childPath)
	}

	init?(extractedRelativePathFrom url: URL, relativeTo base: URL) {
		guard url.isFileURL && base.isFileURL else {
			return nil
		}

		let destinationComponents = url.standardized.pathComponents
		let baseComponents = base.standardized.pathComponents

		// Determine backtracking "../"
		var commonCount = 0
		while commonCount < destinationComponents.count && commonCount < baseComponents.count
				&& destinationComponents[commonCount] == baseComponents[commonCount] {
			commonCount += 1
		}

		// Build relative path:
		var relativeComponents = Array(repeating: "..", count: baseComponents.count - commonCount)
		relativeComponents.append(contentsOf: destinationComponents[commonCount...])
		let newURL = URL(fileURLWithPath: relativeComponents.joined(separator: "/"), relativeTo: base.standardizedFileURL)
		self = URL(fileURLWithPath: newURL.relativePath, relativeTo: base)
	}
}
