//
//  CGFloatTests.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2025-05-17.
//

import Foundation
import Testing
@testable import Swiftlets

@Test func CGFloatRoundedTwoDecimals() {
	#expect(CGFloat(123.456789).rounded(toPlaces: 2) == CGFloat(123.46))
	#expect(CGFloat(123.454).rounded(toPlaces: 2) == CGFloat(123.45))
	#expect(CGFloat(123.456789).rounded(toPlaces: 4) == CGFloat(123.4568))
	#expect(CGFloat(123.456719).rounded(toPlaces: 4) == CGFloat(123.4567))
}

@Test func CGFloatNegativeRounding() {
	#expect(CGFloat(-123.456789).rounded(toPlaces: 2) == CGFloat(-123.46))
	#expect(CGFloat(-123.456789).rounded(toPlaces: 3) == CGFloat(-123.457))
}

@Test func CGFloatZeroRounding() {
	#expect(CGFloat(120.3457).rounded(toPlaces: 0) == CGFloat(120))
}

@Test func CGFloatNegativePlaces() {
	#expect(CGFloat(120.3457).rounded(toPlaces: -2) == CGFloat(120.3457))
}
