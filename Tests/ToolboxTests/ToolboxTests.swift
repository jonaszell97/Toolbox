import XCTest
@testable import Toolbox

final class ToolboxTests: XCTestCase {
    func testClamp() {
        XCTAssertEqual(3,     MathsToolbox.clamp(3.141, lower: 1, upper: 3))
        XCTAssertEqual(3.141, MathsToolbox.clamp(3.141, lower: 1, upper: 5))
        XCTAssertEqual(1,     MathsToolbox.clamp(0.141, lower: 1, upper: 3))
        XCTAssertEqual(3,     MathsToolbox.clamp(3, lower: 1, upper: 3))
        XCTAssertEqual(1,     MathsToolbox.clamp(1, lower: 1, upper: 3))
    }
    
    func testRNGDeterminism() {
        let seeds: [UInt64] = [9281, 28931, 647831, 38130]
        for seed in seeds {
            var baseRng = ARC4RandomNumberGenerator(seed: seed)
            let baseline = [Int](repeating: 0, count: 10).map { _ in baseRng.random(in: Int.min...Int.max) }
            
            for _ in 0..<5 {
                var nextRng = ARC4RandomNumberGenerator(seed: seed)
                XCTAssertEqual([Int](repeating: 0, count: 10).map { _ in nextRng.random(in: Int.min...Int.max) }, baseline)
            }
        }
    }
    
    func testFormatTimeLimit() {
        XCTAssertEqual("00:00", FormatToolbox.formatTimeLimit(0, includeMilliseconds: false))
        XCTAssertEqual("00:00.0", FormatToolbox.formatTimeLimit(0, includeMilliseconds: true))
        
        XCTAssertEqual("00:35", FormatToolbox.formatTimeLimit(35.5, includeMilliseconds: false))
        XCTAssertEqual("00:35.5", FormatToolbox.formatTimeLimit(35.5, includeMilliseconds: true))
        
        XCTAssertEqual("01:35", FormatToolbox.formatTimeLimit(95.5, includeMilliseconds: false))
        XCTAssertEqual("01:35.5", FormatToolbox.formatTimeLimit(95.5, includeMilliseconds: true))
        
        XCTAssertEqual("59:59", FormatToolbox.formatTimeLimit(59*60 + 59.9, includeMilliseconds: false))
        XCTAssertEqual("59:59.9", FormatToolbox.formatTimeLimit(59*60 + 59.9, includeMilliseconds: true))
        
        XCTAssertEqual("01:00:00", FormatToolbox.formatTimeLimit(59*60 + 60, includeMilliseconds: false))
        XCTAssertEqual("01:00:00", FormatToolbox.formatTimeLimit(59*60 + 60, includeMilliseconds: true))
        
        XCTAssertEqual("01:01:35", FormatToolbox.formatTimeLimit(60*60 + 95.7, includeMilliseconds: false))
        XCTAssertEqual("01:01:35", FormatToolbox.formatTimeLimit(60*60 + 95.7, includeMilliseconds: true))
    }
    
    func testVersionFromString() {
        let strings = [
            "1",
            "2.2",
            "0.3.1",
            "0.5.2.1",
            "1.1.1D",
            "1.1D.1",
            "-1.3.5",
            "1.",
            "99.99.99",
            "2101.28.2112",
            "a.b.c",
            "1.a",
        ]
        
        let expected: [VersionTriple?] = [
            .init(major: 1, minor: 0, patch: 0),
            .init(major: 2, minor: 2, patch: 0),
            .init(major: 0, minor: 3, patch: 1),
            nil,
            .init(major: 1, minor: 1, patch: 1),
            nil,
            nil,
            .init(major: 1, minor: 0, patch: 0),
            .init(major: 99, minor: 99, patch: 99),
            .init(major: 2101, minor: 28, patch: 2112),
            nil,
            nil,
        ]
        
        for i in 0..<strings.count {
            XCTAssertEqual(VersionTriple(versionString: strings[i]), expected[i])
        }
    }
    
