//
//  ITMSTransporterTask.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

struct ITMSTransporterTask: Task {
    let arguments: [String]?
    var processURL: URL
    let timeoutInSeconds: Double?
    let workingDirectoryURL: URL?
    
    init(ipaPath: URL, itmsTransporterURL: URL, username: String,
         password: String, timeoutInSeconds: Double? = nil) {
        self.arguments = ["-m", "upload", "-assetFile", "\(ipaPath.path)", "-u", "\(username)", "-p", "\(password)"]
        self.processURL = itmsTransporterURL
        self.timeoutInSeconds = timeoutInSeconds
        self.workingDirectoryURL = nil
    }
    
    init?(arguments: [Argument<Any>], itmsTransporterURL: URL) {
        let itmsTransporterURL = arguments.first(where: { $0.key == .itmsTransporterPath })?.value as? URL
            ?? itmsTransporterURL
        guard let ipaPath = arguments.first(where: { $0.key == .ipaPath })?.value as? URL,
            let username = arguments.first(where: { $0.key == .username })?.value as? String,
            let password = arguments.first(where: { $0.key == .password })?.value as? String else {
            return nil
        }
        let timeout = arguments.first(where: { $0.key == .timeout })?.value as? Double
        self.init(ipaPath: ipaPath, itmsTransporterURL: itmsTransporterURL, username: username, password: password,
                  timeoutInSeconds: timeout)
    }
    
}
