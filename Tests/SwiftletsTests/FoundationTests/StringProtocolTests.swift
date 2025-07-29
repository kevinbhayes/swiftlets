//
//  StringProtocolTests.swift
//  swiftlets
//
//  Created by Kevin Hayes on 2025-04-27.
//

import Foundation
import Testing
@testable import Swiftlets

func testString() -> String {
	"Hello from 👩🏼‍🤝‍👩🏾! Good to see you from 👩🏻‍🤝‍👨🏼.";
}

@Test func singleGrapheme() {
	let testString = testString()
	#expect(testString[clusterAt: 11] == "👩🏼‍🤝‍👩🏾")
	#expect(testString[clusterAt: 12] == "!")
}

@Test func testRange() {
	let testString = testString()
	#expect(testString[clusterRange: 26..<37] == "you from 👩🏻‍🤝‍👨🏼.")
}

@Test func testClosedRange() {
	let testString = testString()
	#expect(testString[clusterRange: 26...35] == "you from 👩🏻‍🤝‍👨🏼")
}

@Test func testPartialRangeFrom() {
	let testString = testString()
	#expect(testString[clusterRange: 26...] == "you from 👩🏻‍🤝‍👨🏼.")
}

@Test func testPartialRangeUpTo() {
	let testString = testString()
	#expect(testString[clusterRange: ..<26] == "Hello from 👩🏼‍🤝‍👩🏾! Good to see ")
}

@Test func testPartialRangeThrough() {
	let testString = testString()
	#expect(testString[clusterRange: ...25] == "Hello from 👩🏼‍🤝‍👩🏾! Good to see ")
}
