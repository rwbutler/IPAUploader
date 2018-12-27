//
//  ITMSTransporterTask.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

struct ITMSTransporterTask: Task {
    // swiftlint:disable:next line_length
    private static let defaultPath = "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms/bin/iTMSTransporter"
     private static let defaultURL = URL(fileURLWithPath: defaultPath)
    let arguments: [String]?
    let processURL: URL
    let timeoutInSeconds: Double?
    let workingDirectoryURL: URL?
    
    init(ipaPath: URL, itmsTransporterPath: URL = defaultURL, username: String,
         password: String, timeoutInSeconds: Double? = nil) {
        self.arguments = ["-m", "upload", "-assetFile", "\(ipaPath.path)", "-u", "\(username)", "-p", "\(password)"]
        self.processURL = itmsTransporterPath
        self.timeoutInSeconds = timeoutInSeconds
        self.workingDirectoryURL = nil
    }
    
    init?(arguments: [Argument<Any>]) {
        let itmsTransporterPath = arguments.first(where: { $0.key == .username })?.value as? URL
            ?? ITMSTransporterTask.defaultURL
        guard let ipaPath = arguments.first(where: { $0.key == ArgumentKey.ipaPath })?.value as? URL,
            let username = arguments.first(where: { $0.key == .username })?.value as? String,
            let password = arguments.first(where: { $0.key == .password })?.value as? String else {
            return nil
        }
        let timeout = arguments.first(where: { $0.key == .timeout })?.value as? Double
        self.init(ipaPath: ipaPath, itmsTransporterPath: itmsTransporterPath, username: username, password: password,
                  timeoutInSeconds: timeout)
    }
    
}
