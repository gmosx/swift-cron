// TODO: Deprecate this!

import Foundation

// TODO: Extract this to use is calendars, recurring events, etc
// TODO: Rename: CronPattern, DatePattern, DateSchedule, RecurringSchedule
// TODO: Generator/Stream of scheduled days.

/// Examples
/// - every minute: (second: 0)
/// - every hour: (minute: 0)
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
    
    /// Returns the next date that matches this pattern, starting from the
    /// given date.
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

        // TODO: check other components
        
        return calendar.date(from: nextComponents)
    }
    
    public var nextDate: Date? {
        return nextDate(startingFrom: Date())
    }
}
