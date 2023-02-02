
import Foundation

/// A semantic versioning-compliant version triple.
public struct VersionTriple: Codable, Hashable {
    /// The major version number.
    public let major: Int
    
    /// The minor version number.
    public let minor: Int
    
    /// The patch version number.
    public let patch: Int
    
    /// Memberwise initializer.
    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension VersionTriple: CustomStringConvertible {
    /// Initialize from a string.
    public init?(versionString: String) {
        #if DEBUG
        var versionString = versionString
        if versionString.last == "D" {
            _ = versionString.removeLast()
        }
        #endif
        
        let split = versionString.split(separator: ".")
        let versionNumbers = split.compactMap { Int($0, radix: 10) }.filter { $0 >= 0 }
        
        if versionNumbers.count == 0 || versionNumbers.count != split.count {
            return nil
        }
        
        switch versionNumbers.count {
        case 1:
            self.major = versionNumbers[0]
            self.minor = 0
            self.patch = 0
        case 2:
            self.major = versionNumbers[0]
            self.minor = versionNumbers[1]
            self.patch = 0
        case 3:
            self.major = versionNumbers[0]
            self.minor = versionNumbers[1]
            self.patch = versionNumbers[2]
        default:
            return nil
        }
    }
    
    public var description: String {
        var str = "\(major).\(minor)\(patch > 0 ? ".\(patch)" : "")"
        #if DEBUG
        str += "D"
        #endif
        
        return str
    }
}

extension VersionTriple: Comparable {
    public static func < (lhs: VersionTriple, rhs: VersionTriple) -> Bool {
        if lhs.major < rhs.major {
            return true
        }
        
        if lhs.major > rhs.major {
            return false
        }
        
        if lhs.minor < rhs.minor {
            return true
        }
        
        if lhs.minor > rhs.minor {
            return false
        }
        
        return lhs.patch < rhs.patch
    }
}
