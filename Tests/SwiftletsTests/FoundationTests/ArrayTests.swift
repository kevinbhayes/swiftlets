//
//  ArrayTests.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2026-06-14.
//

import Foundation
import Testing

@Suite struct ArrayTests {
	func makeTestArray() -> [String] {
		["one", "two", "three", "four", "five"]
	}

    @Test func moveElementsForward() {
        var array = makeTestArray()
        let fromIndices = IndexSet([1, 2])
        array.move(from: fromIndices, to: 4)
        
        #expect(array == ["one", "four", "five", "two", "three"])
    }
    
    @Test func moveElementsBackward() {
        var array = makeTestArray()
        let fromIndices = IndexSet([3, 4])
        array.move(from: fromIndices, to: 0)
        
        #expect(array == ["four", "five", "one", "two", "three"])
    }
    
    @Test func moveElementsToSamePosition() {
        var array = makeTestArray()
        let fromIndices = IndexSet([1, 2])
        array.move(from: fromIndices, to: 1)
        
        #expect(array == makeTestArray())
    }
    
    @Test func moveSingleElement() {
        var array = makeTestArray()
        let fromIndices = IndexSet([2])
        array.move(from: fromIndices, to: 0)
        
        #expect(array == ["three", "one", "two", "four", "five"])
    }
    
    @Test func moveNonConsecutiveElements() {
        var array = makeTestArray()
        let fromIndices = IndexSet([0, 2, 4])
        array.move(from: fromIndices, to: 1)
        
        #expect(array == ["two", "one", "three", "five", "four"])
    }
    
    @Test func moveElementsToBeginning() {
        var array = makeTestArray()
        let fromIndices = IndexSet([2, 3])
        array.move(from: fromIndices, to: 0)
        
        #expect(array == ["three", "four", "one", "two", "five"])
    }
    
    @Test func moveElementsToEnd() {
        var array = makeTestArray()
        let fromIndices = IndexSet([0, 1])
        array.move(from: fromIndices, to: 5)
        
        #expect(array == ["three", "four", "five", "one", "two"])
    }
    
    @Test func moveElementsWithInvalidIndices() {
        var array = makeTestArray()
        let fromIndices = IndexSet([0, 10]) // 10 is out of bounds
        array.move(from: fromIndices, to: 2)
        
        #expect(array == ["two", "three", "one", "four", "five"])
    }
    
    @Test func moveElementsWithEmptyIndices() {
        var array = makeTestArray()
        let fromIndices = IndexSet([])
        array.move(from: fromIndices, to: 2)
        
        #expect(array == makeTestArray())
    }
    
    @Test func moveElementsFromEmptyArray() {
        var array: [String] = []
        let fromIndices = IndexSet([0, 1])
        array.move(from: fromIndices, to: 0)
        
        #expect(array == [])
    }
    
    @Test func moveElementsWithOutOfBoundsToIndex() {
        var array = makeTestArray()
        let fromIndices = IndexSet([1, 2])
        array.move(from: fromIndices, to: 10) // Out of bounds, should clamp to end
        
        #expect(array == ["one", "four", "five", "two", "three"])
    }
    
    @Test func moveElementsWithNegativeToIndex() {
        var array = makeTestArray()
        let fromIndices = IndexSet([1, 2])
        array.move(from: fromIndices, to: -5) // Negative, should clamp to beginning
        
        #expect(array == ["two", "three", "one", "four", "five"])
    }
}
