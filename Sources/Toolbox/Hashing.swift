
import Foundation

/// This type provides common utilities for hashing.
public enum HashingToolbox {
    /// Combine two hash values to form a new one.
    ///
    /// - Parameters:
    ///   - lhs: The first hash value. This is also where the result is stored.
    ///   - rhs: The second hash value.
    public static func combineHashes(_ lhs: inout Int, _ rhs: Int) {
        // https://stackoverflow.com/questions/2590677/how-do-i-combine-hash-values-in-c0x
        lhs ^= rhs &+ 0x9e3779b9 &+ (lhs &<< 6) &+ (lhs &>> 2)
    }
}

/// Protocol for values that provide a hash value that is consistent across app launches.
public protocol StableHashable: Hashable {
    /// The stable hash value, i.e. one that is the same across launches.
    var stableHash: Int { get }
}

public extension StableHashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.stableHash)
    }
}

extension Int: StableHashable {
    public var stableHash: Int {
        self
    }
}

extension String: StableHashable {
    public var stableHash: Int {
        self.djb2Hash
    }
}

extension Double: StableHashable {
    public var stableHash: Int {
        Int(truncatingIfNeeded: self.bitPattern)
    }
}

extension Decimal: StableHashable {
    public var stableHash: Int {
        doubleValue.stableHash
    }
}

extension Bool: StableHashable {
    public var stableHash: Int {
        self ? 1 : 0
    }
}

extension Optional: StableHashable where Wrapped: StableHashable {
    public var stableHash: Int {
        switch self {
        case .none:
            return 0
        case .some(let wrapped):
            return wrapped.stableHash
        }
    }
}

extension Array: StableHashable where Element: StableHashable {
    public var stableHash: Int {
        var hash = 0
        for e in self {
            HashingToolbox.combineHashes(&hash, e.stableHash)
        }
        
        return hash
    }
}
