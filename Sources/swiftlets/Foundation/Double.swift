//
//  Double.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2025-05-17.
//

import Foundation

extension Double {
	public func rounded(toPlaces decimalPlaces: Int) -> Double {
		guard decimalPlaces >= 0 else {
			return self
		}

		let multiplier = pow(10.0, Double(decimalPlaces))
		return (self * multiplier).rounded() / multiplier
	}
}
