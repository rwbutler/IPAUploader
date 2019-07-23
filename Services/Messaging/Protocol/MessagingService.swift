//
//  MessagingService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/20/18.
//

import Foundation

protocol MessagingService: class {
    
    /// Determines whether or not the name of the application is shown in output.
    var emitApplicationName: Bool { get set }
    
    /// Sets the log level at which output will be emitted.
    var messagingLevel: MessagingLevel { get set }
    
    func flush()
    
    /// Sends message at the default log level.
    func message(_ message: String, level: MessagingLevel, completion: (() -> Void)?)
    
}

extension MessagingService {
    
    /// Retrieves the name of the application.
    func applicationName() -> String {
        return "IPA Uploader"
    }
    
    /// Convenience method for sending messages at the default log level.
    func message(_ message: String) {
        self.message(message, level: .default, completion: nil)
    }
    
    /// Convenience method for sending messages without a completion closure.
    func message(_ message: String, level: MessagingLevel) {
        self.message(message, level: level, completion: nil)
    }
    
}
