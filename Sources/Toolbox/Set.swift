
import Foundation

public extension Set {
    /// Insert all elements of the given collection into this set.
    ///
    /// - Parameter sequence: The sequence whose elements should be inserted into `self`.
    /// - Returns: The number of newly inserted items.
    @discardableResult mutating func insert<S: Sequence>(contentsOf sequence: S) -> Int
        where S.Element == Element
    {
        var newValues = 0
        for element in sequence {
            if self.insert(element).inserted {
                newValues += 1
            }
        }
        
        return newValues
    }
}
