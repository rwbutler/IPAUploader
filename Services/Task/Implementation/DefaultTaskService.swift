//
//  DefaultTaskService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

struct DefaultTaskService: TaskService {
    private let queue = DispatchQueue(label: "timeout", qos: .background)
    
    /// Executes the specified task and return the output, if any
    func run(task: Task) -> String? {
        let dispatchGroup = DispatchGroup()
        let pipe = Pipe()
        let pipeReader = pipe.fileHandleForReading
        let process = Process()
        if let arguments = task.arguments {
            process.arguments = arguments
        }
        if let workingDirectoryURL = task.workingDirectoryURL {
            process.currentDirectoryURL = workingDirectoryURL
        }
        process.executableURL = task.processURL
        process.standardOutput = pipe
        process.standardError = pipe
        process.terminationHandler = { (process) in
            dispatchGroup.leave()
        }
        do {
            dispatchGroup.enter()
            if let timeout = task.timeoutInSeconds {
                let deadline = DispatchTime.now() + timeout
                queue.asyncAfter(deadline: deadline, execute: {
                    process.terminate()
                })
            }
            try process.run()
            dispatchGroup.wait()
            let processData = pipeReader.readDataToEndOfFile()
            guard let processOutput = String(data: processData, encoding: .utf8) else {
                pipeReader.closeFile()
                return nil
            }
            pipeReader.closeFile()
            return processOutput
        } catch _ {
            return nil
        }
    }
    
}

