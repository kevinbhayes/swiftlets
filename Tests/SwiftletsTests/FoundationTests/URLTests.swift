//
//  URLTests.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2026-05-02.
//

import Foundation
import Testing
@testable import Swiftlets

@Suite struct URLTests {

    @Test("isParent with exact match should return true when allowExactMatch is true")
    func isParentWithExactMatch() {
        // Test case where parent and child are exact matches with allowExactMatch = true
        let parentURL = URL(fileURLWithPath: "/Users/username/Documents")
        let childURL = URL(fileURLWithPath: "/Users/username/Documents")
        
        #expect(parentURL.isParent(of: childURL, allowExactMatch: true))
    }

    @Test("isParent without exact match should return false when allowExactMatch is false")
    func isParentWithoutExactMatch() {
        // Test case where parent and child are exact matches with allowExactMatch = false
        let parentURL = URL(fileURLWithPath: "/Users/username/Documents")
        let childURL = URL(fileURLWithPath: "/Users/username/Documents")
        
        #expect(parentURL.isParent(of: childURL, allowExactMatch: false) == false)
        
        // Test case where parent is actually a parent of child
        let parentURL2 = URL(fileURLWithPath: "/Users/username")
        let childURL2 = URL(fileURLWithPath: "/Users/username/Documents/project")
        
        #expect(parentURL2.isParent(of: childURL2, allowExactMatch: false) == true)
        
        // Test case where parent is not a parent of child
        let parentURL3 = URL(fileURLWithPath: "/Users/username/Documents")
        let childURL3 = URL(fileURLWithPath: "/Users/username/Downloads")
        
        #expect(parentURL3.isParent(of: childURL3, allowExactMatch: false) == false)
        
        // Test case with non-file URLs (should return false)
        let httpURL = URL(string: "https://example.com")
        let childURL4 = URL(fileURLWithPath: "/Users/username/Documents")
        
        #expect(httpURL?.isParent(of: childURL4, allowExactMatch: false) == false)
    }
}
