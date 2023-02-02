
import Foundation

/// This type serves as a namespace for Geometry-related utility functions.
public enum GeometryToolbox {
    /// - Returns: A point on a circle of radius `radius` rotating `angle` degrees clockwise around the edge.
    public static func pointOnCircle(radius: CGFloat, angleRadians radians: CGFloat) -> CGPoint {
        // https://math.stackexchange.com/a/260115
        CGPoint(x: radius * sin(radians), y: radius * cos(radians))
    }
}

public extension BinaryFloatingPoint {
    /// Utility constant to transform between radians and degrees.
    static var rad2deg: Self { 180 / Self.pi }
    
    /// Utility constant to transform between degrees and radians.
    static var deg2rad: Self { Self.pi / 180 }
}

public extension GeometryToolbox {
    /// Calculates the intersection between two lines, if one exists.
    ///
    /// - Parameters:
    ///   - A1: The first point on the first line.
    ///   - A2: The seond point on the first line.
    ///   - B1: The first point on the second line.
    ///   - B2: The second point on the second line.
    /// - Returns: The intersection between the two line segments, and a boolean value indicating whether an intersection exists.
    static func getIntersectionPoint(
        _ A1: CGPoint, _ A2: CGPoint,
        _ B1: CGPoint, _ B2: CGPoint
    ) -> (CGPoint, Bool) {
        let tmp = (B2.x - B1.x) * (A2.y - A1.y) - (B2.y - B1.y) * (A2.x - A1.x)
        if (tmp == 0) {
            return (CGPoint(), false)
        }
        
        let mu = ((A1.x - B1.x) * (A2.y - A1.y) - (A1.y - B1.y) * (A2.x - A1.x)) / tmp
        return (.init(x: B1.x + (B2.x - B1.x) * mu, y: B1.y + (B2.y - B1.y) * mu), true)
    }
    
    /// The result of a circle-line intersection check,
    enum CircleLineIntersectionResult {
        /// The line does not intersect the circle.
        case NoIntersection
        
        /// The line intersects the circle in a single tangent point.
        case Tangent(CGPoint)
        
        /// The line intersects the circle at two points.
        case Secant(CGPoint, CGPoint)
    }
    
    /// Calculate the intersection point(s) between a line and a circle.
    ///
    /// - Parameters:
    ///   - p: The first point of the line.
    ///   - q: The second point of the line.
    ///   - r: The radius of the circle.
    ///   - c: The center point of the circle.
    /// - Returns: The intersection point(s) between the given line and circle, if any exist.
    static func circleLineIntersections(_ p: CGPoint, _ q: CGPoint, radius r: CGFloat, center c: CGPoint)
        -> CircleLineIntersectionResult
    {
        let dx = q.x - p.x
        let dy = q.y - p.y
        let A = dx*dx + dy*dy
        let B = 2 * (dx * (p.x - c.x) + dy * (p.y - c.y))
        let C = (p.x - c.x) * (p.x - c.x) + (p.y - c.y) * (p.y - c.y) - r * r;
        
        // Determine discriminant
        let discriminant = B*B - 4*A*C
        
        // discriminant < 0: no intersection
        if A.isZero || discriminant < 0 {
            return .NoIntersection
        }
        
        // discriminant == 0: tangent
        if discriminant.isZero {
            let t = -B / (2*A)
            return .Tangent(CGPoint(x: p.x + t*dx, y: p.y + t*dy))
        }
        
        // discriminant > 0: two intersection points
        let t1 = (-B + sqrt(discriminant)) / (2*A)
        let t2 = (-B - sqrt(discriminant)) / (2*A)
        
        return .Secant(
            CGPoint(x: p.x + t1*dx, y: p.y + t1*dy),
            CGPoint(x: p.x + t2*dx, y: p.y + t2*dy)
        )
    }
}

public extension CGRect {
    /// Check whether or not the given line intersects this rectangle.
    ///
    /// - Parameters:
    ///   - start: The first point of the line.
    ///   - end: The second point of the line.
    /// - Returns: The intersection point between this rectangle and the line, or `nil` if they do not intersect.
    func intersectsLine(start: CGPoint, end: CGPoint) -> CGPoint? {
        var (pt, intersects) = GeometryToolbox.getIntersectionPoint(topLeft, topRight, start, end)
        if intersects {
            return pt
        }
        
        (pt, intersects) = GeometryToolbox.getIntersectionPoint(topRight, bottomRight, start, end)
        if intersects {
            return pt
        }
        
        (pt, intersects) = GeometryToolbox.getIntersectionPoint(bottomRight, bottomLeft, start, end)
        if intersects {
            return pt
        }
        
        (pt, intersects) = GeometryToolbox.getIntersectionPoint(bottomLeft, topLeft, start, end)
        if intersects {
            return pt
        }
        
        return nil
    }
}