    func testVersionComparison() {
        XCTAssertLessThan(VersionTriple(major: 1, minor: 1, patch: 0), VersionTriple(major: 1, minor: 1, patch: 1)) // 1.1.0 < 1.1.1
        XCTAssertLessThan(VersionTriple(major: 1, minor: 1, patch: 0), VersionTriple(major: 2, minor: 0, patch: 0)) // 1.1.0 < 2.0.0
        XCTAssertLessThan(VersionTriple(major: 1, minor: 9, patch: 0), VersionTriple(major: 2, minor: 0, patch: 0)) // 1.9.0 < 2.0.0
        XCTAssertLessThan(VersionTriple(major: 0, minor: 0, patch: 1), VersionTriple(major: 0, minor: 0, patch: 2)) // 0.0.1 < 0.0.2
        XCTAssertLessThan(VersionTriple(major: 0, minor: 1, patch: 0), VersionTriple(major: 0, minor: 2, patch: 0)) // 0.1.0 < 0.2.0
        XCTAssertLessThan(VersionTriple(major: 1, minor: 0, patch: 0), VersionTriple(major: 1, minor: 0, patch: 1)) // 1.0.0 < 1.0.1
    }
    
    // MARK: Collections
    
    func testMean() {
        let tests: [([Float], [Float], [Float])] = [
            ([1, 2, 3], [5, 6, 7], [6/3, 11/4, 17/5, 24/6]),
            (
                [5.3, 132.5, 69.2],
                [21.53, 212.84, 6.5],
                [
                    (5.3+132.5+69.2)/3,
                    (5.3+132.5+69.2+21.53)/4,
                    (5.3+132.5+69.2+21.53+212.84)/5,
                    (5.3+132.5+69.2+21.53+212.84+6.5)/6,
                ]
            ),
        ]
        
        for (values, newValues, expectedMeans) in tests {
            var values = values
            var mean = values.mean!
            
            XCTAssertEqual(mean, expectedMeans[0], accuracy: 0.1)
            
            for i in 0..<newValues.count {
                let newValue = newValues[i]
                values.append(newValue)
                
                XCTAssertEqual(values.mean!, expectedMeans[i+1], accuracy: 0.1)
                
                let newMean = Float.updateRunningMean(meanSoFar: mean, valueCountSoFar: values.count - 1, newValue: newValue)
                XCTAssertEqual(newMean, expectedMeans[i+1], accuracy: 0.1)
                
                mean = newMean
            }
        }
    }
    
    func testSetExtensions() {
        let tests: [(Set<Int>, [Int], Int)] = [
            ([1, 2, 3, 4, 5], [1, 3, 8, 9], 2),
            ([1, 2, 3, 4, 5, 8, 9, 10], [1, 3, 8, 9], 0),
            ([1, 2, 3, 4, 5], [0, 10, 18, 8, 9], 5),
        ]
        
        for (values, newValues, expectedNewValueCount) in tests {
            var testValues = values
            
            let newValueCount = testValues.insert(contentsOf: newValues)
            XCTAssertEqual(newValueCount, expectedNewValueCount)
            
            var controlValues = values
            for v in newValues {
                controlValues.insert(v)
            }
            
            XCTAssertEqual(testValues, controlValues)
        }
    }
    
    func testDictionaryExtensions() {
        let tests: [([String: Int], [String: Int], [String: Int])] = [
            (
                ["A": 3,  "B": 94, "C": 90],
                ["A": 21, "B": 5,           "D": 29],
                ["A": 24, "B": 99, "C": 90, "D": 29]
            ),
        ]
        
        for (dict, valuesToAdd, expected) in tests {
            var dict = dict
            dict.add(valuesOf: valuesToAdd)
            
            XCTAssertEqual(dict, expected)
        }
        
        // Modify
        var dict = [
            "A": [1, 2, 3],
            "B": [5],
        ]
        
        dict.modify(key: "A", defaultValue: []) {
            $0.append(4)
        }
        XCTAssertEqual(dict["A"], [1, 2, 3, 4])
        
        dict.modify(key: "B", defaultValue: []) {
            $0.removeAll()
        }
        XCTAssertEqual(dict["B"], [])
        
        dict.modify(key: "C", defaultValue: []) {
            $0 = [6, 7, 8]
        }
        XCTAssertEqual(dict["C"], [6, 7, 8])
        
        dict.modify(key: "D", defaultValue: []) {
            $0 = [6, 7, 8]
        }
        dict.modify(key: "D", defaultValue: []) {
            $0.append(9)
        }
        XCTAssertEqual(dict["D"], [6, 7, 8, 9])
    }
    
