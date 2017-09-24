import Foundation

// TODO: Extract this to use is calendars, recurring events, etc
// TODO: Add convenience method

public struct CronSchedule {
    public let components: DateComponents
    
    public init(
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second:Int? = nil,
        weekday: Int? = nil
    ) {
        self.components = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            weekday: weekday
        )
    }
    
    public func nextDate(startingFrom startDate: Date) -> Date? {
        let calendar = Calendar.current
        
        var nextComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .weekday],
            from: startDate
        )

        if let second = components.second {
            if (nextComponents.second! > second) {
                nextComponents.minute! += 1
            }
            nextComponents.second = second
        }

        if let minute = components.minute {
            if (nextComponents.minute! > minute) {
                nextComponents.hour! += 1
            }
            nextComponents.minute = minute
        }

        if let hour = components.hour {
            if (nextComponents.hour! > hour) {
                nextComponents.day! += 1
            }
            nextComponents.hour = hour
        }

        return calendar.date(from: nextComponents)
    }
    
    public var nextDate: Date? {
        return nextDate(startingFrom: Date())
    }
}
