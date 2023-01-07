
import Foundation

public extension Dictionary {
    /// Modify the value at the given key, or place a default value and modify that.
    mutating func modify(key: Key, defaultValue: @autoclosure () -> Value, modify: (inout Value) -> Void) {
        if var value = self[key] {
            modify(&value)
            self[key] = value
        }
        else {
            var value = defaultValue()
            modify(&value)
            
            self[key] = value
        }
    }
}

public extension Dictionary where Value: AdditiveArithmetic {
    /// Add the values in the given dictionary to the values of another dictionary with the same keys.
    mutating func add(valuesOf other: Self) {
        let keys = other.keys.map { $0 }
        for key in keys {
            guard let otherValue = other[key] else {
                continue
            }
            
            if let value = self[key] {
                self[key] = value + otherValue
            }
            else {
                self[key] = otherValue
            }
        }
    }
    
    /// Group the items of this dictionary by generating a new key for each item.
    func grouped<NewKey>(by transformKey: (Key) -> NewKey) -> [NewKey: Value]
        where NewKey: Hashable
    {
        grouped(by: transformKey) { $0 + $1 }
    }
}

public extension Dictionary {
    /// Group the items of this dictionary by generating a new key for each item.
    func grouped<NewKey>(by transformKey: (Key) -> NewKey, combineValues: (Value, Value) -> Value) -> [NewKey: Value]
        where NewKey: Hashable
    {
        var dict = [NewKey: Value]()
        for (key, value) in self {
            let newKey = transformKey(key)
            
            if let existingValue = dict[newKey] {
                dict[newKey] = combineValues(existingValue, value)
            }
            else {
                dict[newKey] = value
            }
        }
        
        return dict
    }
}
