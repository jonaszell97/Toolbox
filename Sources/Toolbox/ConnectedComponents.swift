
import Foundation
import CoreGraphics

fileprivate struct Point: Hashable {
    let x, y: Int
}

fileprivate struct DisjointSet {
    var parents: [Point: Point] = [:]
    var sizes: [Point: Int] = [:]
    var ranks: [Point: Int] = [:]
    
    /// Create a set.
    mutating func makeSet(_ x: Point) {
        // if x is not already in the forest then
        guard parents[x] == nil else {
            return
        }
        
        // x.parent := x
        // x.size := 1
        // x.rank := 0
        parents[x] = x
        sizes[x] = 1
        ranks[x] = 0
    }
    
    /// FInd a node.
    mutating func find(_ x: Point) -> Point {
        var x = x
        
        // root := x
        var root = x
        
        // while root.parent ≠ root do
        while let parent = parents[root], parent != root {
            // root := root.parent
            root = parent
        }
        
        // while x.parent ≠ root do
        while let parent = parents[x], parent != root {
            // parent := x.parent
            let parent = parent
            
            // x.parent := root
            parents[x] = root
            
            // x := parent
            x = parent
        }
        
        return root
    }
    
    mutating func union(_ x: Point, _ y: Point) {
        makeSet(x)
        makeSet(y)
        
        // x := Find(x)
        var x = find(x)
        // y := Find(y)
        var y = find(y)
        
        // if x = y then
        if x == y {
            // x and y are already in the same set
            return
        }
        
        // If necessary, rename variables to ensure that
        // x has rank at least as large as that of y
        // if x.rank < y.rank then
        if ranks[x]! < ranks[y]! {
            // (x, y) := (y, x)
            (x, y) = (y, x)
        }
        
        // Make x the new root
        // y.parent := x
        parents[y] = x
        
        // If necessary, increment the rank of x
        // if x.rank = y.rank then
        if ranks[x]! == ranks[y]! {
            // x.rank := x.rank + 1
            ranks[x] = ranks[x]! + 1
        }
    }
}

/// A connected component.
public struct ConnectedComponent {
    /// The bounding box of the region.
    public let boundingBox: CGRect
    
    /// The  points included in this region.
    public let points: Set<CGPoint>
    
    /// The percentage of activated points within the bounding rect.
    public var activationPercentage: CGFloat {
        CGFloat(points.count) / boundingBox.area
    }
    
    /// Whether this region contains a point.
    /// 
    /// - Parameter pt: The point to check.
    /// - Returns: Whether the point is contained in this region.
    public func contains(_ pt: CGPoint) -> Bool {
        guard boundingBox.contains(pt) else {
            return false
        }
        
        return points.contains(pt)
    }
}

/// Utility class for finding connected components in a binary image.
public final class ConnectedComponents {
    public enum ConnectivityType {
        case fourWay
        case eightWay
    }
    
    /// The input pixel values.
    public let values: [Int]
    
    /// The image width.
    public let width: Int
    
    /// The image height.
    public let height: Int
    
    /// The connectivity type.
    public let connectivity: ConnectivityType
    
    /// The last assigned region label.
    var currentLabel = 0
    
    /// The assigned region labels.
    fileprivate var labels: [Point: Int] = [:]
    
    /// The linked labels.
    fileprivate var linked: DisjointSet = DisjointSet()
    
    /// Create a connected components finder.
    public init(values: [Int], width: Int, height: Int, connectivity: ConnectivityType) {
        self.values = values
        self.width = width
        self.height = height
        self.connectivity = connectivity
    }
    
    /// Find the connected components.
    /// 
    /// - Returns: An array of connected components.
    public func findConnectedComponents() -> [ConnectedComponent] {
        self.firstPass()
        self.secondPass()
        
        var boundingBoxes = [Int: CGRect]()
        var points = [Int: Set<CGPoint>]()
        
        for (pt, label) in labels {
            let point = CGPoint(x: CGFloat(pt.x), y: CGFloat(pt.y))
            points.modify(key: label, defaultValue: []) { $0.insert(point) }
            boundingBoxes.modify(key: label, defaultValue: CGRect(origin: point, size: .zero)) { rect in
                rect = rect.expanded(toContain: point)
            }
        }
        
        return boundingBoxes.keys.map { idx in
            let rect = boundingBoxes[idx]!
            return ConnectedComponent(boundingBox: CGRect(origin: rect.origin, size: CGSize(width: rect.width+1, height: rect.height+1)),
                                      points: points[idx]!)
        }
    }
    
    /// Get the neighbors of a pixel.
    private func findNeighbors(of pt: Point, neighbors: inout [Point]) {
        neighbors[0] = .init(x: pt.x - 1, y: pt.y)
        neighbors[1] = .init(x: pt.x + 1, y: pt.y)
        neighbors[2] = .init(x: pt.x, y: pt.y - 1)
        neighbors[3] = .init(x: pt.x, y: pt.y + 1)
        
        guard connectivity == .eightWay else {
            return
        }
        
        neighbors[4] = .init(x: pt.x - 1, y: pt.y - 1)
        neighbors[5] = .init(x: pt.x + 1, y: pt.y - 1)
        neighbors[6] = .init(x: pt.x + 1, y: pt.y + 1)
        neighbors[7] = .init(x: pt.x - 1, y: pt.y + 1)
    }
    
    /// Get the pixel value for given coordinates.
    private func pixelValue(_ pt: Point) -> Int? {
        let index = (pt.y*width) + pt.x
        guard index >= 0, index < values.count else {
            return nil
        }
        
        return values[index]
    }
    
    /// The first pass.
    private func firstPass() {
        var neighbors: [Point] = .init(repeating: .init(x: 0, y: 0), count: connectivity == .fourWay ? 4 : 8)
        for x in 0..<width {
            for y in 0..<height {
                let pt = Point(x: x, y: y)
                guard let value = self.pixelValue(pt), value != 0 else {
                    continue
                }
                
                // neighbors = connected elements with the current element's value
                self.findNeighbors(of: pt, neighbors: &neighbors)
                
                // L = neighbors labels
                let neighboringLabels: [(Point, Int)] = neighbors.compactMap { neighbor in
                    guard let neighborValue = self.pixelValue(neighbor), neighborValue == value, let label = labels[neighbor] else {
                        return nil
                    }
                    
                    return (neighbor, label)
                }
                
                // if neighbors is empty then
                guard !neighboringLabels.isEmpty else {
                    // linked[NextLabel] = set containing NextLabel
                    self.linked.makeSet(pt)
                    
                    // labels[row][column] = NextLabel
                    self.labels[pt] = currentLabel
                    currentLabel += 1
                    
                    continue
                }
                
                // labels[row][column] = min(L)
                let minLabel = neighboringLabels.min { $0.1 < $1.1 }!.1
                self.labels[pt] = minLabel
                
                // for label in L do
                for (neighbor, _) in neighboringLabels {
                    // linked[label] = union(linked[label], L)
                    self.linked.union(pt, neighbor)
                }
            }
        }
    }
    
    /// The second pass.
    private func secondPass() {
        for x in 0..<width {
            for y in 0..<height {
                let pt = Point(x: x, y: y)
                
                // if data[row][column] is not Background then
                guard let value = self.pixelValue(pt), value != 0 else {
                    continue
                }
                
                // labels[row][column] = find(labels[row][column])
                self.labels[pt] = self.labels[self.linked.find(pt)]
            }
        }
    }
}
