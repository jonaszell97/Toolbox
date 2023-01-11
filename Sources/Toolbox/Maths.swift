
import Foundation

public enum MathsToolbox { }

// MARK: General maths functions

public extension MathsToolbox {
    /// - returns: If `value` is lower than `lower` or higher than `higher`, returns those respective limits. Otherwise returns `value` unchanged.
    static func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
        return max(lower, min(value, upper))
    }
}

public extension Decimal {
    /// - returns: The value of this decimal as a Double.
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
    
    /// - returns: The value of this decimal rounded to an Int.
    var intValue: Int {
        return NSDecimalNumber(decimal:self).intValue
    }
}

// MARK: Exponentiation

/// Precedence group for the exponentiation operator.
precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }

/// The exponentiation operator.
infix operator ** : PowerPrecedence

/// - returns: `radix` raised to the power of `power`.
public func **(radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

/// - returns: `radix` raised to the power of `power`.
public func **(radix: Decimal, power: Int) -> Decimal {
    if power == 0 {
        return 1
    }
    
    if power == 1 {
        return radix
    }
    
    var result = radix
    for _ in 1..<power {
        result *= radix
    }
    
    return result
}

// MARK: Factorial

public extension MathsToolbox {
    /// - returns: The factorial of `n`, i.e. the result of n×(n-1)×...×1
    static func factorial(_ n: Int) -> Int {
        if n < 3 {
            return max(1, n)
        }
        
        // Use a lookup table for small numbers
        switch n {
        case 3:
            return 6
        case 4:
            return 24
        case 5:
            return 120
        case 6:
            return 720
        case 7:
            return 5040
        case 8:
            return 40320
        case 9:
            return 362_880
        case 10:
            return 3_628_800
        default:
            break
        }
        
        var result = 3_628_800
        for i in 11...n {
            result *= i
        }
        
        return result
    }
}

// MARK: Digit counting

public extension MathsToolbox {
    /// - returns:The number of digits required to represent `n` as a string, optionally accounting for thousands separators.
    static func requiredDigits(_ n: Int?, thousandsSeparators: Bool = true) -> Int {
        guard var n = n else {
            return 1
        }
        
        guard n != 0 else {
            return 1
        }
        
        var digits = 0
        if n < 0 {
            digits += 1
            n = -n
        }
        
        let p = log10(Double(n))
        if p.rounded() == p {
            digits += 1
        }
        
        // Account for thousands separators
        if thousandsSeparators {
            digits += Int(floor(p / 3))
        }
        
        return digits + Int(p.rounded(.awayFromZero))
    }
    
    /// - returns:The number of digits required to represent `n` as a string, including the decimal point, with no thousands separators.
    static func requiredDigits(_ n: Decimal?) -> Int {
        guard var n = n else {
            return 1
        }
        
        guard n != 0 else {
            return 1
        }
        
        var digits = 0
        if n < 0 {
            digits += 1
            n = -n
        }
        
        let rounded = n.rounded(0, .down)
        digits += requiredDigits(Int(rounded.doubleValue), thousandsSeparators: false)
        n -= rounded
        
        if n.isEqual(to: 0) {
            return digits
        }
        
        var hasDecimalPoint = false
        while (n.rounded() - n).magnitude >= 0.01 {
            n *= 10
            if !hasDecimalPoint && n < 1 {
                digits += 1
            }
            
            hasDecimalPoint = true
        }
        
        return digits + requiredDigits(Int(n.rounded(0, .down).doubleValue), thousandsSeparators: false) + (hasDecimalPoint ? 1 : 0)
    }
    
    /// - returns:The number of digits required to represent `n` as a string in a given base.
    static func requiredDigits(_ n: Int?, base: Int) -> Int {
        guard var n = n else {
            return 1
        }
        
        guard n != 0 else {
            return 1
        }
        
        var digits = 0
        if n < 0 {
            digits += 1
            n = -n
        }
        
        let p = log(Double(n)) / log(Double(base))
        if p.rounded() == p {
            digits += 1
        }
        
        return digits + Int(p.rounded(.awayFromZero))
    }
    
    /// - returns:The decimal digits of `n`, from most significant to least.
    static func decimalDigits(of n: Int) -> [Int] {
        guard n != 0 else {
            return [0]
        }
        
        var digits = [Int]()
        var n = abs(n)
        
        while n > 0 {
            let rem = n % 10
            digits.append(rem)
            
            n = (n - rem) / 10
        }
        
        return digits.reversed()
    }
}

public extension Int {
    /// - returns:The decimal digits of `n`, from most significant to least.
    var digits: [Int] {
        MathsToolbox.decimalDigits(of: self)
    }
}

// MARK: Rounding

public extension Decimal {
    /// - returns: This decimal value rounded to a given scale and mode.
    func rounded(_ scale: Int = 0, _ mode: NSDecimalNumber.RoundingMode = .bankers) -> Decimal {
        var this = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &this, scale, mode)
        
        return rounded
    }
}

