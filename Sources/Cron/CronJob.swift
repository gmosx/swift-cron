import Foundation

public class CronJob {
    let work: () -> Void
    let schedule: CronSchedule
    var _runDate: Date!
    
    public init(work: @escaping () -> Void, schedule: CronSchedule) {
        self.work = work
        self.schedule = schedule
    }
    
    public var runDate: Date {
        if _runDate == nil {
            _runDate = schedule.nextDate
        }
        
        return _runDate
    }
    
    public func run() {
        _runDate = schedule.nextDate
        work()
    }
}
