
import Foundation

// Adapted from Swift.Tensorflow
public struct ARC4RandomNumberGenerator: RandomNumberGenerator, Codable {
    /// A shared RNG instance.
    public static var shared = ARC4RandomNumberGenerator()
    
    var state: [UInt8] = Array(0...255)
    var iPos: UInt8 = 0
    var jPos: UInt8 = 0
    public let seed: [UInt8]
    
    /// Initialize ARC4RandomNumberGenerator using an array of UInt8. The array
    /// must have length between 1 and 256 inclusive.
    public init(seed: [UInt8]) {
        precondition(seed.count > 0, "Length of seed must be positive")
        precondition(seed.count <= 256, "Length of seed must be at most 256")
        
        self.seed = seed
        
        var j: UInt8 = 0
        for i: UInt8 in 0...255 {
            j &+= S(i) &+ seed[Int(i) % seed.count]
            swapAt(i, j)
        }
    }
    
    public init(seed seedValue: UInt64) {
        var seed = [UInt8](repeating: 0, count: 8)
        for i in 0..<8 {
            seed[i] = UInt8((seedValue >> (UInt64(i) * 8)) & 0xFF)
        }
        
        self.init(seed: seed)
    }
    
    public init() {
        self.init(seed: UInt64.random(in: UInt64.min...UInt64.max))
    }
    
    public mutating func reset() {
        self = .init(seed: seed)
    }
    
    /// Produce the next random UInt64 from the stream, and advance the internal state.
    public mutating func next() -> UInt64 {
        var result: UInt64 = 0
        for _ in 0..<UInt64.bitWidth / UInt8.bitWidth {
            result <<= UInt8.bitWidth
            result += UInt64(nextByte())
        }
        
        return result
    }
    
    /// Helper to access the state.
    private func S(_ index: UInt8) -> UInt8 {
        return state[Int(index)]
    }
    
    /// Helper to swap elements of the state.
    private mutating func swapAt(_ i: UInt8, _ j: UInt8) {
        state.swapAt(Int(i), Int(j))
    }
    
    /// Generates the next byte in the keystream.
    private mutating func nextByte() -> UInt8 {
        iPos &+= 1
        jPos &+= S(iPos)
        swapAt(iPos, jPos)
        return S(S(iPos) &+ S(jPos))
    }
}

extension ARC4RandomNumberGenerator {
    /// Generate a random integer in a range .
    public mutating func random(in range: Range<Int>) -> Int {
        Int.random(in: range, using: &self)
    }
    
    /// Generate a random integer in a range .
    public mutating func random(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range, using: &self)
    }
    
    /// Generate a random integer in a range while tossing those that fulfull an exclusion condition.
    public mutating func random(in range: Range<Int>, shouldExclude: (Int) -> Bool, _ tries: Int = 0) -> Int {
        let value = Int.random(in: range, using: &self)
        if shouldExclude(value) && tries < 10 {
            return random(in: range, shouldExclude: shouldExclude, tries + 1)
        }
        
        return value
    }
    
    /// Generate a random integer in a range while tossing those that fulfull an exclusion condition.
    public mutating func random(in range: ClosedRange<Int>, shouldExclude: (Int) -> Bool, _ tries: Int = 0) -> Int {
        let value = Int.random(in: range, using: &self)
        if shouldExclude(value) && tries < 10 {
            return random(in: range, shouldExclude: shouldExclude, tries + 1)
        }
        
        return value
    }
    
    /// Generate a random integer in a range while tossing those that are evenly divisible by a given integer.
    public mutating func random(in range: Range<Int>, excludingRemainder: Int, _ tries: Int = 0) -> Int {
        let value = Int.random(in: range, using: &self)
        if value % excludingRemainder == 0 && tries < 10 {
            return random(in: range, excludingRemainder: excludingRemainder, tries + 1)
        }
        
        return value
    }
    
    /// Generate a random integer in a range while tossing those that are evenly divisible by a given integer.
    public mutating func random(in range: ClosedRange<Int>, excludingRemainder: Int, _ tries: Int = 0) -> Int {
        let value = Int.random(in: range, using: &self)
        if value % excludingRemainder == 0 && tries < 10 {
            return random(in: range, excludingRemainder: excludingRemainder, tries + 1)
        }
        
        return value
    }
    
    /// Generate a random integer in a range while tossing those that are evenly divisible by a given integer.
    public mutating func random(in range: Range<Int>, excluding: [Int], _ tries: Int = 0) -> Int {
        let value = Int.random(in: range, using: &self)
        if excluding.contains(value) && tries < 10 {
            return random(in: range, excluding: excluding, tries + 1)
        }
        
        return value
    }
    
    /// Generate a random integer in a range while tossing those that are evenly divisible by a given integer.
    public mutating func random(in range: ClosedRange<Int>, excluding: [Int], _ tries: Int = 0) -> Int {
        let value = Int.random(in: range, using: &self)
        if excluding.contains(value) && tries < 10 {
            return random(in: range, excluding: excluding, tries + 1)
        }
        
        return value
    }
}

public extension Bool {
    /// - returns `true` with a probability determined by a parameter.
    static func trueWithProbability(_ probability: Double, using rng: inout ARC4RandomNumberGenerator) -> Bool {
        let value = Double.random(in: 0...1, using: &rng)
        return value < probability
    }
    
    /// - returns `true` with a probability determined by a parameter.
    static func trueWithProbability(_ probability: Double) -> Bool {
        trueWithProbability(probability, using: &ARC4RandomNumberGenerator.shared)
    }
}

