
import Foundation

public extension JSONEncoder {
    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func encode<V1, V2>(_ value: (V1, V2)) throws -> Data where V1: Encodable, V2: Encodable {
        try self.encode(Pair(value))
    }
    
    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func encode<V1, V2, V3>(_ value: (V1, V2, V3)) throws -> Data where V1: Encodable, V2: Encodable, V3: Encodable {
        try self.encode(Pair(value.0, Pair(value.1, value.2)))
    }
    
    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func encode<V1, V2, V3, V4>(_ value: (V1, V2, V3, V4)) throws -> Data where V1: Encodable, V2: Encodable, V3: Encodable, V4: Encodable {
        try self.encode(Pair(value.0, Pair(value.1, Pair(value.2, value.3))))
    }
}

public extension JSONDecoder {
    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    func decode<V1, V2>(_ type: (V1, V2).Type, from data: Data) throws -> (V1, V2) where V1: Decodable, V2: Decodable {
        try self.decode(Pair<V1, V2>.self, from: data).tuple
    }
    
    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    func decode<V1, V2, V3>(_ type: (V1, V2, V3).Type, from data: Data) throws -> (V1, V2, V3) where V1: Decodable, V2: Decodable, V3: Decodable {
        let pair = try self.decode(Pair<V1, Pair<V2, V3>>.self, from: data)
        return (pair.item1, pair.item2.item1, pair.item2.item2)
    }
    
    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    func decode<V1, V2, V3, V4>(_ type: (V1, V2, V3, V4).Type, from data: Data) throws -> (V1, V2, V3, V4) where V1: Decodable, V2: Decodable, V3: Decodable, V4: Decodable {
        let pair = try self.decode(Pair<V1, Pair<V2, Pair<V3, V4>>>.self, from: data)
        return (pair.item1, pair.item2.item1, pair.item2.item2.item1, pair.item2.item2.item2)
    }
}

/// Kinda makes you wish that Swift had variadic generics.
public extension KeyedEncodingContainer {
    /// Encodes two encodable values in a nested unkeyed container.
    ///
    /// - Parameters:
    ///   - v1: The first value to encode.
    ///   - v2: The second value to encode.
    ///   - key: The coding key used to identify the nested container.
    mutating func encodeValues<V1: Encodable, V2: Encodable>(
        _ v1: V1,
        _ v2: V2,
        for key: Key
    ) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
    }
    
    /// Encodes three encodable values in a nested unkeyed container.
    ///
    /// - Parameters:
    ///   - v1: The first value to encode.
    ///   - v2: The second value to encode.
    ///   - v3: The third value to encode.
    ///   - key: The coding key used to identify the nested container.
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
    
    /// Encodes four encodable values in a nested unkeyed container.
    ///
    /// - Parameters:
    ///   - v1: The first value to encode.
    ///   - v2: The second value to encode.
    ///   - v3: The third value to encode.
    ///   - v4: The fourth value to encode.
    ///   - key: The coding key used to identify the nested container.
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
    
    /// Encodes five encodable values in a nested unkeyed container.
    ///
    /// - Parameters:
    ///   - v1: The first value to encode.
    ///   - v2: The second value to encode.
    ///   - v3: The third value to encode.
    ///   - v4: The fourth value to encode.
    ///   - v5: The fifth value to encode.
    ///   - key: The coding key used to identify the nested container.
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
    
    /// Encodes six encodable values in a nested unkeyed container.
    ///
    /// - Parameters:
    ///   - v1: The first value to encode.
    ///   - v2: The second value to encode.
    ///   - v3: The third value to encode.
    ///   - v4: The fourth value to encode.
    ///   - v5: The fifth value to encode.
    ///   - v6: The sixth value to encode.
    ///   - key: The coding key used to identify the nested container.
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
    
    /// Encodes seven encodable values in a nested unkeyed container.
    ///
    /// - Parameters:
    ///   - v1: The first value to encode.
    ///   - v2: The second value to encode.
    ///   - v3: The third value to encode.
    ///   - v4: The fourth value to encode.
    ///   - v5: The fifth value to encode.
    ///   - v6: The sixth value to encode.
    ///   - v7: The seventh value to encode.
    ///   - key: The coding key used to identify the nested container.
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
    /// Decode two values from that were previously encoded using ``KeyedEncodingContainer/encodeValues(_:_:key:)``.
    ///
    /// - Parameter key: The coding key used to identify the nested container.
    /// - Returns: The decoded values as a tuple.
    func decodeValues<V1: Decodable, V2: Decodable>(
        for key: Key
    ) throws -> (V1, V2) {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self)
        )
    }
    
    /// Decode three values from that were previously encoded using ``KeyedEncodingContainer/encodeValues(_:_:_:key:)``.
    ///
    /// - Parameter key: The coding key used to identify the nested container.
    /// - Returns: The decoded values as a tuple.
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
    
    /// Decode four values from that were previously encoded using ``KeyedEncodingContainer/encodeValues(_:_:_:_:key:)``.
    ///
    /// - Parameter key: The coding key used to identify the nested container.
    /// - Returns: The decoded values as a tuple.
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
    
    /// Decode five values from that were previously encoded using ``KeyedEncodingContainer/encodeValues(_:_:_:_:_:key:)``.
    ///
    /// - Parameter key: The coding key used to identify the nested container.
    /// - Returns: The decoded values as a tuple.
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
    
    /// Decode six values from that were previously encoded using ``KeyedEncodingContainer/encodeValues(_:_:_:_:_:_:key:)``.
    ///
    /// - Parameter key: The coding key used to identify the nested container.
    /// - Returns: The decoded values as a tuple.
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
    
    /// Decode seven values from that were previously encoded using ``KeyedEncodingContainer/encodeValues(_:_:_:_:_:_:_:key:)``.
    ///
    /// - Parameter key: The coding key used to identify the nested container.
    /// - Returns: The decoded values as a tuple.
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
