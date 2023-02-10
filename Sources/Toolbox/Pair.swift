
/// A pair of two values that can be used as a codable alternative to tuples.
public struct Pair<T, U> {
    /// The first item in the pair.
    public let item1: T
    
    /// The second item in the pair.
    public let item2: U
    
    /// Initialize from two explicit items.
    public init(item1: T, item2: U) {
        self.item1 = item1
        self.item2 = item2
    }
    
    /// Initialize from two unlabeled items.
    public init(_ item1: T, _ item2: U) {
        self.item1 = item1
        self.item2 = item2
    }
    
    /// Initialize from a tuple of two values.
    public init?(_ tuple: (T, U)?) {
        guard let tuple = tuple else {
            return nil
        }
        
        self.item1 = tuple.0
        self.item2 = tuple.1
    }
    
    /// - Returns: The tuple equivalent of this pair.
    public var tuple: (T, U) {
        (item1, item2)
    }
}

extension Pair: Encodable where T: Encodable, U: Encodable {
    
}

extension Pair: Decodable where T: Decodable, U: Decodable {
    
}

extension Pair: Hashable where T: Hashable, U: Hashable {
    
}

extension Pair: Equatable where T: Equatable, U: Equatable {
    
}