public extension BinaryFloatingPoint {
    /// Rounds this number up to a multiple of `multiple`.
    mutating func roundUp(toMultipleOf multiple: Self) {
        let multiple = abs(multiple)
        if self < 0 {
            self = -(-self).roundedDown(toMultipleOf: multiple)
            return
        }
        
        let remainder = self.truncatingRemainder(dividingBy: multiple)
        if remainder.isZero {
            return
        }
        
        self += (multiple - remainder)
    }
    
    /// - returns: This number rounded up to a multiple of `multiple`.
    func roundedUp(toMultipleOf multiple: Self) -> Self {
        var copy = self
        copy.roundUp(toMultipleOf: multiple)
        
        return copy
    }
    
    /// Rounds this number down to a multiple of `multiple`.
    mutating func roundDown(toMultipleOf multiple: Self) {
        let multiple = abs(multiple)
        if self < 0 {
            self = -(-self).roundedUp(toMultipleOf: multiple)
            return
        }
        
        let remainder = self.truncatingRemainder(dividingBy: multiple)
        self -= remainder
    }
    
    /// - returns: This number rounded down to a multiple of `multiple`.
    func roundedDown(toMultipleOf multiple: Self) -> Self {
        var copy = self
        copy.roundDown(toMultipleOf: multiple)
        
        return copy
    }
    
    /// - returns:This number rounded to a given number of decimal places.
    func rounded(toDecimalPlaces decimalPlaces: Int) -> Self {
        let pow = Self(10 ** decimalPlaces)
        let rounded = Int(self * pow)
        
        return Self(rounded) / pow
    }
}

public extension SignedInteger {
    /// Rounds this number up to a multiple of `multiple`.
    mutating func roundUp(toMultipleOf multiple: Self) {
        let multiple = abs(multiple)
        if self < 0 {
            self = -(-self).roundedDown(toMultipleOf: multiple)
            return
        }
        
        let remainder = self % multiple
        if remainder == 0 {
            return
        }
        
        self += (multiple - remainder)
    }
    
    /// - returns: This number rounded up to a multiple of `multiple`.
    func roundedUp(toMultipleOf multiple: Self) -> Self {
        var copy = self
        copy.roundUp(toMultipleOf: multiple)
        
        return copy
    }
    
    /// Rounds this number down to a multiple of `multiple`.
    mutating func roundDown(toMultipleOf multiple: Self) {
        let multiple = abs(multiple)
        if self < 0 {
            self = -(-self).roundedUp(toMultipleOf: multiple)
            return
        }
        
        let remainder = self % multiple
        self -= remainder
    }
    
    /// - returns: This number rounded down to a multiple of `multiple`.
    func roundedDown(toMultipleOf multiple: Self) -> Self {
        var copy = self
        copy.roundDown(toMultipleOf: multiple)
        
        return copy
    }
}
