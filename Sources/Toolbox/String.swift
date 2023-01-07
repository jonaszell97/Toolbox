
import Foundation

public extension String {
    /// - returns: A version of this string with the length `length`. If this string is longer than `length`, removes characters from the left.
    ///            If it is shorter, adds the padding character to the left.
    func leftPadding(toExactLength length: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < length {
            return String(repeatElement(character, count: length - stringLength)) + self
        }
        
        return String(self.suffix(length))
    }
    
    /// - returns: A version of this string with the length `length`. If this string is longer than `length`, nothing is changed.
    ///            If it is shorter, adds the padding character to the left.
    func leftPadding(toMinimumLength length: Int, withPad character: Character) -> String {
        let stringLength = self.count
        guard stringLength < length else {
            return self
        }
        
        return String(repeatElement(character, count: length - stringLength)) + self
    }
    
    /// - returns: A version of this string without the given prefix, if it exists.
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // http://www.cse.yorku.ca/~oz/hash.html
    /// - returns: The DJB2 hash of this string.
    var djb2Hash: Int {
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
    /// - returns: A random alphanumeric string of length `length` using the system RNG.
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    /// - returns: A random alphanumeric string of length `length` using a given RNG.
    static func random(length: Int, using rng: inout ARC4RandomNumberGenerator) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement(using: &rng)! })
    }
}

// Make String usable as a Swift Error.
extension String: Error {}

/// Shortened version that doesn't require the comment parameter.
public func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
