
import Foundation

// MARK: Array extensions

public extension Array {
    /// An alternative to the subscript operator that returns `nil` for non-existant indices.
    ///
    /// - Parameter index: The index of the element to return.
    /// - Returns: The element at `index` if it exists, `nil` otherwise.
    func tryGet(_ index: Int) -> Element? {
        (index >= 0 && index < self.count) ? self[index] : nil
    }
}

public extension Array where Element: Comparable {
    /// Check if an array is sorted in increasing order using the Comparable conformance for comparisons.
    ///
    /// - Returns: `true` if this array is sorted in increasing order, false otherwise.
    func isSortedInIncreasingOrder() -> Bool {
        guard self.count > 1 else {
            return true
        }
        
        for i in 1..<self.count {
            guard self[i - 1] <= self[i] else {
                return false
            }
        }
        
        return true
    }
    
    /// Check if an array is sorted in decreasing order using the Comparable conformance for comparisons.
    ///
    /// - Returns: `true` if this array is sorted in decreasing order, false otherwise.
    func isSortedInDecreasingOrder() -> Bool {
        guard self.count > 1 else {
            return true
        }
        
        for i in 1..<self.count {
            guard self[i - 1] >= self[i] else {
                return false
            }
        }
        
        return true
    }
}

public extension Array {
    /// Check if an array is sorted in increasing order using the the passed closure to compare elements.
    ///
    /// - Parameter areInIncreasingOrder: Closure used to compare two adjacent elements.
    /// - Returns: `true` if this array is sorted in increasing order, false otherwise.
    func isSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> Bool {
        guard self.count > 1 else {
            return true
        }
        
        for i in 1..<self.count {
            guard areInIncreasingOrder(self[i - 1], self[i]) else {
                return false
            }
        }
        
        return true
    }
}

public extension Array {
    /// Arrange an array into chunks of a given `size`. The final chunk may be smaller than `size`
    /// if there are not enough elements.
    ///
    /// - Parameter size: The size of an individual chunk.
    /// - Returns: An array containing the elements of `self` grouped into chunks of size `size`.
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    /// Arrange an array into chunks of a given `size`. If necessary, he final chunk will be padded with the value passed
    /// in the `padElement` parameter to make sure all chunks have the same `size`.
    ///
    /// - Parameter size: The size of an individual chunk.
    /// - Parameter padElement: The element to use as padding in the final chunk.
    /// - Returns: An array containing the elements of `self` grouped into chunks of size `size`.
    func chunked(into size: Int, padWith padElement: Element) -> [[Element]] {
        var chunks = stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
        
        if chunks.count > 0 && chunks.last!.count != size {
            var last = chunks[chunks.count - 1]
            while last.count < size {
                last.append(padElement)
            }
            
            chunks[chunks.count - 1] = last
        }
        
        return chunks
    }
    
    /// Non-mutating version of ``append(contentsOf:)``.
    ///
    /// - Parameter newElements: The elements to append to the array.
    /// - Returns: A new array containing the elements of `self` followed by the elements of `newElements`.
    func appending(contentsOf newElements: [Element]) -> [Element] {
        var copy = self
        copy.append(contentsOf: newElements)
        
        return copy
    }
    
    /// Append an element to this array only if it is not `nil`.
    ///
    /// - Parameter element: The element to append if it is not `nil`.
    /// - Returns: A copy of `self`, containing `element` at the end if it is not `nil`.
    func appending(ifNotNil element: Element?) -> [Element] {
        var copy = self
        if let element {
            copy.append(element)
        }
        
        return copy
    }
    
    /// Append an element to this array only if it is not `nil`.
    /// This method mutates the existing array.
    ///
    /// - Parameter element: The element to append if it is not `nil`.
    mutating func append(ifNotNil element: Element?) {
        guard let element else { return }
        self.append(element)
    }
}

public extension Array where Element: Equatable {
    /// Create a version of `self` containing only its unique elements, determined by equality.
    ///
    /// - Returns:An array containing only the unique elements `self`. Uniqueness is determined using equality.
    var unique: [Element] {
        var newArray = [Element]()
        for el in self {
            if newArray.firstIndex(of: el) != nil {
                continue
            }
            
            newArray.append(el)
        }
        
        return newArray
    }
}

