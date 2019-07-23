//
//  ConsoleMessagingService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/20/18.
//

import Foundation

class ConsoleMessagingService: MessagingService {
    var emitApplicationName: Bool
    var messagingLevel: MessagingLevel
    
    init(emitApplicationName: Bool = false, level: MessagingLevel = .default) {
        self.emitApplicationName = emitApplicationName
        self.messagingLevel = level
    }
    
    func flush() {}
    
    func message(_ message: String, level: MessagingLevel = .default, completion: (() -> Void)?) {
        if UInt8(level.rawValue) <= UInt8(messagingLevel.rawValue) {
            let output = emitApplicationName ? "\(applicationName()): \(message)" : message
            print(output)
            completion?()
        }
    }
}
