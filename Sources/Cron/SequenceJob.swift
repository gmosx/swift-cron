// TODO: also introduce ParallelJob

public class SequenceJob {
    let jobs: [Job]
    
    public init(jobs: [Job]) {
        self.jobs = jobs
    }
    
    public func run() {
        for job in jobs {
            job.run()
        }
    }
}
