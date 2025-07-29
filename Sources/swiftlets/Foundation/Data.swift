//
//  Data.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2025-06-10.
//

import Foundation

extension Data {
	
	/// Base64 encodes Data and percent escapes with urlFragment allowed chracters
	/// - Returns: The encoded and escaped string
	public func base64URLSafeEncodedString(trimPadding: Bool = true) -> String? {
		let string = base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")


		if trimPadding {
			return string.replacingOccurrences(of: "=", with: "")
		}
		return string
	}
}
