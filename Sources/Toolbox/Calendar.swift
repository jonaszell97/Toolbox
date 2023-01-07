
import Foundation

public extension Calendar {
    /// Shortcut for the gregorian calendar.
    static let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    /// Shortcut for the gregorian calendar with the UTC time zone.
    static let reference: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .utc
        
        return calendar
    }()
}

public extension TimeZone {
    /// Shortcut for the UTC time zone.
    static let utc = TimeZone(identifier: "UTC")!
}

public extension Date {
    fileprivate static let secondsPerDay: TimeInterval = 24 * 60 * 60
    
    /// - returns: A date representing the start of the day this date is in.
    var startOfDay: Date {
        let components = Calendar.reference.dateComponents([.day, .month, .year], from: self)
        return Calendar.reference.date(from: components)!
    }
    
    /// - returns: This date converted to a different time zone.
    func convertToTimeZone(initTimeZone: TimeZone = .init(secondsFromGMT: 0)!, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
    
    /// - returns: A date representing the start of the month this date is in.
    var startOfMonth: Date {
        let components = Calendar.reference.dateComponents([.year, .month], from: self)
        return Calendar.reference.date(from: components)!
    }
    
    /// - returns: A date representing the end of the month this date is in.
    var endOfMonth: Date {
        Calendar.reference.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    /// - returns: A date representing the start of the week this date is in.
    var startOfWeek: Date {
        let components = Calendar.reference.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return Calendar.reference.date(from: components)!
    }
}

public extension Calendar {
    /// - returns: The weekday number after the given one.
    static func weekday(after day: Int) -> Int {
        switch day {
        case 7:
            return 1
        default:
            return day + 1
        }
    }
}

public extension DateInterval {
    /// - returns: This date interval expanded to contain the given date.
    func expanding(toContain date: Date) -> DateInterval {
        var copy = self
        copy.expand(toContain: date)
        
        return copy
    }
    
    /// Expand this interval to contain the given date.
    mutating func expand(toContain date: Date) {
        if date.timeIntervalSinceReferenceDate < self.start.timeIntervalSinceReferenceDate {
            self.start = date
        }
        else if date.timeIntervalSinceReferenceDate > self.end.timeIntervalSinceReferenceDate {
            self.end = date
        }
    }
}
