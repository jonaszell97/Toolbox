import XCTest
@testable import Toolbox

final class CCTests: XCTestCase {
    func connectedComponentsTest(regions: [Int], width: Int, height: Int, connectivity: ConnectedComponents.ConnectivityType) {
        let cc = ConnectedComponents(values: regions, width: width, height: height, connectivity: connectivity)
        
        let regionRects = cc.findConnectedComponents()
        var regionMapping = [Int: Int]()
        
        for x in 0..<width {
            for y in 0..<height {
                let pt = CGPoint(x: CGFloat(x), y: CGFloat(y))
                
                let index = (y*width)+x
                guard regions[index] != 0 else {
                    continue
                }
                
                let regionIndex = regions[index]
                
                var foundRegion = false
                for (i, rect) in regionRects.enumerated() {
                    guard rect.boundingBox.contains(pt) else {
                        continue
                    }
                    guard rect.points.contains(pt) else {
                        continue
                    }
                    
                    foundRegion = true
                    
                    if let existingMapping = regionMapping[i] {
                        XCTAssertEqual(existingMapping, regionIndex, "conflicting regions for \(pt): \(existingMapping) <-> \(regionIndex)")
                    }
                    else {
                        XCTAssertNil(regionMapping.values.first { $0 == regionIndex }, "duplicate region \(regionIndex)")
                        regionMapping[i] = regionIndex
                    }
                    
                    break
                }
                
                XCTAssertTrue(foundRegion, "region not found for \(pt)")
            }
        }
    }
    
    func testConnectedComponents() {
        connectedComponentsTest(regions: [
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
        ], width: 5, height: 5, connectivity: .fourWay)
        
        connectedComponentsTest(regions: [
            1, 1, 0,
            0, 0, 0,
            0, 2, 2,
        ], width: 3, height: 3, connectivity: .fourWay)
        connectedComponentsTest(regions: [
            1, 0, 0,
            0, 1, 1,
            0, 1, 1,
        ], width: 3, height: 3, connectivity: .eightWay)
        connectedComponentsTest(regions: [
            2, 0, 0,
            0, 1, 1,
            0, 1, 1,
        ], width: 3, height: 3, connectivity: .fourWay)
        
        connectedComponentsTest(regions: [
            1, 1, 1,
            0, 0, 0,
            2, 2, 2,
        ], width: 3, height: 3, connectivity: .fourWay)
        
        connectedComponentsTest(regions: [
            1, 1, 1,
            0, 1, 0,
            1, 1, 1,
        ], width: 3, height: 3, connectivity: .eightWay)
        
        connectedComponentsTest(regions: [
            1, 1, 0, 0, 0,
            1, 1, 0, 2, 0,
            1, 1, 0, 2, 0,
            0, 0, 0, 0, 0,
            0, 0, 3, 3, 3,
        ], width: 5, height: 5, connectivity: .fourWay)
        connectedComponentsTest(regions: [
            1, 1, 0, 0, 0,
            1, 1, 0, 2, 0,
            1, 1, 0, 2, 0,
            0, 0, 0, 0, 0,
            0, 0, 3, 3, 3,
        ], width: 5, height: 5, connectivity: .eightWay)
        
        connectedComponentsTest(regions: [
            1, 1, 0, 0, 4,
            1, 1, 0, 2, 0,
            1, 1, 0, 2, 0,
            0, 0, 0, 0, 0,
            0, 0, 3, 3, 3,
        ], width: 5, height: 5, connectivity: .fourWay)
        connectedComponentsTest(regions: [
            1, 1, 0, 0, 2,
            1, 1, 0, 2, 0,
            1, 1, 0, 2, 0,
            0, 0, 0, 0, 0,
            0, 0, 3, 3, 3,
        ], width: 5, height: 5, connectivity: .eightWay)
        
        connectedComponentsTest(regions: [
            1, 0, 2, 0, 3,
            0, 4, 0, 5, 0,
            6, 0, 7, 0, 8,
            0, 9, 0, 10, 0,
            11, 0, 12, 0, 13,
        ], width: 5, height: 5, connectivity: .fourWay)
        
        connectedComponentsTest(regions: [
            1, 1, 4, 0, 0,
            1, 1, 4, 2, 0,
            1, 1, 4, 2, 0,
            0, 0, 5, 5, 0,
            0, 0, 3, 3, 3,
        ], width: 5, height: 5, connectivity: .fourWay)
        
        connectedComponentsTest(regions: [
            1, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 5, 5, 5, 0, 0, 0, 3,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 3,
            0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 5, 0, 5, 0, 0, 0, 3,
            0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 6, 0, 5, 5, 5, 5, 5, 0, 3,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 3,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3,
            3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
        ], width: 20, height: 10, connectivity: .fourWay)
    }
}
