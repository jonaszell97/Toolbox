
import Foundation

public enum FormatToolbox {
    /// The common formatter to use.
    public static let formatter: NumberFormatter = NumberFormatter()
    
    /// The common date formatter to use.
    public static let dateFormatter = DateFormatter()
    
    /// Format a floating point number to the given number of decimal places.
    public static func format(_ fp: Float, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0) -> String {
        return format(Double(fp), decimalPlaces: decimalPlaces, minDecimalPlaces: minDecimalPlaces)
    }
    
    /// Format a floating point number to the given number of decimal places.
    public static func format(_ fp: CGFloat, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0) -> String {
        return format(Double(fp), decimalPlaces: decimalPlaces, minDecimalPlaces: minDecimalPlaces)
    }
    
    /// Format a floating point number to the given number of decimal places.
    public static func format(_ fp: Double, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0, alwaysShowSign: Bool = false) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.usesGroupingSeparator = true
        
        var result = formatter.string(from: NSNumber(value: fp)) ?? String(fp)
        if alwaysShowSign && fp >= 0 {
            result = "+" + result
        }
        
        return result
    }
    
    /// Format a floating point number to the given number of decimal places.
    public static func format(_ fp: Decimal, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.usesGroupingSeparator = true
        
        return formatter.string(from: NSDecimalNumber(decimal: fp))!
    }
    
    /// Format an integer including signs and thousands separators.
    public static func format(_ value: Int) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format an integer including signs and thousands separators.
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
    public static func formatYear(_ value: Int) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format `p` as a percentage, in the style '3.1%'. `p ` must be between 0 and 1.
    public static func formatPercentage(_ p: Double, decimalPlaces: Int = 2, minDecimalPlaces: Int = 0) -> String {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = minDecimalPlaces
        
        return "\(formatter.string(from: NSNumber(value: p * 100)) ?? String(p))%"
    }
    
    /// Format an ordinal number.
    public static func formatOrdinal(_ value: Int) -> String {
        formatter.numberStyle = .ordinal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format a time limit for display.
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
    
    /// Format a date for display.
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
    public static func formatDate(_ date: Date,
                                  timeZone: TimeZone = .current,
                                  locale: Locale = .autoupdatingCurrent,
                                  dateStyle: DateFormatter.Style = .medium) -> String {
        self.formatDateTime(date, timeZone: timeZone, locale: locale, dateStyle: dateStyle, timeStyle: .none)
    }
    
    /// Format a time for display.
    public static func formatTime(_ date: Date,
                                  timeZone: TimeZone = .current,
                                  locale: Locale = .autoupdatingCurrent,
                                  timeStyle: DateFormatter.Style = .medium) -> String {
        self.formatDateTime(date, timeZone: timeZone, locale: locale, dateStyle: .none, timeStyle: timeStyle)
    }
    
    /// Format a byte size.
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

