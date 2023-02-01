
import Foundation

// MARK: Array extensions

public extension Array {
    /// - returns: The element at `index` if it exists, `nil` otherwise.
    func tryGet(_ index: Int) -> Element? {
        (index >= 0 && index < self.count) ? self[index] : nil
    }
}

public extension Array where Element: Comparable {
    /// - returns: True iff this array is sorted in increasing order.
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
    
    /// - returns: True iff this array is sorted in decreasing order.
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
    /// - returns: True iff this array is sorted in increasing order.
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
    /// - returns: An array containing the elements of this array grouped into chunks of size `size`.
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    /// - returns: An array containing the elements of this array grouped into chunks of size `size`.
    ///            The value `padWith` is used to make sure the last chunk also has the correct size.
    func chunked(into size: Int, padWith: Element) -> [[Element]] {
        var chunks = stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
        
        if chunks.count > 0 && chunks.last!.count != size {
            var last = chunks[chunks.count - 1]
            while last.count < size {
                last.append(padWith)
            }
            
            chunks[chunks.count - 1] = last
        }
        
        return chunks
    }
    
    /// Non-mutating version of `.append(contentsOf:)`.
    func appending(contentsOf elements: [Element]) -> [Element] {
        var copy = self
        copy.append(contentsOf: elements)
        
        return copy
    }
    
    /// Append an element to this collection if it is not nil.
    func appending(ifNotNil element: Element?) -> [Element] {
        var copy = self
        if let element {
            copy.append(element)
        }
        
        return copy
    }
    
    /// Append an element to this collection if it is not nil.
    mutating func append(ifNotNil element: Element?) {
        if let element {
            self.append(element)
        }
    }
}

public extension Array where Element: Equatable {
    /// - returns:An array containing only the unique elements of this array. Uniqueness is determined using equality.
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
    /// - returns: An array containing only the unique elements of this array. Uniqueness
    ///            is determined by a custom function parameter.
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
}

public extension Array {
    /// - returns: A random element weighted by some property.
    func randomElement(using rng: inout ARC4RandomNumberGenerator, weightedBy keypath: KeyPath<Element, Int>) -> Element? {
        guard count > 0 else {
            return nil
        }
        
        let total = self.reduce(0) { $0 + $1[keyPath: keypath] }
        return randomElement(using: &rng, weightedBy: keypath, precomputedTotal: total)
    }
    
    /// - returns: A random element weighted by some property.
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
    
    /// - returns: A random element weighted by some property. This is a faster option in case the sum of all weights has already been computed.
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
