// TODO: Deprecate this!

import XCTest
@testable import Cron

class CronScheduleTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSchedule() {
        let startDate = Date()
        let schedule = CronSchedule(minute: 15, second: 0)
        let nextDate = schedule.nextDate(startingFrom: startDate)
        
        XCTAssertNotNil(nextDate)
        
        if let nextDate = nextDate {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: nextDate)

            XCTAssertEqual(components.minute, 15)
            XCTAssertEqual(components.second, 0)
            XCTAssert(nextDate > startDate)
        }
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    static var allTests = [
        ("testSchedule", testSchedule),
    ]
}
