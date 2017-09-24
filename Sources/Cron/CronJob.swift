import Foundation

public struct CronJob {
    let work: () -> Void
    let schedule: CronSchedule
    
    public init(work: @escaping () -> Void, schedule: CronSchedule) {
        self.work = work
        self.schedule = schedule
    }
    
    public func run() {
        work()
    }
}
