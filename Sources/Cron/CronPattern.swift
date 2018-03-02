import Foundation
import Common

// TODO: add some predefined patterns, e.g. DatePattern.everyDay, DatePattern.everyHour, etc
// TODO: support multiple values, e.g. "5,10,15 *" or "*/10,15 *"
// * * 25 12 *

// A date-component pattern
struct DCPattern {
    public enum Constraint {
        case at
        case every
        // TODO: add ```case or```
    }

    let constraint: Constraint
    let value: Int

    init(constraint: Constraint = .at, value: Int) {
        self.constraint = constraint
        self.value = value
    }

    func isMatching(_ other: Int) -> Bool {
        switch constraint {
        case .at:
            return other == value

        case .every:
            return (other % value) == 0
        }
    }
}

fileprivate func parse(component: String) throws -> DCPattern? {
    if component == "*" {
        return nil
    } else if let value = Int(component) {
        return DCPattern(constraint: .at, value: value)
    } else if component.hasPrefix("*/") {
        let components = component.split(separator: "/")
        if let value = Int(components[1]) {
            return DCPattern(constraint: .every, value: value)
        }
    }

    throw ParsingError.invalidFormat
}

public struct CronPattern: DatePattern {
    let minutePattern: DCPattern?
    let hourPattern: DCPattern?

    public init?(_ expression: String) {
        let expressionComponents = expression.split(separator: " ")

        do {
            minutePattern = try parse(component: String(expressionComponents[0]))
            hourPattern = try parse(component: String(expressionComponents[1]))
        } catch {
            return nil
        }
    }

    public func isMatching(_ date: Date, calendar: Calendar = Calendar.current) -> Bool {
        var components = calendar.dateComponents(
            [.hour, .minute],
            from: date
        )

        return (
            (minutePattern?.isMatching(components.minute!) ?? true) &&
            (hourPattern?.isMatching(components.hour!) ?? true)
        )
    }

    public func nextDate(after startDate: Date, calendar: Calendar = Calendar.current) -> Date? {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .weekday],
            from: startDate
        )

        if let minutePattern = minutePattern {
            var value: Int

            switch minutePattern.constraint {
            case .at:
                value = minutePattern.value

            case .every:
                value = ((components.minute! / minutePattern.value) * minutePattern.value) + minutePattern.value
            }

            if value < components.minute! {
                components.hour! += 1
            }

            components.minute = value
        }

        if let hourPattern = hourPattern {
            var value: Int

            switch hourPattern.constraint {
            case .at:
                value = hourPattern.value

            case .every:
                value = ((components.hour! / hourPattern.value) * hourPattern.value) + hourPattern.value
            }

            if value < components.hour! {
                components.hour! += 1
            }

            components.hour = value
        }

        return calendar.date(from: components)
    }
}
