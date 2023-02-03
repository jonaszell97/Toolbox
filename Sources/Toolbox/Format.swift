
import Foundation

/// This type serves as a namespace for Formatting-related utility functions.
public enum FormatToolbox {
    /// The common formatter to use.
    private static let formatter: NumberFormatter = NumberFormatter()
    
    /// The common date formatter to use.
    private static let dateFormatter = DateFormatter()
    
    /// Format a floating point number to the given number of decimal places.
    ///
    ///     print(FormatToolbox.format(3.215, decimalPlaces: 2) // prints "3.22"
    ///     print(FormatToolbox.format(2.0, minDecimalPlaces: 2) // prints "2.00"
    ///     print(FormatToolbox.format(6.65, alwaysShowSign: true) // prints "+6.65"
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - decimalPlaces: The maximum amount of decimal places to show.
    ///   - minDecimalPlaces: The minimum amount of decimal places to show.
    /// - Returns: A formatted string representation of the given value.
    public static func format(_ value: Float, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0, alwaysShowSign: Bool = false) -> String {
        return format(Double(value), decimalPlaces: decimalPlaces, minDecimalPlaces: minDecimalPlaces, alwaysShowSign: alwaysShowSign)
    }
    
    /// Format a floating point number to the given number of decimal places.
    ///
    ///     print(FormatToolbox.format(3.215, decimalPlaces: 2) // prints "3.22"
    ///     print(FormatToolbox.format(2.0, minDecimalPlaces: 2) // prints "2.00"
    ///     print(FormatToolbox.format(6.65, alwaysShowSign: true) // prints "+6.65"
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - decimalPlaces: The maximum amount of decimal places to show.
    ///   - minDecimalPlaces: The minimum amount of decimal places to show.
    /// - Returns: A formatted string representation of the given value.
    public static func format(_ value: CGFloat, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0, alwaysShowSign: Bool = false) -> String {
        return format(Double(value), decimalPlaces: decimalPlaces, minDecimalPlaces: minDecimalPlaces, alwaysShowSign: alwaysShowSign)
    }
    
    /// Format a floating point number to the given number of decimal places.
    ///
    ///     print(FormatToolbox.format(3.215, decimalPlaces: 2) // prints "3.22"
    ///     print(FormatToolbox.format(2.0, minDecimalPlaces: 2) // prints "2.00"
    ///     print(FormatToolbox.format(6.65, alwaysShowSign: true) // prints "+6.65"
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - decimalPlaces: The maximum amount of decimal places to show.
    ///   - minDecimalPlaces: The minimum amount of decimal places to show.
    ///   - alwaysShowSign: Whether to show the sign even if `value` is positive.
    /// - Returns: A formatted string representation of the given value.
    public static func format(_ value: Double, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0, alwaysShowSign: Bool = false) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.usesGroupingSeparator = true
        
        var result = formatter.string(from: NSNumber(value: value)) ?? String(value)
        if alwaysShowSign && value >= 0 {
            result.insert("+", at: result.startIndex)
        }
        
