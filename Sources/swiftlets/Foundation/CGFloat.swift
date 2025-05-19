//
//  CGFloat.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2025-05-17.
//

import Foundation

extension CGFloat {
	public func rounded(toPlaces decimalPlaces: Int) -> CGFloat {
		guard decimalPlaces >= 0 else {
			return self
		}

		let multiplier = pow(10.0, CGFloat(decimalPlaces))
		return (self * multiplier).rounded() / multiplier
	}
}
