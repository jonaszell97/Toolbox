
import Foundation

public struct Polygon2D {
    /// The list of points that make up the edges of this polygon.
    public let vertices: [CGPoint]
    
    /// Create a polygon
    public init(vertices: [CGPoint]) {
        self.vertices = vertices
    }
}

extension Polygon2D {
    /// Check whether a polygon contains a point.
    ///
    /// - Parameter pt: The point to test against.
    /// - Returns: True if and only if the point is contained in the polygon.
    public func contains(_ pt: CGPoint) -> Bool {
        let n = vertices.count
        var c = false
        
        var i = 0
        var j = n - 1
        
        while i < n {
            let vert = vertices[i]
            if vert == pt {
                return true
            }
            
            let vert2 = vertices[j]
            if
                (vert.y > pt.y) != (vert2.y > pt.y),
                (pt.x < (vert2.x - vert.x) * (pt.y - vert.y) / (vert2.y - vert.y) + vert.x)
            {
                c.toggle()
            }
            
            j = i
            i += 1
        }
        
        return c
    }
}

extension Polygon2D {
    static func leftSide(from: CGPoint, to: CGPoint, _ p: CGPoint) -> Bool {
        let cross = ((to.x - from.x) * (p.y - from.y) - (to.y - from.y) * (p.x - from.x))
        return cross > 0
    }
    
    /// Create a polygon from the convex hull of points.
    ///
    /// - Parameter points: The points from which a convex hull polygon should be created.
    /// - Returns: The convex hull of the points as a polygon.
    public static func convexHull(of points: Set<CGPoint>) -> Polygon2D {
        guard points.count > 2 else {
            fatalError("at least 2 points must be provided for convex hull")
        }
        
        let ordered = points.sorted { $0.x < $1.x }
        var upper = [ordered[0], ordered[1]]
        
        for i in 2..<ordered.count {
            upper.append(ordered[i])
            
            let l = upper.count
            if l > 2 {
                let p = upper[l - 3]
                let r = upper[l - 2]
                let q = upper[l - 1]
                
                if leftSide(from: p, to: q, r) {
                    upper.remove(at: l - 2)
                }
            }
        }
        
        var lower = [ordered[ordered.count - 1], ordered[ordered.count - 2]]
        for i in (0...ordered.count-3).reversed() {
            lower.append(ordered[i])
            
            let l = lower.count
            if l > 2 {
                let p = lower[l - 3]
                let r = lower[l - 2]
                let q = lower[l - 1]
                
                if leftSide(from: p, to: q, r) {
                    lower.remove(at: l - 2)
                }
            }
        }
        
        lower.remove(at: lower.count - 1)
        lower.remove(at: 0)
        
        upper.append(contentsOf: lower)
        
        return .init(vertices: upper)
    }
}
