import Foundation
import Dispatch

// TODO: management of jobs array should be external?

let tickInterval = 60.0

public class Cron {
    var jobs: [CronJob]
    let dispatchQueue: DispatchQueue
    var _isRunning: Bool
    
    public init() {
        jobs = []
        dispatchQueue = DispatchQueue(label: "cronQueue", attributes: .concurrent)
        _isRunning = false
    }
    
    public func append(job: CronJob) {
        jobs.append(job)
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
            let nowDate = Date()

            for job in jobs {
                if let runDate = job.schedule.nextDate {
                    if runDate < nowDate {
                        dispatchQueue.async {
                            job.run()
                        }
                    }
                }
            }
            
            Thread.sleep(forTimeInterval: tickInterval)
        }
    }
}

/*
 
 let cron = Cron()
 cron.append(CronJob(CronSchedule(minute: 5, second: 0), () => { print("tick") }))
 cron.append(CronJob(CronSchedule(minute: 60, second: 0), () => { print("tick") }))
 cron.start()
 
 */
