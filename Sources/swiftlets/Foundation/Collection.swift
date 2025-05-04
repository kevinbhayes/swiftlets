//
//  Collection.swift
//  swiftlets
//
//  Created by Kevin Hayes on 2025-04-27.
//

extension Collection {
	
	/// Safely retrieve an element from the collection using the provided index.
	///
	/// If the index is out of the collection’s bounds, nil is returned.
	public subscript(safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}

	/// A convenience function to make code more readable, especially in areas with complex boolean logic
	///
	/// Sometimes using ! for negation can get missed in heavy use of parentheses or the logic would just read better
	/// if one could use a positive term instead of a negative. hasContents is for those times. This function calls !isEmpty
	/// on the target.
	public var hasContents: Bool {
		!isEmpty
	}
}
