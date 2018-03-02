import XCTest
@testable import Cron

let calendar = Calendar.current
let tz = TimeZone.current
var startDate: Date = Date()
var anotherDate: Date = Date()

class CronPatternTests: XCTestCase {
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
        var datePattern: CronPattern
        var nextDate: Date
        var components: DateComponents

        datePattern = CronPattern("3 *")!
        nextDate = datePattern.nextDate(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)

        XCTAssertEqual(components.minute, 3)
    }

    func testHourAtConstraint() {
        var datePattern: CronPattern
        var nextDate: Date
        var components: DateComponents

        datePattern = CronPattern("6 15")!
        nextDate = datePattern.nextDate(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)

        XCTAssertEqual(components.minute, 6)
        XCTAssertEqual(components.hour, 15)
    }

    func testMinuteEveryConstraint() {
        var datePattern: CronPattern
        var nextDate: Date
        var components: DateComponents
        
        datePattern = CronPattern("*/3 *")!

        nextDate = datePattern.nextDate(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)

        XCTAssertEqual(components.minute, 21)
        XCTAssertEqual(components.hour, 8)

        nextDate = datePattern.nextDate(after: nextDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)
        
        XCTAssertEqual(components.minute, 24)

        datePattern = CronPattern("*/30 *")!

        nextDate = datePattern.nextDate(after: startDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)
        
        XCTAssertEqual(components.minute, 30)
        XCTAssertEqual(components.hour, 8)

        nextDate = datePattern.nextDate(after: nextDate)!
        components = calendar.dateComponents(in: tz, from: nextDate)
        
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.hour, 9)
    }

    func testIsMatchingAt() {
        var datePattern: CronPattern

        datePattern = CronPattern("* *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = CronPattern("20 *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = CronPattern("20 8")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = CronPattern("0 9")!
        XCTAssertTrue(datePattern.isMatching(anotherDate))
    }

    func testIsMatchingEvery() {
        var datePattern: CronPattern
        
        datePattern = CronPattern("*/20 *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = CronPattern("*/5 *")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = CronPattern("*/3 *")!
        XCTAssertFalse(datePattern.isMatching(startDate))

        datePattern = CronPattern("* */8")!
        XCTAssertTrue(datePattern.isMatching(startDate))

        datePattern = CronPattern("20 */8")!
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

