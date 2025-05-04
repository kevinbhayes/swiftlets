//
//  CollectionTests.swift
//  swiftlets
//
//  Created by Kevin Hayes on 2025-04-27.
//

import Testing
@testable import Swiftlets

func testArray() -> [Int] { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

@Test func safeSubcriptValidIndex() {
	let array = testArray()

	for _ in 0..<8 { // 8 is arbitrary - really only need 1
		let index = Int.random(in: 0..<array.count)
		#expect(array[safe: index] == index)
	}
}

@Test func safeSubcriptInvalidIndex() {
	let array = testArray()

	for _ in 0..<4 { // 8 is arbitrary - really only need 1
		let index = Int.random(in: array.count..<(array.count + 10))
		#expect(array[safe: index] == nil)
	}

	for _ in 0..<4 { // 8 is arbitrary - really only need 1
		let index = Int.random(in: -10..<0)
		#expect(array[safe: index] == nil)
	}
}

@Test func hasContents() {
	let string = "Hello"
	#expect(string.hasContents)

	let other: [Int] = []
	#expect(other.hasContents == false)
}
