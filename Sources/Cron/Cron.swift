import Foundation
import Dispatch

let tickInterval = 60.0

struct CronItem {
    let pattern: DatePattern
    let job: Job
}

public class Cron {
    var items: [CronItem]
    let dispatchQueue: DispatchQueue
    var _isRunning: Bool
    
    public init() {
        items = []
        dispatchQueue = DispatchQueue(label: "cronQueue", attributes: .concurrent)
        _isRunning = false
    }
    
    public func schedule(pattern: DatePattern, job: Job) {
        items.append(CronItem(pattern: pattern, job: job))
    }

    public func schedule(pattern: DatePattern, jobClosure: () -> Void) {
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

            print("tick \(nowDate)")
            
//            for job in jobs {
//                print(".... \(job.runDate)")
//                if job.runDate < nowDate {
//                    dispatchQueue.async {
//                        job.run()
//                    }
//                }
//            }
            
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
