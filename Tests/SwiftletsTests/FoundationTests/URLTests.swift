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

    @Test("extractedRelativePathFrom returns '.' for identical URLs")
    func extractedRelativePath_identical() throws {
        let base = URL(fileURLWithPath: "/Users/username/Documents/")
        let destinationURL = URL(fileURLWithPath: "/Users/username/Documents")
		guard let relativeURL = URL(extractedRelativePathFrom: destinationURL, relativeTo: base) else {
			Issue.record("No relativeURL")
			return
		}
		#expect(relativeURL.relativePath == ".")
		let expectedStandardized = URL(fileURLWithPath: "/Users/username/Documents/.").standardizedFileURL

        #expect(relativeURL.standardizedFileURL == expectedStandardized)
    }

    @Test("extractedRelativePathFrom computes child path relative to base")
    func extractedRelativePath_child() throws {
        let base = URL(fileURLWithPath: "/Users/username/Documents/")
        let destinationURL = URL(fileURLWithPath: "/Users/username/Documents/Projects/App")
		guard let relativeURL = URL(extractedRelativePathFrom: destinationURL, relativeTo: base) else {
			Issue.record("No relativeURL")
			return
		}
        // Expect Projects/App
        #expect(relativeURL.relativePath == "Projects/App")
    }

    @Test("extractedRelativePathFrom computes sibling path using '..'")
    func extractedRelativePath_sibling() throws {
        let base = URL(fileURLWithPath: "/Users/username/Documents/Projects/")
        let destinationURL = URL(fileURLWithPath: "/Users/username/Documents/Notes/")
		guard let relativeURL = URL(extractedRelativePathFrom: destinationURL, relativeTo: base) else {
			Issue.record("No relativeURL")
			return
		}
        // Expect .. / Notes
        #expect(relativeURL.relativePath == "../Notes")
    }

    @Test("extractedRelativePathFrom computes deep traversal with multiple '..'")
    func extractedRelativePath_deepTraversal() throws {
        let base = URL(fileURLWithPath: "/a/b/c/d/")
        let destinationURL = URL(fileURLWithPath: "/a/b/e/f/g")
		guard let relativeURL = URL(extractedRelativePathFrom: destinationURL, relativeTo: base) else {
			Issue.record("No relativeURL")
			return
		}
        // From /a/b/c/d to /a/b/e/f/g is ../../e/f/g
		#expect(relativeURL.relativePath == "../../e/f/g")
    }

    @Test("extractedRelativePathFrom handles base not being a prefix")
    func extractedRelativePath_disjoint() throws {
        let base = URL(fileURLWithPath: "/Users/alice/Documents")
        let destinationURL = URL(fileURLWithPath: "/opt/tools/bin")
		guard let relativeURL = URL(extractedRelativePathFrom: destinationURL, relativeTo: base) else {
			Issue.record("No relativeURL")
			return
		}
        // From /Users/alice/Documents to /opt/tools/bin -> ../../../../opt/tools/bin
		#expect(relativeURL.relativePath == "../../../opt/tools/bin")
    }

    @Test("extractedRelativePathFrom returns nil for non-file URLs")
    func extractedRelativePath_nonFileURL() {
        let base = URL(string: "https://example.com")!
        let destinationURL = URL(fileURLWithPath: "/a/b")
        let relativeURL = URL(extractedRelativePathFrom: destinationURL, relativeTo: base)
        #expect(relativeURL == nil)
    }

}
