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
    private let version: String = "1.0.0"
    
    func main() -> ReturnCode {
        printVersion()
        let arguments = argumentsService.processArguments(CommandLine.arguments)
        
        guard argumentsService.argumentsValid(arguments),
            let transporterTask = ITMSTransporterTask(arguments: arguments) else {
                printUsage()
                return ReturnCode.invalidArguments
        }
        
        let fileURLs: [URL] = arguments.compactMap({ argument in
            guard let url = argument.value as? URL, url.isFileURL else { return nil }
            return url
        })
        
        guard !fileURLs.isEmpty else {
            printUsage()
            return ReturnCode.fileURLNotSpecified
        }
        
        // Check all file URLs passed as parameters exist.
        guard allFilesExist(fileURLs: fileURLs) else {
            return ReturnCode.fileDoesNotExist
        }
        let slackURL = arguments.first(where: { $0.key == .slackURL })?.value as? URL
        let verboseOutput: Bool = arguments.contains(where: { $0.key == .verbose })
        let messagingLevel: MessagingLevel = verboseOutput ? .verbose : .default
        messagingService = Services.messaging(level: messagingLevel, options: .all, slackHookURL: slackURL)
        return performUpload(task: transporterTask, verboseOutput: verboseOutput)
    }
    
    private func allFilesExist(fileURLs: [URL]) -> Bool {
        let fileManager = FileManager.default
        if let fileURL = fileURLs.first(where: { !fileManager.fileExists(atPath: $0.path) }) {
            messagingService.message("File at \(fileURL.path) doesn't exist.", level: .default)
            return false
        }
        return true
    }
    
    private func performUpload(task uploadTask: Task, verboseOutput: Bool = false) -> ReturnCode {
        var returnCode: ReturnCode = ReturnCode.itmsTransporterDidNotComplete
        messagingService.message("Uploading... ☁", level: .default)
        if let output = taskService.run(task: uploadTask) {
            if output.lowercased().contains("error itms") {
                returnCode = ReturnCode.uploadFailed
            }
            if output.lowercased().contains("uploaded successfully") {
                returnCode = ReturnCode.success
            }
            if verboseOutput {
                messagingService.message(output, level: .default)
            }
        }
        let successMessage = "Uploaded succesfully ✅"
        let failureMessage = "Upload failed ❌"
        let outputMessage = (returnCode == ReturnCode.success) ? successMessage : failureMessage
        messagingService.message(outputMessage, level: .default)
        messagingService.flush()
        return returnCode
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

let returnCode = Main().main()
exit(returnCode.rawValue)
