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

@Test
func singleGrapheme() {
	let testString = testString()
	#expect(testString[clusterAt: 11] == "👩🏼‍🤝‍👩🏾")
	#expect(testString[clusterAt: 12] == "!")
}

@Test
func testRange() {
	let testString = testString()
	#expect(testString[clusterRange: 26..<37] == "you from 👩🏻‍🤝‍👨🏼.")
}

@Test
func testClosedRange() {
	let testString = testString()
	#expect(testString[clusterRange: 26...35] == "you from 👩🏻‍🤝‍👨🏼")
}

@Test
func testPartialRangeFrom() {
	let testString = testString()
	#expect(testString[clusterRange: 26...] == "you from 👩🏻‍🤝‍👨🏼.")
}

@Test
func testPartialRangeUpTo() {
	let testString = testString()
	#expect(testString[clusterRange: ..<26] == "Hello from 👩🏼‍🤝‍👩🏾! Good to see ")
}

@Test
func testPartialRangeThrough() {
	let testString = testString()
	#expect(testString[clusterRange: ...25] == "Hello from 👩🏼‍🤝‍👩🏾! Good to see ")
}

@Test
func testBase64URLSafeDecoded_urlSafe() throws {
    let standardBase64 = "TWFuKy9Gb28/" // contains '+' and '/'

    // Convert standard to URL-safe by replacing '+' -> '-' and '/' -> '_', and drop '=' padding if any
    let urlSafe = standardBase64
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")

	let data = try #require(urlSafe.base64URLSafeDecoded)
    let string = try #require(String(data: data, encoding: .utf8))
    // The decoded string should match the original UTF-8 payload
    #expect(string == "Man+/Foo?")
}

@Test
func testBase64URLSafeDecoded_invalid() {
	let invalid = "not_base64!@#"
	let data = invalid.base64URLSafeDecoded
	#expect(data == nil)
}

@Test
func testBase64URLSafeDecoded_standard() throws {
	// "Hello world" -> Base64 standard
	let base64 = "SGVsbG8gd29ybGQ="
	let data = try #require(base64.base64URLSafeDecoded)
	let string = try #require(String(data: data, encoding: .utf8))
	#expect(string == "Hello world")
}

@Test
func testBase64URLSafeDecoded_missingPadding() throws {
	// "Hello" -> Base64 standard: "SGVsbG8="; remove padding to simulate missing '='
	let missingPadding = "SGVsbG8"
	let data = try #require(missingPadding.base64URLSafeDecoded)
	let string = try #require(String(data: data, encoding: .utf8))
	#expect(string == "Hello")
}

@Test
func testBase64URLSafeDecoded_urlSafeMissingPadding() throws {
	// "foobar" -> standard: "Zm9vYmFy"; URL-safe identical here; deliberately no padding needed
	let urlSafeNoPadding = "Zm9vYmFy"
	let data = try #require(urlSafeNoPadding.base64URLSafeDecoded)
	let string = try #require(String(data: data, encoding: .utf8))
	#expect(string == "foobar")
}
