//
//  OptionalTests.swift
//  swiftlets
//
//  Created by Kevin Hayes on 2025-04-27.
//

import Testing
@testable import Swiftlets

@Test func isNil() {
	let a: Int? = nil
	#expect(a.isNil)
	
	let b: String? = "hello"
	#expect(!b.isNil)
}

@Test func isNotNil() {
	let a: Int? = 5
	#expect(a.isNotNil)

	let b: String? = nil
	#expect(!b.isNotNil)
}

@Test func testHasContents() {
	let a: String? = nil
	#expect(a.hasContents == false)

	let b: String? = ""
	#expect(b.hasContents == false)

	let c: String? = "hello"
	#expect(c.hasContents)
}
