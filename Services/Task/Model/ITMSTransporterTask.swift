//
//  ITMSTransporterTask.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

struct ITMSTransporterTask: Task {
    private static let defaultPath = URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms/bin/iTMSTransporter")
    let arguments: [String]?
    let processURL: URL
    let workingDirectoryURL: URL?
    
    init(ipaPath: URL, itmsTransporterPath: URL = defaultPath, username: String, password: String) {
        self.arguments = ["-m", "upload", "-assetFile", "\(ipaPath.path)", "-u", "\(username)", "-p", "\(password)"]
        self.processURL = itmsTransporterPath
        self.workingDirectoryURL = nil
    }
    
    init?(arguments: [Argument<Any>]) {
        let itmsTransporterPath = arguments.first(where: { $0.key == .username })?.value as? URL
            ?? ITMSTransporterTask.defaultPath
        guard let ipaPath = arguments.first(where: { $0.key == ArgumentKey.ipaPath })?.value as? URL,
            let username = arguments.first(where: { $0.key == .username })?.value as? String,
            let password = arguments.first(where: { $0.key == .password })?.value as? String else {
            return nil
        }
        self.init(ipaPath: ipaPath, itmsTransporterPath: itmsTransporterPath, username: username, password: password)
    }
    
}
