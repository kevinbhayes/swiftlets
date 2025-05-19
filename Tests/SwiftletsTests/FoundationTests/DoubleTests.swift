//
//  DoubleTests.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2025-05-17.
//

import Testing
@testable import Swiftlets

@Test func doubleRoundedTwoDecimals() {
	#expect(123.456789.rounded(toPlaces: 2) == 123.46)
	#expect(123.454.rounded(toPlaces: 2) == 123.45)
	#expect(123.456789.rounded(toPlaces: 4) == 123.4568)
	#expect(123.456719.rounded(toPlaces: 4) == 123.4567)
}

@Test func doubleNegativeRounding() {
	#expect(-123.456789.rounded(toPlaces: 2) == -123.46)
	#expect(-123.456789.rounded(toPlaces: 3) == -123.457)
}

@Test func doubleZeroRounding() {
	#expect(120.3457.rounded(toPlaces: 0) == 120)
}

@Test func doubleNegativePlaces() {
	#expect(120.3457.rounded(toPlaces: -2) == 120.3457)
}
