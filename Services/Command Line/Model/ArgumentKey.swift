//
//  ArgumentKey.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

enum ArgumentKey: String, RawRepresentable, CustomStringConvertible, CaseIterable, Hashable {
    
    case emitApplicationName = "--emit-app-name"
    case ipaPath = "--ipa-path"
    case itmsTransporterPath = "--itms-transporter-path"
    case notifyOnlyOnFailure = "--notify-only-on-failure"
    case username = "--username"
    case password = "--password"
    case slackURL = "--slack-url"
    case timeout = "--timeout"
    case verbose = "--verbose"
    case verboseOnFailure = "--verbose-on-failure"
    
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
    
    func argument(doubleString: String) -> Argument<Any>? {
        if let timeout = Double(doubleString) {
            return Argument(key: self, value: timeout as Any)
        }
        return nil
    }
    
    func argument(urlString: String) -> Argument<Any>? {
        if let url = URL(string: urlString) {
            return Argument(key: self, value: url as Any)
        }
        return nil
    }
    
    func argument(value: String) -> Argument<Any>? {
        let result: Argument<Any>?
        switch self {
        case .ipaPath, .itmsTransporterPath:
            let url = URL(fileURLWithPath: value)
            result = Argument(key: self, value: url as Any)
        case .username, .password:
            result = Argument(key: self, value: value)
        case .slackURL:
            result = argument(urlString: value)
        case .timeout:
            result = argument(doubleString: value)
        case .emitApplicationName, .notifyOnlyOnFailure, .verbose, .verboseOnFailure:
            result = Argument(key: self, value: nil)
        }
        return result
    }
    
    func extendedDescription() -> String {
        switch self {
        case .emitApplicationName:
            return "Emits the application name as part of output."
        case .ipaPath:
            return "* [Required] The path to the IPA to be uploaded."
        case .itmsTransporterPath:
            return "The path to ITMSTransporter for uploading."
        case .notifyOnlyOnFailure:
            return "Output will only be emitted in the event of a failure."
        case .password:
            return "* [Required] The password of the Apple ID to upload the IPA as."
        case .slackURL:
            return "The hook URL for posting to Slack."
        case .timeout:
            return "A timeout specified in seconds to wait on the upload."
        case .username:
            return "* [Required] The username of the Apple ID to upload the IPA as."
        case .verbose:
            return "Whether to emit extended output."
        case .verboseOnFailure:
            return "In the event of a failure, verbose output will be emitted to help diagnose the issue."
        }
    }
    
    /// Whether or not a value is expected to be associated with the specified key.
    func hasValue() -> Bool {
        switch self {
        case .emitApplicationName, .notifyOnlyOnFailure, .verbose, .verboseOnFailure:
            return false
        default:
            return true
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
        case .verbose:
            return ["-v"]
        case .emitApplicationName, .notifyOnlyOnFailure, .verboseOnFailure:
            return []
        }
    }
    
}
