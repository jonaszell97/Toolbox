import XCTest
@testable import Toolbox

final class FormatTests: XCTestCase {
    static let decimalSeparator = Locale.current.decimalSeparator ?? "."
    static let groupingSeparator = Locale.current.groupingSeparator ?? ","
    
    func testFormatFloatingPoint() {
        XCTAssertEqual(FormatToolbox.format(3.215, decimalPlaces: 2), "3\(Self.decimalSeparator)22")
        XCTAssertEqual(FormatToolbox.format(2.0, minDecimalPlaces: 2), "2\(Self.decimalSeparator)00")
        XCTAssertEqual(FormatToolbox.format(-2.131), "-2\(Self.decimalSeparator)13")
        XCTAssertEqual(FormatToolbox.format(-2.131, decimalPlaces: 10), "-2\(Self.decimalSeparator)131")
        XCTAssertEqual(FormatToolbox.format(2.0), "2")
        XCTAssertEqual(FormatToolbox.format(6.65, alwaysShowSign: true), "+6\(Self.decimalSeparator)65")
    }
    
    func testFormatInteger() {
        XCTAssertEqual(FormatToolbox.format(34), "34")
        XCTAssertEqual(FormatToolbox.format(34_000), "34\(Self.groupingSeparator)000")
        XCTAssertEqual(FormatToolbox.format(34_000, alwaysShowSign: true), "+34\(Self.groupingSeparator)000")
        XCTAssertEqual(FormatToolbox.format(-34_000), "-34\(Self.groupingSeparator)000")
        XCTAssertEqual(FormatToolbox.format(123_456_789), "123\(Self.groupingSeparator)456\(Self.groupingSeparator)789")
    }
    
    func testFormatYear() {
        XCTAssertEqual(FormatToolbox.formatYear(2021), "2021")
        XCTAssertEqual(FormatToolbox.formatYear(1922), "1922")
        XCTAssertEqual(FormatToolbox.formatYear(121), "121")
        XCTAssertEqual(FormatToolbox.formatYear(123456), "123456")
    }
    
    func testFormatPercentage() {
        XCTAssertEqual(FormatToolbox.formatPercentage(0.123), "12\(Self.decimalSeparator)3%")
        XCTAssertEqual(FormatToolbox.formatPercentage(1, minDecimalPlaces: 2), "100\(Self.decimalSeparator)00%")
        XCTAssertEqual(FormatToolbox.formatPercentage(0.5341, decimalPlaces: 0), "53%")
    }
    
    func testFormatTimeLimit() {
        XCTAssertEqual(FormatToolbox.formatTimeLimit(60, includeMilliseconds: false), "01:00")
        XCTAssertEqual(FormatToolbox.formatTimeLimit(120*60, includeMilliseconds: true), "02:00:00")
        XCTAssertEqual(FormatToolbox.formatTimeLimit(239.32, includeMilliseconds: true), "03:59.3")
    }
    
    func testFormatByteSize() {
        XCTAssertEqual(FormatToolbox.formatByteSize(39), "39 B")
        XCTAssertEqual(FormatToolbox.formatByteSize(1_234), "1\(Self.decimalSeparator)23 KB")
        XCTAssertEqual(FormatToolbox.formatByteSize(1_234_000), "1\(Self.decimalSeparator)23 MB")
        XCTAssertEqual(FormatToolbox.formatByteSize(1_234_000_000), "1\(Self.decimalSeparator)23 GB")
        XCTAssertEqual(FormatToolbox.formatByteSize(1_234_000_000_000), "1\(Self.decimalSeparator)23 TB")
    }
}
