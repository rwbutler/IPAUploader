//
//  main.swift
//  ipa-uploader-cli
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation


class Main {
    private let argumentsService = Services.commandLine
    private var messagingService = Services.messaging()
    private let taskService = Services.task
    private let version: String = "0.0.1"
    
    func main() {
        printVersion()
        
        let argumentStrings = CommandLine.arguments
        let arguments = argumentsService.processArguments(argumentStrings)
        
        guard argumentsService.argumentsValid(arguments),
            let transporterTask = ITMSTransporterTask(arguments: arguments) else {
            printUsage()
            return
        }
        
        let fileURLs: [URL] = arguments.compactMap({ argument in
            guard let url = argument.value as? URL, url.isFileURL else { return nil }
            return url
        })
        guard !fileURLs.isEmpty else {
            printUsage()
            return
        }
    
        // Check all file URLs passed as parameters exist.
        let fileManager = FileManager.default
        if let fileURL = fileURLs.first(where: { !fileManager.fileExists(atPath: $0.path) }) {
            messagingService.message("File at \(fileURL.path) doesn't exist.", level: .default)
            return
        }
        
        
        let slackURL = arguments.first(where: { $0.key == .slackURL })?.value as? URL
        messagingService = Services.messaging(level: .verbose, options: .all, slackHookURL: slackURL)
        messagingService.message("Uploading...", level: .default)
        
        if let output = taskService.run(task: transporterTask) {
            messagingService.message(output, level: .default)
        }
        
        messagingService.message("done.", level: .default)
        messagingService.flush()
    }
    
    private func printUsage() {
        messagingService.message("Usage:", level: .default)
        for argumentKey in Argument.Key.allCases {
            messagingService.message("\(argumentKey): \(argumentKey.extendedDescription())", level: .default)
        }
    }
    
    private func printVersion() {
        messagingService.message("\(messagingService.applicationName()) v\(version)")
    }
    
}

Main().main()

