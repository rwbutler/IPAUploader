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
    private let version: String = "1.1.3"
    // swiftlint:disable:next line_length
    private let xcode10Path = "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms/bin/iTMSTransporter"
    private let xcode11Path = "/Applications/Xcode.app/Contents/Developer/usr/bin/iTMSTransporter"
    
    func main() throws -> ReturnCode {
        printVersion()
        let arguments = argumentsService.processArguments(CommandLine.arguments)
        let xcode11URL = URL(fileURLWithPath: xcode11Path)
        guard argumentsService.argumentsValid(arguments),
            var transporterTask = ITMSTransporterTask(arguments: arguments, itmsTransporterURL: xcode11URL) else {
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
        let notifyOnlyOnFailure: Bool = arguments.contains(where: { $0.key == .notifyOnlyOnFailure })
        let verboseOnFailure: Bool = arguments.contains(where: { $0.key == .verboseOnFailure })
        let verboseOutput: Bool = arguments.contains(where: { $0.key == .verbose })
        let messagingLevel: MessagingLevel = verboseOutput ? .verbose : .default
        messagingService = Services.messaging(level: messagingLevel, options: .all, slackHookURL: slackURL)
        if !notifyOnlyOnFailure {
            messagingService.message("Uploading IPA... ☁", level: .default)
        }
        do {
            // Attempt upload using path to iTMSTransporter with Xcode 11.
            return try performUpload(task: transporterTask, notifyOnlyOnFailure: notifyOnlyOnFailure,
                                     verboseOnFailure: verboseOnFailure)
        } catch {
            // Fallback - attempt upload using path to iTMSTransporter with Xcode 10 or below.
            transporterTask.processURL = URL(fileURLWithPath: xcode10Path)
            return try performUpload(task: transporterTask, notifyOnlyOnFailure: notifyOnlyOnFailure,
                                     verboseOnFailure: verboseOnFailure)
        }
    }
    
    private func allFilesExist(fileURLs: [URL]) -> Bool {
        let fileManager = FileManager.default
        if let fileURL = fileURLs.first(where: { !fileManager.fileExists(atPath: $0.path) }) {
            messagingService.message("File at \(fileURL.path) doesn't exist.", level: .default)
            return false
        }
        return true
    }
    
    private func performUpload(task uploadTask: Task, notifyOnlyOnFailure: Bool = false, verboseOnFailure: Bool = false)
        throws -> ReturnCode {
            var returnCode: ReturnCode = ReturnCode.itmsTransporterDidNotComplete
            let output = try taskService.run(task: uploadTask)
            if output.lowercased().contains("error itms") {
                returnCode = ReturnCode.uploadFailed
                if verboseOnFailure { // Output if even if verbose not set where a failure has occurred.
                    messagingService.message(output, level: .default)
                }
            }
            if output.lowercased().contains("uploaded successfully") {
                returnCode = ReturnCode.success
            }
            messagingService.message(output, level: .verbose)
            let successMessage = "Uploaded succesfully ✅"
            let failureMessage = "Upload failed ❌"
            let outputMessage = (returnCode == ReturnCode.success) ? successMessage : failureMessage
            
            // Where `notifyOnlyOnFailure` set we should emit the upload result only where a failure occurs.
            if (notifyOnlyOnFailure && returnCode != .success) || !notifyOnlyOnFailure {
                messagingService.message(outputMessage, level: .default)
            }
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

do {
    let returnCode = try Main().main()
    exit(returnCode.rawValue)
} catch _ {
    exit(ReturnCode.itmsTransporterDidNotComplete.rawValue)
}
