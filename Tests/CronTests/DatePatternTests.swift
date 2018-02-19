import XCTest
@testable import Cron

let calendar = Calendar.current
let tz = TimeZone.current
var startDate: Date = Date()
var anotherDate: Date = Date()

class DatePatternTests: XCTestCase {
    override func setUp() {
        super.setUp()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = tz
        startDate = dateFormatter.date(from: "2013-02-09 08:20:00")!
        anotherDate = dateFormatter.date(from: "2013-02-09 09:00:00")!
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMinuteAtConstraint() {
        var datePattern: DatePattern
        var nextDate: Date
        var components: DateComponents

        datePattern = DatePattern("3 *")!
        nextDate = datePattern.date(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)

        XCTAssertEqual(components.minute, 3)
    }

    func testHourAtConstraint() {
        var datePattern: DatePattern
        var nextDate: Date
        var components: DateComponents

        datePattern = DatePattern("6 15")!
        nextDate = datePattern.date(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)

        XCTAssertEqual(components.minute, 6)
        XCTAssertEqual(components.hour, 15)
    }

    func testMinuteEveryConstraint() {
        var datePattern: DatePattern
        var nextDate: Date
        var components: DateComponents
        
        datePattern = DatePattern("*/3 *")!

        nextDate = datePattern.date(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)

        XCTAssertEqual(components.minute, 21)
        XCTAssertEqual(components.hour, 8)

        nextDate = datePattern.date(after: nextDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)
        
        XCTAssertEqual(components.minute, 24)

        datePattern = DatePattern("*/30 *")!

        nextDate = datePattern.date(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)
        
        XCTAssertEqual(components.minute, 30)
        XCTAssertEqual(components.hour, 8)

        nextDate = datePattern.date(after: nextDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)
        
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.hour, 9)
    }

    func testIsMatchingAt() {
        var datePattern: DatePattern

        datePattern = DatePattern("* *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = DatePattern("20 *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = DatePattern("20 8")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = DatePattern("0 9")!
        XCTAssertTrue(datePattern.isMatching(anotherDate))
    }

    func testIsMatchingEvery() {
        var datePattern: DatePattern
        
        datePattern = DatePattern("*/20 *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = DatePattern("*/5 *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = DatePattern("*/3 *")!
        XCTAssertFalse(datePattern.isMatching(startDate))

        datePattern = DatePattern("* */8")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = DatePattern("20 */8")!
        XCTAssertTrue(datePattern.isMatching(startDate))
    }

    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
//    static var allTests = [
//        ("testMinuteAtConstraint", testMinuteAtConstraint),
//    ]
}