        return result
    }
    
    /// Format a floating point number to the given number of decimal places.
    ///
    ///     print(FormatToolbox.format(3.215, decimalPlaces: 2) // prints "3.22"
    ///     print(FormatToolbox.format(2.0, minDecimalPlaces: 2) // prints "2.00"
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - decimalPlaces: The maximum amount of decimal places to show.
    ///   - minDecimalPlaces: The minimum amount of decimal places to show.
    /// - Returns: A formatted string representation of the given value.
    public static func format(_ value: Decimal, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.usesGroupingSeparator = true
        
        return formatter.string(from: NSDecimalNumber(decimal: value))!
    }
    
    /// Format an integer including signs and thousands separators.
    ///
    /// - Parameters:
    ///   - value: The value to format.
    /// - Returns: A formatted string representation of the given value.
    public static func format(_ value: Int) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format an integer including signs and thousands separators.
    ///
    /// - Parameters:
    ///   - value: The value to format.
    ///   - alwaysShowSign: Whether to show the sign even if `value` is positive.
    /// - Returns: A formatted string representation of the given value.
    public static func format(_ value: Int, alwaysShowSign: Bool) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        
        var result = formatter.string(from: NSNumber(value: value)) ?? String(value)
        if alwaysShowSign && value >= 0 {
            result = "+" + result
        }
        
        return result
    }
    
    /// Format a year.
    ///
    /// - Parameter value: The year to format.
    /// - Returns: A formatted string representing the year.
    public static func formatYear(_ value: Int) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format a value as a percentage in the style '3.1%'.
    ///
    ///     print(FormatToolbox.formatPercentage(0.123, decimalPlaces: 2) // prints "12.3%"
    ///     print(FormatToolbox.formatPercentage(1, minDecimalPlaces: 2) // prints "100.00%"
    ///
    /// - Parameters:
    ///   - value: The value to format. Must be between 0 and 1.
    ///   - decimalPlaces: The maximum amount of decimal places to show.
    ///   - minDecimalPlaces: The minimum amount of decimal places to show.
    /// - Returns: The formatted percentage.
    public static func formatPercentage(_ value: Double, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = minDecimalPlaces
        
        return "\(formatter.string(from: NSNumber(value: value * 100)) ?? String(value))%"
    }
    
    /// Format a number in ordinal style.
    ///
    ///     print(FormatToolbox.formatOrdinal(1)) // prints "1st"
    ///     print(FormatToolbox.formatOrdinal(2)) // prints "2nd"
    ///     print(FormatToolbox.formatOrdinal(3)) // prints "3rd"
    ///
    /// - Parameter value: The number to format.
    /// - Returns: The formatted number in ordinal style.
    public static func formatOrdinal(_ value: Int) -> String {
        formatter.numberStyle = .ordinal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format a time limit in the style `HH:MM:SS.m`.
    ///
    ///     print(FormatToolbox.formatTimeLimit(60, includeMilliseconds: false)) // prints "01:00"
    ///     print(FormatToolbox.formatTimeLimit(120*60, includeMilliseconds: true)) // prints "02:00:00"
    ///     print(FormatToolbox.formatTimeLimit(239.32, includeMilliseconds: true)) // prints "03:59.3"
    ///
    /// - Parameters:
    ///   - timeLimit: The time limit to format.
    ///   - includeMilliseconds: Whether to include milliseconds in the output string.
    /// - Returns: A formatted version of the time limit.
    public static func formatTimeLimit(_ timeLimit: TimeInterval, includeMilliseconds: Bool? = true) -> String {
        let hours = Int(timeLimit) / (60 * 60)
        let minutes = Int(timeLimit) / 60 % 60
        let seconds = Int(timeLimit) % 60
        let rest = timeLimit - timeLimit.rounded(.towardZero)
        
        let includeMilliseconds = includeMilliseconds ?? (timeLimit < 1)
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
        else {
            if includeMilliseconds {
                let milliseconds = Int(rest * 1000) / 100
                return String(format: "%02i:%02i.%01i", minutes, seconds, milliseconds)
            }
            
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    /// Format a date including time for display.
    ///
    /// - Parameters:
    ///   - date: The date to format.
    ///   - timeZone: The time zone to use for formatting..
    ///   - locale: The locale to use for formatting.
    ///   - dateStyle: The date style.
    ///   - timeStyle: The stime style.
    /// - Returns: The formatted date.
    public static func formatDateTime(_ date: Date,
                                      timeZone: TimeZone = .current,
                                      locale: Locale = .autoupdatingCurrent,
                                      dateStyle: DateFormatter.Style = .medium,
                                      timeStyle: DateFormatter.Style = .medium) -> String {
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.string(from: date)
    }
    
    /// Format a date for display.
    ///
    /// - Parameters:
    ///   - date: The date to format.
    ///   - timeZone: The time zone to use for formatting..
    ///   - locale: The locale to use for formatting.
    ///   - dateStyle: The date style.
    /// - Returns: The formatted date.
    public static func formatDate(_ date: Date,
                                  timeZone: TimeZone = .current,
                                  locale: Locale = .autoupdatingCurrent,
                                  dateStyle: DateFormatter.Style = .medium) -> String {
        self.formatDateTime(date, timeZone: timeZone, locale: locale, dateStyle: dateStyle, timeStyle: .none)
    }
    
    /// Format the time from a date for display.
    ///
    /// - Parameters:
    ///   - date: The date to format.
    ///   - timeZone: The time zone to use for formatting..
    ///   - locale: The locale to use for formatting.
    ///   - timeStyle: The stime style.
    /// - Returns: The formatted time.
    public static func formatTime(_ date: Date,
                                  timeZone: TimeZone = .current,
                                  locale: Locale = .autoupdatingCurrent,
                                  timeStyle: DateFormatter.Style = .medium) -> String {
        self.formatDateTime(date, timeZone: timeZone, locale: locale, dateStyle: .none, timeStyle: timeStyle)
    }
    
    /// Format a byte amount.
    ///
    ///     print(FormatToolbox.formatByteSize(39)) // prints "39 B"
    ///
    /// - Parameter bytes: The number of bytes to format.
    /// - Returns: The formatted byte amount.
    public static func formatByteSize(_ bytes: Int) -> String {
        if bytes < 1000 {
            return "\(bytes) B"
        }
        if bytes < 1000 ** 2 {
            return "\(Self.format(Double(bytes)/1000)) KB"
        }
        if bytes < 1000 ** 3 {
            return "\(Self.format(Double(bytes)/pow(1000, 2))) MB"
        }
        if bytes < 1000 ** 4 {
            return "\(Self.format(Double(bytes)/pow(1000, 3))) GB"
        }
        
        return "\(Self.format(Double(bytes)/pow(1000, 4))) TB"
    }
}