public extension Array {
    /// Create a version of `self` containing only its unique elements, determined by the passed closure.
    ///
    /// - Parameter getUniqueProperty:Closure used to determine the hashable property of `Element` that should be used
    /// to determine uniqueness.
    /// - Returns:An array containing only the unique elements `self`.
    func unique<T: Hashable>(by getUniqueProperty: (Element) -> T) -> [Element] {
        var newArray = [Element]()
        var set = Set<T>()
        
        for el in self {
            guard set.insert(getUniqueProperty(el)).inserted else {
                continue
            }
            
            newArray.append(el)
        }
        
        return newArray
    }
    
    /// Create a version of `self` containing only its unique elements, determined by the passed `KeyPath`.
    ///
    /// - Parameter getUniqueProperty:Used to determine the hashable property of `Element` that should be used
    /// to determine uniqueness.
    /// - Returns:An array containing only the unique elements `self`.
    func unique<T: Hashable>(by uniqueProperty: KeyPath<Element, T>) -> [Element] {
        var newArray = [Element]()
        var set = Set<T>()
        
        for el in self {
            guard set.insert(el[keyPath: uniqueProperty]).inserted else {
                continue
            }
            
            newArray.append(el)
        }
        
        return newArray
    }
}

public extension Array {
    /// Choose a random element of this array weighted by some property value.
    /// A higher weight means a higher chance of the element being selected.
    ///
    /// - Parameters:
    ///   - rng: The random number generator to use.
    ///   - keypath: A `KeyPath` used to extract the weight from `Element` values that is used in random selection.
    /// - Returns: A random element weighted by the property value given by `keypath`.
    func randomElement(using rng: inout ARC4RandomNumberGenerator, weightedBy keypath: KeyPath<Element, Int>) -> Element? {
        guard count > 0 else {
            return nil
        }
        
        let total = self.reduce(0) { $0 + $1[keyPath: keypath] }
        return randomElement(using: &rng, weightedBy: keypath, precomputedTotal: total)
    }
    
    /// Choose `count` random elements of this array weighted by some property value.
    /// A higher weight means a higher chance of the element being selected.
    ///
    /// - Parameters:
    ///   - rng: The random number generator to use.
    ///   - keypath: A `KeyPath` used to extract the weight from `Element` values that is used in random selection.
    ///   - count: The number of random elements to choose.
    /// - Returns: An array of `count` random elements weighted by the property value given by `keypath`, or `nil` if `self` is empty.
    func randomElements(using rng: inout ARC4RandomNumberGenerator, weightedBy keypath: KeyPath<Element, Int>, count: Int) -> [Element]? {
        guard self.count > 0 else {
            return nil
        }
        
        let total = self.reduce(0) { $0 + $1[keyPath: keypath] }
        var result = [Element]()
        
        for _ in 0..<count {
            guard let next = randomElement(using: &rng, weightedBy: keypath, precomputedTotal: total) else {
                return nil
            }
            
            result.append(next)
        }
        
        return result
    }
    
    /// Choose a random element of this array weighted by some property value.
    /// A higher weight means a higher chance of the element being selected.
    /// This is a faster alternative to ``randomElement(using:weightedBy:)`` in case the sum of all weights has already been computed.
    ///
    /// - Parameters:
    ///   - rng: The random number generator to use.
    ///   - keypath: A `KeyPath` used to extract the weight from `Element` values that is used in random selection.
    ///   - precomputedTotal: Must be equal to the sum of all element weights.
    /// - Returns: A random element weighted by the property value given by `keypath`.
    func randomElement(using rng: inout ARC4RandomNumberGenerator, weightedBy keypath: KeyPath<Element, Int>, precomputedTotal: Int) -> Element? {
        guard count > 0 && precomputedTotal > 0 else {
            return nil
        }
        
        let rnd = rng.random(in: 0..<precomputedTotal)
        
        var sum = 0
        for el in self {
            sum += el[keyPath: keypath]
            if rnd < sum {
                return el
            }
        }
        
        return nil
    }
}
