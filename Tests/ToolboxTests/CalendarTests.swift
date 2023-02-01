import XCTest
@testable import Toolbox

final class CalendarTests: XCTestCase {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = .utc
        
        return dateFormatter
    }()
    
    func date(from string: String) -> Date {
        let date = dateFormatter.date(from: string)
        XCTAssertNotNil(date)
        
        return date!
    }
    
    func testStartOfDay() {
        let calendar = Calendar.reference
        let startComponents = DateComponents(timeZone: .current, year: 2020, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        var currentDate = calendar.date(from: startComponents)!
        var expectedDay = 1
        var expectedMonth = 1
        var expectedYear = 2020
        
        for i in 1...367 {
            let components = calendar.dateComponents([.year, .month, .day], from: currentDate.startOfDay)
            XCTAssertEqual(components.year, expectedYear)
            XCTAssertEqual(components.month, expectedMonth)
            XCTAssertEqual(components.day, expectedDay)
            
            switch i {
            case 31:
                fallthrough
            case 60:
                fallthrough
            case 91:
                fallthrough
            case 121:
                fallthrough
            case 152:
                fallthrough
            case 182:
                fallthrough
            case 213:
                fallthrough
            case 244:
                fallthrough
            case 274:
                fallthrough
            case 305:
                fallthrough
            case 335:
                expectedDay = 1
                expectedMonth += 1
            case 366:
                expectedDay = 1
                expectedMonth = 1
                expectedYear += 1
            default:
                expectedDay += 1
            }
            
            currentDate.addTimeInterval(24*60*60)
        }
    }
    
    func testEndOfDay() {
        let calendar = Calendar.reference
        let startComponents = DateComponents(timeZone: .current, year: 2020, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        var currentDate = calendar.date(from: startComponents)!
        var expectedDay = 1
        var expectedMonth = 1
        var expectedYear = 2020
        
        for i in 1...367 {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate.endOfDay)
            XCTAssertEqual(components.year, expectedYear)
            XCTAssertEqual(components.month, expectedMonth)
            XCTAssertEqual(components.day, expectedDay)
            XCTAssertEqual(components.hour, 23)
            XCTAssertEqual(components.minute, 59)
            XCTAssertEqual(components.second, 59)
            
            switch i {
            case 31:
                fallthrough
            case 60:
                fallthrough
            case 91:
                fallthrough
            case 121:
                fallthrough
            case 152:
                fallthrough
            case 182:
                fallthrough
            case 213:
                fallthrough
            case 244:
                fallthrough
            case 274:
                fallthrough
            case 305:
                fallthrough
            case 335:
                expectedDay = 1
                expectedMonth += 1
            case 366:
                expectedDay = 1
                expectedMonth = 1
                expectedYear += 1
            default:
                expectedDay += 1
            }
            
            currentDate.addTimeInterval(24*60*60)
        }
    }
    
    func testStartOfMonth() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-28T10:00:00+0000",
            "2021-02-01T18:59:59+0000",
            "2021-02-01T00:00:00+0000",
            
            "2021-10-31T19:01:00+0000",
            "2021-11-30T23:59:59+0000",
            "2023-06-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-02-01T00:00:00+0000",
            "2021-02-01T00:00:00+0000",
            "2021-02-01T00:00:00+0000",
            "2021-02-01T00:00:00+0000",
            
            "2021-10-01T00:00:00+0000",
            "2021-11-01T00:00:00+0000",
            "2023-06-01T00:00:00+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.startOfMonth))
            
            i += 1
        }
    }
    
    func testEndOfMonth() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-28T10:00:00+0000",
            "2021-02-01T18:59:59+0000",
            "2021-02-01T00:00:00+0000",
            
            "2021-10-31T19:01:00+0000",
            "2021-11-30T23:59:59+0000",
            "2023-06-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-02-28T23:59:59+0000",
            "2021-02-28T23:59:59+0000",
            "2021-02-28T23:59:59+0000",
            "2021-02-28T23:59:59+0000",
            
            "2021-10-31T23:59:59+0000",
            "2021-11-30T23:59:59+0000",
            "2023-06-30T23:59:59+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.endOfMonth))
            
            i += 1
        }
    }
    
    func testStartOfQuarter() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-01T10:00:00+0000",
            "2021-01-01T18:59:59+0000",
            "2021-03-30T00:00:00+0000",
            
            "2021-10-31T19:01:00+0000",
            "2021-07-30T23:59:59+0000",
            "2023-05-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            
            "2021-10-01T00:00:00+0000",
            "2021-07-01T00:00:00+0000",
            "2023-04-01T00:00:00+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.startOfQuarter))
            
            i += 1
        }
    }
    
    func testEndOfQuarter() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-01T10:00:00+0000",
            "2021-01-01T18:59:59+0000",
            "2021-03-30T00:00:00+0000",
            
            "2021-10-31T19:01:00+0000",
            "2021-07-30T23:59:59+0000",
            "2023-05-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-03-31T23:59:59+0000",
            "2021-03-31T23:59:59+0000",
            "2021-03-31T23:59:59+0000",
            "2021-03-31T23:59:59+0000",
            
            "2021-12-31T23:59:59+0000",
            "2021-09-30T23:59:59+0000",
            "2023-06-30T23:59:59+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.endOfQuarter))
            
            i += 1
        }
    }
    
    func testStartOfYearHalf() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-01T10:00:00+0000",
            "2021-01-01T18:59:59+0000",
            "2021-03-30T00:00:00+0000",
            
            "2021-10-31T19:01:00+0000",
            "2021-07-30T23:59:59+0000",
            "2023-05-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            
            "2021-07-01T00:00:00+0000",
            "2021-07-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.startOfYearHalf))
            
            i += 1
        }
    }
    
    func testEndOfYearHalf() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-01T10:00:00+0000",
            "2021-01-01T18:59:59+0000",
            "2021-03-30T00:00:00+0000",
            
            "2021-10-31T19:01:00+0000",
            "2021-07-30T23:59:59+0000",
            "2023-05-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-06-30T23:59:59+0000",
            "2021-06-30T23:59:59+0000",
            "2021-06-30T23:59:59+0000",
            "2021-06-30T23:59:59+0000",
            
            "2021-12-31T23:59:59+0000",
            "2021-12-31T23:59:59+0000",
            "2023-06-30T23:59:59+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.endOfYearHalf))
            
            i += 1
        }
    }
    
    func testStartOfYear() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-28T10:00:00+0000",
            "2021-02-01T18:59:59+0000",
            "2021-12-31T23:59:59+0000",
            
            "2021-10-31T19:01:00+0000",
            "2003-11-30T23:59:59+0000",
            "2023-06-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            "2021-01-01T00:00:00+0000",
            
            "2021-01-01T00:00:00+0000",
            "2003-01-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.startOfYear))
            
            i += 1
        }
    }
    
    func testEndOfYear() {
        let dates = [
            "2021-02-28T00:00:00+0000",
            "2021-02-28T10:00:00+0000",
            "2021-02-01T18:59:59+0000",
            "2021-12-31T23:59:59+0000",
            
            "2021-10-31T19:01:00+0000",
            "2003-11-30T23:59:59+0000",
            "2023-06-15T16:02:04+0000",
        ]
        
        let expected = [
            "2021-12-31T23:59:59+0000",
            "2021-12-31T23:59:59+0000",
            "2021-12-31T23:59:59+0000",
            "2021-12-31T23:59:59+0000",
            
            "2021-12-31T23:59:59+0000",
            "2003-12-31T23:59:59+0000",
            "2023-12-31T23:59:59+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.endOfYear))
            
            i += 1
        }
    }
    
    func testStartOfWeekMonday() {
        let dates = [
            "2023-01-09T00:00:00+0000",
            "2023-01-10T13:15:23+0000",
            "2023-01-11T00:00:00+0000",
            
            "2023-01-08T00:00:00+0000",
            "2023-01-07T00:00:00+0000",
            "2023-01-06T00:00:00+0000",
            "2023-01-05T00:00:00+0000",
            "2023-01-04T00:00:00+0000",
            "2023-01-03T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
        ]
        
        let expected = [
            "2023-01-09T00:00:00+0000",
            "2023-01-09T00:00:00+0000",
            "2023-01-09T00:00:00+0000",
            
            "2023-01-02T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.startOfWeek(weekStartsOn: .monday)))
            
            i += 1
        }
    }
    
    func testEndOfWeekMonday() {
        let dates = [
            "2023-01-09T00:00:00+0000",
            "2023-01-10T13:15:23+0000",
            "2023-01-11T00:00:00+0000",
            
            "2023-01-08T00:00:00+0000",
            "2023-01-07T00:00:00+0000",
            "2023-01-06T00:00:00+0000",
            "2023-01-05T00:00:00+0000",
            "2023-01-04T00:00:00+0000",
            "2023-01-03T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
        ]
        
        let expected = [
            "2023-01-15T23:59:59+0000",
            "2023-01-15T23:59:59+0000",
            "2023-01-15T23:59:59+0000",
            
            "2023-01-08T23:59:59+0000",
            "2023-01-08T23:59:59+0000",
            "2023-01-08T23:59:59+0000",
            "2023-01-08T23:59:59+0000",
            "2023-01-08T23:59:59+0000",
            "2023-01-08T23:59:59+0000",
            "2023-01-08T23:59:59+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.endOfWeek(weekStartsOn: .monday)))
            
            i += 1
        }
    }
    
    func testStartOfWeekSunday() {
        let dates = [
            "2023-01-09T00:00:00+0000",
            "2023-01-10T13:15:23+0000",
            "2023-01-11T00:00:00+0000",
            
            "2023-01-08T00:00:00+0000",
            "2023-01-07T00:00:00+0000",
            "2023-01-06T00:00:00+0000",
            "2023-01-05T00:00:00+0000",
            "2023-01-04T00:00:00+0000",
            "2023-01-03T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
        ]
        
        let expected = [
            "2023-01-08T00:00:00+0000",
            "2023-01-08T00:00:00+0000",
            "2023-01-08T00:00:00+0000",
            
            "2023-01-08T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
            "2023-01-01T00:00:00+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.startOfWeek(weekStartsOn: .sunday)))
            
            i += 1
        }
    }
    
    func testEndOfWeekSunday() {
        let dates = [
            "2023-01-09T00:00:00+0000",
            "2023-01-10T13:15:23+0000",
            "2023-01-11T00:00:00+0000",
            
            "2023-01-08T00:00:00+0000",
            "2023-01-07T00:00:00+0000",
            "2023-01-06T00:00:00+0000",
            "2023-01-05T00:00:00+0000",
            "2023-01-04T00:00:00+0000",
            "2023-01-03T00:00:00+0000",
            "2023-01-02T00:00:00+0000",
        ]
        
        let expected = [
            "2023-01-14T23:59:59+0000",
            "2023-01-14T23:59:59+0000",
            "2023-01-14T23:59:59+0000",
            
            "2023-01-14T23:59:59+0000",
            "2023-01-07T23:59:59+0000",
            "2023-01-07T23:59:59+0000",
            "2023-01-07T23:59:59+0000",
            "2023-01-07T23:59:59+0000",
            "2023-01-07T23:59:59+0000",
            "2023-01-07T23:59:59+0000",
        ]
        
        var i = 0
        for dateStr in dates {
            let date = dateFormatter.date(from: dateStr)!
            XCTAssertEqual(expected[i], dateFormatter.string(from: date.endOfWeek(weekStartsOn: .sunday)))
            
            i += 1
        }
    }
    
    func testDateIntervalExpanded() {
        let interval = DateInterval(start: self.date(from: "2023-01-01T00:00:00+0000"),
                                    end:   self.date(from: "2023-01-10T00:00:00+0000"))
        
        XCTAssertEqual(interval, interval.expanding(toContain: self.date(from: "2023-01-05T00:00:00+0000")))
        XCTAssertEqual(interval, interval.expanding(toContain: self.date(from: "2023-01-01T13:22:00+0000")))
        
        XCTAssertEqual(DateInterval(start: self.date(from: "2023-01-01T00:00:00+0000"),
                                    end:   self.date(from: "2023-01-11T00:00:00+0000")),
                       interval.expanding(toContain: self.date(from: "2023-01-11T00:00:00+0000")))
        
        XCTAssertEqual(DateInterval(start: self.date(from: "2018-01-01T00:00:00+0000"),
                                    end:   self.date(from: "2023-01-10T00:00:00+0000")),
                       interval.expanding(toContain: self.date(from: "2018-01-01T00:00:00+0000")))
    }
    
    func testDateIntervalOverlaps() {
        let interval = DateInterval(start: self.date(from: "2023-01-01T00:00:00+0000"),
                                    end:   self.date(from: "2023-01-10T00:00:00+0000"))
        
        // Enclosed interval
        XCTAssert(interval.overlaps(DateInterval(start: self.date(from: "2023-01-03T00:00:00+0000"),
                                                 end:   self.date(from: "2023-01-8T00:00:00+0000"))))
        
        // Surrounding interval
        XCTAssert(interval.overlaps(DateInterval(start: self.date(from: "2022-12-31T00:00:00+0000"),
                                                 end:   self.date(from: "2023-01-11T00:00:00+0000"))))
        
        // Interval overlaps, ends later
        XCTAssert(interval.overlaps(DateInterval(start: self.date(from: "2023-01-03T00:00:00+0000"),
                                                 end:   self.date(from: "2025-02-12T00:00:00+0000"))))
        
        // Interval overlaps, starts earlier
        XCTAssert(interval.overlaps(DateInterval(start: self.date(from: "2018-01-01T00:00:00+0000"),
                                                 end:   self.date(from: "2023-01-10T00:00:00+0000"))))
        XCTAssert(interval.overlaps(DateInterval(start: self.date(from: "2022-12-31T23:59:58+0000"),
                                                 end:   self.date(from: "2023-01-01T00:00:01+0000"))))
        
        // Interval before
        XCTAssertFalse(interval.overlaps(DateInterval(start: self.date(from: "2018-01-01T00:00:00+0000"),
                                                      end:   self.date(from: "2018-10-10T00:00:00+0000"))))
        XCTAssertFalse(interval.overlaps(DateInterval(start: self.date(from: "2022-12-31T23:59:58+0000"),
                                                      end:   self.date(from: "2022-12-31T23:59:59+0000"))))
        
        // Interval after
        XCTAssertFalse(interval.overlaps(DateInterval(start: self.date(from: "2023-01-11T00:00:00+0000"),
                                                      end:   self.date(from: "2023-01-15T00:00:00+0000"))))
        XCTAssertFalse(interval.overlaps(DateInterval(start: self.date(from: "2023-01-10T00:00:01+0000"),
                                                      end:   self.date(from: "2024-01-15T23:59:59+0000"))))
        
        // 0-duration interval
        XCTAssert(interval.overlaps(DateInterval(start: self.date(from: "2023-01-01T00:00:00+0000"),
                                                 end:   self.date(from: "2023-01-01T00:00:00+0000"))))
        XCTAssertFalse(interval.overlaps(DateInterval(start: self.date(from: "2015-01-01T00:00:00+0000"),
                                                      end:   self.date(from: "2015-01-01T00:00:00+0000"))))
    }
}
