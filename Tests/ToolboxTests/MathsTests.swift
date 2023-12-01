
import XCTest
@testable import Toolbox

final class MathsTests: XCTestCase {
    func testRequiredDigitsInt() {
        XCTAssertEqual(1, MathsToolbox.requiredDigits(Optional<Int>.none))
        XCTAssertEqual(1, MathsToolbox.requiredDigits(0))
        XCTAssertEqual(2, MathsToolbox.requiredDigits(10))
        XCTAssertEqual(3, MathsToolbox.requiredDigits(312))
        XCTAssertEqual(5, MathsToolbox.requiredDigits(9_999))
        XCTAssertEqual(6, MathsToolbox.requiredDigits(-9_999))
        XCTAssertEqual(6, MathsToolbox.requiredDigits(-9_872))
        XCTAssertEqual(6, MathsToolbox.requiredDigits(10_000))
        XCTAssertEqual(6, MathsToolbox.requiredDigits(+10_000))
        XCTAssertEqual(7, MathsToolbox.requiredDigits(120_102))
        XCTAssertEqual(7, MathsToolbox.requiredDigits(999_999))
        XCTAssertEqual(8, MathsToolbox.requiredDigits(-120_102))
        XCTAssertEqual(11, MathsToolbox.requiredDigits(231_451_218))
        XCTAssertEqual(11, MathsToolbox.requiredDigits(-31_451_218))
        
        XCTAssertEqual(5, MathsToolbox.requiredDigits(20, base: 2))
        XCTAssertEqual(6, MathsToolbox.requiredDigits(55, base: 2))
        XCTAssertEqual(11, MathsToolbox.requiredDigits(1310, base: 2))
    }
    
    func testRequiredDigitsDecimal() {
        XCTAssertEqual(1, MathsToolbox.requiredDigits(Optional<Decimal>.none))
        XCTAssertEqual(1, MathsToolbox.requiredDigits(Decimal(1.0)))
        XCTAssertEqual(3, MathsToolbox.requiredDigits(Decimal(1.1)))
        XCTAssertEqual(2, MathsToolbox.requiredDigits(Decimal(-1.0)))
        XCTAssertEqual(4, MathsToolbox.requiredDigits(Decimal(-1.1)))
        XCTAssertEqual(6, MathsToolbox.requiredDigits(Decimal(1.1341)))
        XCTAssertEqual(8, MathsToolbox.requiredDigits(Decimal(173.0341)))
        XCTAssertEqual(16, MathsToolbox.requiredDigits(Decimal(1829131.83011234)))
    }
    
    func testClamp() {
        XCTAssertEqual(3,     MathsToolbox.clamp(3.141, lower: 1, upper: 3))
        XCTAssertEqual(3.141, MathsToolbox.clamp(3.141, lower: 1, upper: 5))
        XCTAssertEqual(1,     MathsToolbox.clamp(0.141, lower: 1, upper: 3))
        XCTAssertEqual(3,     MathsToolbox.clamp(3, lower: 1, upper: 3))
        XCTAssertEqual(1,     MathsToolbox.clamp(1, lower: 1, upper: 3))
    }
    
    func testFactorial() {
        XCTAssertEqual(1,         MathsToolbox.factorial(-12912))
        XCTAssertEqual(1,         MathsToolbox.factorial(0))
        XCTAssertEqual(1,         MathsToolbox.factorial(1))
        XCTAssertEqual(2,         MathsToolbox.factorial(2))
        XCTAssertEqual(6,         MathsToolbox.factorial(3))
        XCTAssertEqual(120,       MathsToolbox.factorial(5))
        XCTAssertEqual(40_320,    MathsToolbox.factorial(8))
        XCTAssertEqual(3_628_800, MathsToolbox.factorial(10))
    }
    
    func testRoundToMultipleInt() {
        XCTAssertEqual(15, 13.4.roundedUp(toMultipleOf: 5))
        XCTAssertEqual(10, 13.4.roundedDown(toMultipleOf: 5))
        XCTAssertEqual(14, 13.4.roundedUp(toMultipleOf: 2))
        XCTAssertEqual(12, 13.4.roundedDown(toMultipleOf: 2))
        XCTAssertEqual(10, 10.roundedUp(toMultipleOf: 2))
        XCTAssertEqual(10, 10.roundedDown(toMultipleOf: 2))
        
        XCTAssertEqual(5, 5.roundedUp(toMultipleOf: 5))
        XCTAssertEqual(5, 3.roundedUp(toMultipleOf: 5))
        XCTAssertEqual(5, 1.roundedUp(toMultipleOf: 5))
        XCTAssertEqual(5, 6.roundedDown(toMultipleOf: 5))
        XCTAssertEqual(5, 9.roundedDown(toMultipleOf: 5))
        
        XCTAssertEqual(0, 0.roundedDown(toMultipleOf: 5))
        XCTAssertEqual(0, 0.roundedDown(toMultipleOf: 12134))
        XCTAssertEqual(0, 0.roundedUp(toMultipleOf: 21893))
        
        XCTAssertEqual(56, 54.roundedUp(toMultipleOf: 7))
        XCTAssertEqual(56, 60.roundedDown(toMultipleOf: 7))
        
        XCTAssertEqual(-5, (-1).roundedDown(toMultipleOf: 5))
        XCTAssertEqual(-25, (-27).roundedUp(toMultipleOf: 5))
    }
    
