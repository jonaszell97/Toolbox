
import Foundation

public extension String {
    /// - Returns: A version of this string with the length `length`. If this string is longer than `length`, removes characters from the left.
    ///            If it is shorter, adds the padding character to the left.
    func leftPadding(toExactLength length: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < length {
            return String(repeatElement(character, count: length - stringLength)) + self
        }
        
        return String(self.suffix(length))
    }
    
    /// - Returns: A version of this string with the length `length`. If this string is longer than `length`, nothing is changed.
    ///            If it is shorter, adds the padding character to the left.
    func leftPadding(toMinimumLength length: Int, withPad character: Character) -> String {
        let stringLength = self.count
        guard stringLength < length else {
            return self
        }
        
        return String(repeatElement(character, count: length - stringLength)) + self
    }
    
    /// - Returns: A version of this string with the length `length`. If this string is longer than `length`, removes characters from the left.
    ///            If it is shorter, adds the padding character to the right.
    func rightPadding(toExactLength length: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < length {
            return self + String(repeatElement(character, count: length - stringLength))
        }
        
        return String(self.prefix(length))
    }
    
    /// - Returns: A version of this string with the length `length`. If this string is longer than `length`, nothing is changed.
    ///            If it is shorter, adds the padding character to the right.
    func rightPadding(toMinimumLength length: Int, withPad character: Character) -> String {
        let stringLength = self.count
        guard stringLength < length else {
            return self
        }
        
        return self + String(repeatElement(character, count: length - stringLength))
    }
    
    /// - Returns: A version of this string without the given prefix, if it exists.
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    /// - Returns: The DJB2 hash of this string.
    var djb2Hash: Int {
        // http://www.cse.yorku.ca/~oz/hash.html
        var hash = 5381
        for character in self {
            guard let ascii = character.asciiValue else {
                continue
            }
            
            let c = Int(ascii)
            hash = ((hash &<< 5) &+ hash) &+ c
        }
        
        return hash
    }
}

public extension String {
    /// - Returns: A random alphanumeric string of length `length` using the system RNG.
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    /// - Returns: A random alphanumeric string of length `length` using a given RNG.
    static func random(length: Int, using rng: inout ARC4RandomNumberGenerator) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement(using: &rng)! })
    }
}

// Make String usable as a Swift Error.
extension String: Error {}

/// Shortened version of `NSLocalizedString(_:comment:)` that omits the comment parameter.
public func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
