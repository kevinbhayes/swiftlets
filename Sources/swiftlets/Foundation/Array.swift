//
//  Array.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2026-06-14.
//

import Foundation

extension Array {
	/// Move elements in an array to a new location within the Array
	/// - Parameters:
	///   - fromIndices: indices of the items to move
	///   - toIndex: destination index
	public mutating func move(from fromIndices: IndexSet, to toIndex: Array.Index) {
		let itemsToMove = fromIndices.compactMap { self[safe: $0] }

		for index in fromIndices.reversed() {
			guard self.indices.contains(index) else { continue }
			self.remove(at: index)
		}

		let insertionIndex = Swift.min(Swift.max(0, toIndex), self.count)
		self.insert(contentsOf: itemsToMove, at: insertionIndex)
	}
}
