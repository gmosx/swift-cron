import Foundation
import Dispatch
import LoggerAPI

// TODO: align timer to 0 seconds.

let tickInterval = 60.0

struct CronItem {
    let pattern: DatePattern
    let job: Job
}

struct FunctionJob: Job {
    let fn: () -> Void

    func run() {
        fn()
    }
}

public class Cron {
    var items: [CronItem]
    let calendar: Calendar
    let dispatchQueue: DispatchQueue
    var _isRunning: Bool

    public init(calendar: Calendar = Calendar.current) {
        items = []
        self.calendar = calendar
        dispatchQueue = DispatchQueue(label: "cronQueue", attributes: .concurrent)
        _isRunning = false
    }

    public func schedule(pattern: DatePattern, job: Job) {
        items.append(CronItem(pattern: pattern, job: job))
    }

    public func schedule(pattern: String, job: Job) {
        schedule(pattern: DatePattern(pattern)!, job: job)
    }

    public func schedule(pattern: DatePattern, fn: @escaping () -> Void) {
        items.append(CronItem(pattern: pattern, job: FunctionJob(fn: fn)))
    }

    public func schedule(pattern: String, fn: @escaping () -> Void) {
        schedule(pattern: DatePattern(pattern)!, fn: fn)
    }

    public func start() {
        _isRunning = true
        run()
    }

    public func stop() {
        _isRunning = false
    }

    public var isRunning: Bool {
        return _isRunning
    }

    public func run() {
        while _isRunning {
            dispatchQueue.async {
                Log.verbose("Cron tick")

                let nowDate = Date()

                for item in self.items {
                    if item.pattern.isMatching(nowDate, calendar: self.calendar) {
                        item.job.run()
                    }
                }
            }

            Thread.sleep(forTimeInterval: tickInterval)
        }
    }
}