    func testArrayExtensions() {
        // Unique
        XCTAssertEqual([1, 2, 2, 3, 4, 4, 5].unique, [1, 2, 3, 4, 5])
        XCTAssertEqual([2, 3, 2, 5, 6, 1, 6].unique, [2, 3, 5, 6, 1])
        XCTAssertEqual([1, 1, 1, 1, 1, 1, 1].unique, [1])
        
        // Chunked
        XCTAssertEqual([1, 2, 3, 4, 5, 6]   .chunked(into: 2              ), [[1, 2], [3, 4], [5, 6]])
        XCTAssertEqual([1, 2, 3, 4, 5, 6, 7].chunked(into: 2              ), [[1, 2], [3, 4], [5, 6], [7]])
        XCTAssertEqual([1, 2, 3, 4, 5, 6, 7].chunked(into: 2, padWith: 999), [[1, 2], [3, 4], [5, 6], [7, 999]])
        
        // isSortedInIncreasingOrder
        XCTAssert([1,2,3].isSortedInIncreasingOrder())
        XCTAssert([1,2,2].isSortedInIncreasingOrder())
        XCTAssert([-1,2,2].isSortedInIncreasingOrder())
        XCTAssert([5,10,1828].isSortedInIncreasingOrder())
        XCTAssert([5].isSortedInIncreasingOrder())
        XCTAssert([Int]().isSortedInIncreasingOrder())
        XCTAssertFalse([3,1,2,3].isSortedInIncreasingOrder())
        XCTAssertFalse([1,3,2].isSortedInIncreasingOrder())
        XCTAssertFalse([-1,3,2].isSortedInIncreasingOrder())
        
        // isSortedInDecreasingOrder
        XCTAssertFalse([1,2,3].isSortedInDecreasingOrder())
        XCTAssertFalse([1,2,2].isSortedInDecreasingOrder())
        XCTAssertFalse([-1,2,2].isSortedInDecreasingOrder())
        XCTAssertFalse([5,10,1828].isSortedInDecreasingOrder())
        XCTAssert([5].isSortedInDecreasingOrder())
        XCTAssert([Int]().isSortedInDecreasingOrder())
        XCTAssertFalse([3,1,2,3].isSortedInDecreasingOrder())
        XCTAssertFalse([1,3,2].isSortedInDecreasingOrder())
        XCTAssertFalse([-1,3,2].isSortedInDecreasingOrder())
        XCTAssert([3,2,1].isSortedInDecreasingOrder())
        XCTAssert([3,2,2].isSortedInDecreasingOrder())
        XCTAssert([3,2,2,-10].isSortedInDecreasingOrder())
    }
    
    func testStringExtensions() {
        // Leftpad
        XCTAssertEqual("hello".leftPadding(toExactLength: 10, withPad: " "), "     hello")
        XCTAssertEqual("   hello".leftPadding(toExactLength: 10, withPad: "X"), "XX   hello")
        
        XCTAssertEqual("hello".leftPadding(toExactLength: 3, withPad: " "), "llo")
        XCTAssertEqual("hello".leftPadding(toMinimumLength: 3, withPad: " "), "hello")
        
        // Rightpad
        XCTAssertEqual("hello".rightPadding(toExactLength: 10, withPad: " "), "hello     ")
        XCTAssertEqual("   hello".rightPadding(toExactLength: 10, withPad: "X"), "   helloXX")
        
        XCTAssertEqual("hello".rightPadding(toExactLength: 3, withPad: " "), "hel")
        XCTAssertEqual("hello".rightPadding(toMinimumLength: 3, withPad: " "), "hello")
        XCTAssertEqual("hello".rightPadding(toMinimumLength: 7, withPad: " "), "hello  ")
    }
}
