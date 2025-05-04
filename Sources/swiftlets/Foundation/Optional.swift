//
//  Optional.swift
//  swiftlets
//
//  Created by Kevin Hayes on 2025-04-27.
//

extension Optional {
	/// Returns true if the Optional value is nil
	public var isNil: Bool {
		if case .none = self {
			true
		}
		else {
			false
		}
	}

	/// Returns true if the Optional value is not nil
	public var isNotNil: Bool {
		!isNil
	}
}

extension Optional where Wrapped: Collection {
	/// A convenience function to make code more readable, especially in areas with complex boolean logic
	///
	///
	/// Sometimes using ! for negation can get missed in heavy use of parentheses or the logic would just read better
	/// if one could use a positive term instead of a negative. hasContents is for those times.
	///
	/// Returns true if the Optional collection is not nil, and the colleciton is also not empty.
	public var hasContents: Bool {
		if case .some(let wrapped) = self {
			return !wrapped.isEmpty
		}
		return false
	}
}
