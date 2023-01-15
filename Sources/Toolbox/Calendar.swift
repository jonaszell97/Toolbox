
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
    
    /// - returns: A date representing the end of the day this date is in.
    var endOfDay: Date {
        startOfDay.addingTimeInterval(23*60*60 + 59*60 + 59)
    }
    
    /// - returns: A date representing the start of the month this date is in.
    var startOfMonth: Date {
        let components = Calendar.reference.dateComponents([.year, .month], from: self)
        return Calendar.reference.date(from: components)!
    }
    
    /// - returns: A date representing the end of the month this date is in.
    var endOfMonth: Date {
        Calendar.reference.date(byAdding: DateComponents(month: 1, second: -1), to: self.startOfMonth)!
    }
    
    enum FirstDayOfWeek {
        case sunday, monday
    }
    
    /// - returns: A date representing the start of the week this date is in.
    func startOfWeek(weekStartsOn firstWeekday: FirstDayOfWeek) -> Date {
        let components = Calendar.reference.dateComponents([.year, .month, .day, .weekday], from: self)
        let desiredWeekday: Int
        
        switch firstWeekday {
        case .sunday:
            desiredWeekday = 1
        case .monday:
            desiredWeekday = 2
        }
        
        let weekday = components.weekday!
        let difference: Int
        
        if desiredWeekday > weekday {
            difference = -7 + (desiredWeekday - weekday)
        }
        else {
            difference = desiredWeekday - weekday
        }
        
        return Calendar.reference.date(from: components)!.addingTimeInterval(24*60*60*TimeInterval(difference))
    }
    
    /// - returns: A date representing the end of the week this date is in.
    func endOfWeek(weekStartsOn firstWeekday: FirstDayOfWeek) -> Date {
        startOfWeek(weekStartsOn: firstWeekday).addingTimeInterval(7*24*60*60 - 1)
    }
    
    /// - returns: A date representing the start of the year this date is in.
    var startOfYear: Date {
        var components = Calendar.reference.dateComponents([.year], from: self)
        components.day = 1
        components.month = 1
        
        return Calendar.reference.date(from: components)!
    }
    
    /// - returns: A date representing the end of the year this date is in.
    var endOfYear: Date {
        var components = Calendar.reference.dateComponents([.year], from: self)
        components.day = 31
        components.month = 12
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return Calendar.reference.date(from: components)!
    }
    
    /// - returns: This date converted to a different time zone.
    func convertToTimeZone(initTimeZone: TimeZone = .init(secondsFromGMT: 0)!, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
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
            self = .init(start: date, end: self.end)
        }
        else if date.timeIntervalSinceReferenceDate > self.end.timeIntervalSinceReferenceDate {
            self = .init(start: self.start, end: date)
        }
    }
    
    /// - returns: True if any date in `ìnterval` is included within this interval.
    func overlaps(_ interval: DateInterval) -> Bool {
        (interval.start >= self.start && interval.start <= self.end)
            || (interval.end <= self.end && interval.end >= self.start)
            || (interval.start <= self.start && interval.end >= self.end)
    }
}
