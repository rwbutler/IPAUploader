//
//  ArgumentKey.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

enum ArgumentKey: String, RawRepresentable, CustomStringConvertible, CaseIterable, Hashable {
    
    case ipaPath = "--ipa-path"
    case itmsTransporterPath = "--itms-transporter-path"
    case username = "--username"
    case password = "--password"
    case slackURL = "--slack-url"
    case timeout = "--timeout"
    
    init?(rawValue: String) {
        
        let lowercasedValue = rawValue.lowercased()
        
        guard let argument = type(of: self).allCases.first(where: { argument in
            if argument.rawValue == lowercasedValue {
                return true
            }
            return argument.shortcuts().contains(lowercasedValue)
        }) else {
            return nil
        }
        self = argument
    }
    
    var description: String {
        return self.rawValue
    }
    
    func argument(value: String) -> Argument<Any>? {
        switch self {
        case .ipaPath:
            let url = URL(fileURLWithPath: value)
            return Argument(key: self, value: url as Any)
        case .itmsTransporterPath:
            let url = URL(fileURLWithPath: value)
            return Argument(key: self, value: url as Any)
        case .username:
            return Argument(key: self, value: value)
        case .password:
            return Argument(key: self, value: value)
        case .slackURL:
            if let url = URL(string: value) {
                return Argument(key: self, value: url as Any)
            }
        case .timeout:
            if let timeout = Double(value) {
                return Argument(key: self, value: timeout as Any)
            }
        }
        return nil
    }
    
    func extendedDescription() -> String {
        switch self {
        case .ipaPath:
            return "The path to the IPA to be uploaded."
        case .itmsTransporterPath:
            return "[Optional] The path to ITMSTransporter for uploading."
        case .password:
            return "The password of the Apple ID to upload the IPA as."
        case .slackURL:
            return "[Optional] The hook URL for posting to Slack."
        case .timeout:
            return "[Optional] A timeout specified in seconds to wait on the upload."
        case .username:
            return "The username of the Apple ID to upload the IPA as."
        }
    }
    
    func shortcuts() -> [String] {
        switch self {
        case .ipaPath:
            return ["-i", "-ipa"]
        case .itmsTransporterPath:
            return ["-t", "-transporter", "-itms"]
        case .password:
            return ["-p", "-pass"]
        case .slackURL:
            return ["-s", "-slack"]
        case .timeout:
            return ["-time", "-wait"]
        case .username:
            return ["-u", "-user"]
        }
    }
    
}