    func testRoundToMultipleDouble() {
        XCTAssertEqual(5.0, (4.7).roundedUp(toMultipleOf: 5))
        XCTAssertEqual(5.0, 3.roundedUp(toMultipleOf: 5))
        XCTAssertEqual(5.0, 1.roundedUp(toMultipleOf: 5))
        XCTAssertEqual(5.0, (6.125).roundedDown(toMultipleOf: 5))
        XCTAssertEqual(5.0, 9.roundedDown(toMultipleOf: 5))
        
        XCTAssertEqual(0.0, 0.roundedDown(toMultipleOf: 5))
        XCTAssertEqual(0.0, 0.roundedDown(toMultipleOf: 12134))
        XCTAssertEqual(0.0, 0.roundedUp(toMultipleOf: 21893))
        
        XCTAssertEqual(56.0, (55.9).roundedUp(toMultipleOf: 7))
        XCTAssertEqual(56.0, 60.roundedDown(toMultipleOf: 7))
        
        XCTAssertEqual(-5.0, (-1.5).roundedDown(toMultipleOf: 5))
        XCTAssertEqual(-5.0, (-4.99).roundedDown(toMultipleOf: 5))
        XCTAssertEqual(-25.0, (-27).roundedUp(toMultipleOf: 5))
        XCTAssertEqual(-25.0, (-25.001).roundedUp(toMultipleOf: 5))
    }
    
    func testPolygonContains() {
        let points: [CGPoint] = [
            .init(x: 0, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
            .init(x: 0, y: 0),
        ]
        
        let insidePoints: [CGPoint] = [
            .init(x: 0.5, y: 0.5),
            .init(x: 0, y: 0.5),
            .init(x: 0.5, y: 0),
            .init(x: 0, y: 0),
        ]
        
        let outsidePoints: [CGPoint] = [
            .init(x: 2, y: 0),
            .init(x: 0, y: 1.1),
            .init(x: 1.1, y: 1.1),
            .init(x: 0, y: 2),
        ]
        
        let multipliers: [CGFloat] = [1, 0.5, 1.5, 2, 5, 10, 100]
        for multiplier in multipliers {
            let polygon = Polygon2D(vertices: points.map { $0 * multiplier })
            for pt in insidePoints {
                XCTAssert(polygon.contains(pt * multiplier))
            }
            for pt in outsidePoints {
                XCTAssertFalse(polygon.contains(pt * multiplier))
            }
        }
        
        for multiplier in multipliers {
            let polygon = Polygon2D.convexHull(of: Set(points.map { $0 * multiplier }))
            for pt in insidePoints {
                XCTAssert(polygon.contains(pt * multiplier))
            }
            for pt in outsidePoints {
                XCTAssertFalse(polygon.contains(pt * multiplier))
            }
        }
    }
    
    func testConvexHull() {
        let points: [CGPoint] = [
            .init(x: 0, y: 0.5),
            .init(x: 0.5, y: 1),
            .init(x: 1, y: 0.5),
            .init(x: 0.5, y: 0),
            .init(x: 0, y: 0.5),
        ]
        
        let insidePoints: [CGPoint] = [
            .init(x: 0.5, y: 0.5),
            .init(x: 0, y: 0.5),
            .init(x: 0.5, y: 0),
        ]
        
        let outsidePoints: [CGPoint] = [
            .init(x: 0, y: 0),
            .init(x: 1, y: 1),
        ]
        
        let multipliers: [CGFloat] = [1, 0.5, 1.5, 2, 5, 10, 100]
        for multiplier in multipliers {
            let polygon = Polygon2D.convexHull(of: Set(points.map { $0 * multiplier }))
            for pt in insidePoints {
                XCTAssert(polygon.contains(pt * multiplier))
            }
            for pt in outsidePoints {
                XCTAssertFalse(polygon.contains(pt * multiplier))
            }
        }
    }
    
    func testRectDistance() {
        let r1 = CGRect(x: 0, y: 0, width: 5, height: 5)
        let r2 = CGRect(x: 1, y: 1, width: 3, height: 6)
        let r3 = CGRect(x: 6, y: 6, width: 3, height: 6)
        
        XCTAssertEqual(r1.distance(to: r1), 0)
        XCTAssertEqual(r1.distance(to: r2), 0)
        XCTAssertEqual(r1.distance(to: r3), sqrt(2))
        
        XCTAssertEqual(r2.distance(to: r3), 2)
    }
}
