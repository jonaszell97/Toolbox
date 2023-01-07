
import Foundation

/// Kinda makes you wish that Swift had variadic generics.
public extension KeyedEncodingContainer {
    mutating func encodeValues<V1: Encodable, V2: Encodable>(
        _ v1: V1,
        _ v2: V2,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
    }
    
    mutating func encodeValues<V1: Encodable, V2: Encodable, V3: Encodable>(
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
        try container.encode(v3)
    }
    
    mutating func encodeValues<V1: Encodable, V2: Encodable, V3: Encodable, V4: Encodable>(
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
        try container.encode(v3)
        try container.encode(v4)
    }
    
    mutating func encodeValues<V1: Encodable, V2: Encodable, V3: Encodable, V4: Encodable, V5: Encodable>(
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
        try container.encode(v3)
        try container.encode(v4)
        try container.encode(v5)
    }
    
    mutating func encodeValues<V1: Encodable, V2: Encodable, V3: Encodable, V4: Encodable, V5: Encodable, V6: Encodable>(
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
        try container.encode(v3)
        try container.encode(v4)
        try container.encode(v5)
        try container.encode(v6)
    }
    
    mutating func encodeValues<V1: Encodable, V2: Encodable, V3: Encodable, V4: Encodable, V5: Encodable, V6: Encodable, V7: Encodable>(
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        _ v7: V7,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
        try container.encode(v3)
        try container.encode(v4)
        try container.encode(v5)
        try container.encode(v6)
        try container.encode(v7)
    }
}

public extension KeyedDecodingContainer {
    func decodeValues<V1: Decodable, V2: Decodable>(
        for key: Key
    ) throws -> (V1, V2) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self)
        )
    }
    
    func decodeValues<V1: Decodable, V2: Decodable, V3: Decodable>(
        for key: Key
    ) throws -> (V1, V2, V3) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self),
            try container.decode(V3.self)
        )
    }
    
    func decodeValues<V1: Decodable, V2: Decodable, V3: Decodable, V4: Decodable>(
        for key: Key
    ) throws -> (V1, V2, V3, V4) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self),
            try container.decode(V3.self),
            try container.decode(V4.self)
        )
    }
    
    func decodeValues<V1: Decodable, V2: Decodable, V3: Decodable, V4: Decodable, V5: Decodable>(
        for key: Key
    ) throws -> (V1, V2, V3, V4, V5) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self),
            try container.decode(V3.self),
            try container.decode(V4.self),
            try container.decode(V5.self)
        )
    }
    
    func decodeValues<V1: Decodable, V2: Decodable, V3: Decodable, V4: Decodable, V5: Decodable, V6: Decodable>(
        for key: Key
    ) throws -> (V1, V2, V3, V4, V5, V6) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self),
            try container.decode(V3.self),
            try container.decode(V4.self),
            try container.decode(V5.self),
            try container.decode(V6.self)
        )
    }
    
    func decodeValues<V1: Decodable, V2: Decodable, V3: Decodable, V4: Decodable, V5: Decodable, V6: Decodable, V7: Decodable>(
        for key: Key
    ) throws -> (V1, V2, V3, V4, V5, V6, V7) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self),
            try container.decode(V3.self),
            try container.decode(V4.self),
            try container.decode(V5.self),
            try container.decode(V6.self),
            try container.decode(V7.self)
        )
    }
}
