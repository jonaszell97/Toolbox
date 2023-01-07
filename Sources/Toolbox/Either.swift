
/// A value that can be of one of two types.
public enum Either<FirstOption, SecondOption> {
    /// A value of the first type.
    case first(_ value: FirstOption)
    
    /// A value of the second type.
    case second(_ value: SecondOption)
}

extension Either: Equatable where FirstOption: Equatable, SecondOption: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .first(let lhsValue):
            switch rhs {
            case .first(let rhsValue):
                return lhsValue == rhsValue
            case .second:
                return false
            }
        case .second(let lhsValue):
            switch rhs {
            case .first:
                return false
            case .second(let rhsValue):
                return lhsValue == rhsValue
            }
        }
    }
}

extension Either: Hashable where FirstOption: Hashable, SecondOption: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .first(let value):
            hasher.combine(value)
        case .second(let value):
            hasher.combine(value)
        }
    }
}

fileprivate enum EitherCodingKeys: CodingKey {
    case first, second
}

extension Either: Codable where FirstOption: Codable, SecondOption: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EitherCodingKeys.self)
        switch self {
        case .first(let value):
            try container.encode(value, forKey: .first)
        case .second(let value):
            try container.encode(value, forKey: .second)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EitherCodingKeys.self)
        switch container.allKeys.first {
        case .first:
            self = .first(try container.decode(FirstOption.self, forKey: .first))
        case .second:
            self = .second(try container.decode(SecondOption.self, forKey: .second))
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
}
