
import enum Accelerate.vDSP
import CoreGraphics
import Foundation

public extension CGRect {
    /// The center point of the rectangle.
    var center: CGPoint {
        CGPoint(x: origin.x + (size.width * 0.5), y: origin.y + (size.height * 0.5))
    }
    
    /// The surface area of the rectangle.
    var area: CGFloat {
        width * height
    }
    
    /// Generate a random point inside of or on the edge of this rectangle.
    ///
    /// - Parameter rng: The random number generator to use.
    /// - Returns: A random point inside of or on the edge of this rectangle.
    func randomPoint(using rng: inout ARC4RandomNumberGenerator) -> CGPoint {
        let x = CGFloat.random(in: 0..<self.width)
        let y = CGFloat.random(in: 0..<self.height)
        
        return .init(x: x, y: y)
    }
    
    /// Scale the rect by the given dimensions.
    func scaled(width: CGFloat, height: CGFloat) -> CGRect {
        .init(x: minX * width, y: minY * height,
              width: self.width * width, height: self.height * height)
    }
    
    /// Scale the rect by the given dimensions.
    func scaled(by size: CGSize) -> CGRect {
        scaled(width: size.width, height: size.height)
    }
    
    /// Scale the rect by the given dimensions.
    mutating func scale(width: CGFloat, height: CGFloat) {
        self = self.scaled(width: width, height: height)
    }
    
    /// Scale the rect by the given dimensions.
    mutating func scale(by size: CGSize) {
        self = self.scaled(by: size)
    }
    
    /// Scale outwards from the center by the given amount.
    func scaled(by value: CGFloat) -> CGRect {
        let diagonal = topLeft - center
        let newTopLeft = center + (diagonal * value)
        let newBottomRight = center - (diagonal * value)
        
        return .init(x: newTopLeft.x, y: newTopLeft.y,
                     width: newBottomRight.x - newTopLeft.x,
                     height: newBottomRight.y - newTopLeft.y)
    }
    
    /// Scale outwards from the center by the given amount.
    mutating func scale(by value: CGFloat) {
        self = self.scaled(by: value)
    }
    
    /// The top left corner of this rectangle.
    var topLeft: CGPoint { .init(x: minX, y: minY) }
    
    /// The top right corner of this rectangle.
    var topRight: CGPoint { .init(x: maxX, y: minY) }
    
    /// The bottom left corner of this rectangle.
    var bottomLeft: CGPoint { .init(x: minX, y: maxY) }
    
    /// The bottom right corner of this rectangle.
    var bottomRight: CGPoint { .init(x: maxX, y: maxY) }
    
    /// Expand a bounding box rectangle to contain the given point.
    func expanded(toContain point: CGPoint) -> CGRect {
        let minX = min(self.minX, point.x)
        let minY = min(self.minY, point.y)
        let maxX = max(self.maxX, point.x)
        let maxY = max(self.maxY, point.y)
        
        return .init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.minX)
        hasher.combine(self.minY)
        hasher.combine(self.width)
        hasher.combine(self.height)
    }
}

extension CGPoint {
    /// Scale the point by the given dimensions.
    public mutating func scale(by rhs: Double) {
        x = x * CGFloat(rhs)
        y = y * CGFloat(rhs)
    }
    
    /// Project this unit point into a rectangle.
    public func projectUnitPoint(onto rect: CGRect) -> CGPoint {
        CGPoint(x: self.x * rect.width, y: self.y * rect.height)
    }
    
    public var magnitudeSquared: Double {
        Double((x*x) + (y*y))
    }
    
    public static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    public static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    public static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    public static prefix func - (vector: CGPoint) -> CGPoint {
        return CGPoint(x: -vector.x, y: -vector.y)
    }
}

extension CGSize {
    public mutating func scale(by rhs: Double) {
        width = width * CGFloat(rhs)
        height = height * CGFloat(rhs)
    }
    
    public var magnitudeSquared: Double {
        Double((width*width) + (height*height))
    }
    
    public static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    public static func - (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    public static func += (left: inout CGSize, right: CGSize) {
        left = left + right
    }
    
    public static func -= (left: inout CGSize, right: CGSize) {
        left = left - right
    }
    
    public static prefix func - (vector: CGSize) -> CGSize {
        return CGSize(width: -vector.width, height: -vector.height)
    }
}

public extension CGSize {
    // Scalar-vector multiplication
    static func * (left: CGFloat, right: CGSize) -> CGSize {
        return CGSize(width: right.width * left, height: right.height * left)
    }
    
    static func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }
    
    // Vector-scalar division
    static func / (left: CGSize, right: CGFloat) -> CGSize {
        guard right != 0 else { fatalError("Division by zero") }
        return CGSize(width: left.width / right, height: left.height / right)
    }
    
    // Vector-scalar division assignment
    static func /= (left: inout CGSize, right: CGFloat) -> CGSize {
        guard right != 0 else { fatalError("Division by zero") }
        return CGSize(width: left.width / right, height: left.height / right)
    }
    
    // Scalar-vector multiplication assignment
    static func *= (left: inout CGSize, right: CGFloat) {
        left = left * right
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.width)
        hasher.combine(self.height)
    }
}

public extension CGPoint {
    // Scalar-vector multiplication
    static func * (left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: right.x * left, y: right.y * left)
    }
    
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    // Vector-scalar division
    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        guard right != 0 else { fatalError("Division by zero") }
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    // Vector-scalar division assignment
    static func /= (left: inout CGPoint, right: CGFloat) -> CGPoint {
        guard right != 0 else { fatalError("Division by zero") }
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    // Scalar-vector multiplication assignment
    static func *= (left: inout CGPoint, right: CGFloat) {
        left = left * right
    }
}

public extension CGPoint {
    // Vector magnitude (length)
    var magnitude: CGFloat {
        return sqrt(x*x + y*y)
    }
    
    // Distance between two vectors
    func distance(to vector: CGPoint) -> CGFloat {
        return (self - vector).magnitude
    }
    
    // Vector normalization
    var normalized: CGPoint {
        return CGPoint(x: x / magnitude, y: y / magnitude)
    }
    
    // Dot product of two vectors
    func dot (_ right: CGPoint) -> CGFloat {
        return x * right.x + y * right.y
    }
    
    // Cross product of two vectors.
    func cross(_ right: CGPoint) -> CGFloat {
        return x * right.y - y * right.x
    }
    
    // Angle between two vectors
    // θ = acos(AB)
    func angle(to vector: CGPoint) -> CGFloat {
        return acos(self.normalized.dot(vector.normalized))
    }
    
    // Signed angle between two vectors
    func signedAngle(to vector: CGPoint) -> CGFloat {
        atan2(self.x * vector.y - self.y * vector.x, self.x * vector.x + self.y * vector.y)
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

public extension CGImage {
    /// The size of this image.
    var size: CGSize {
        CGSize(width: self.width, height: self.height)
    }
}
