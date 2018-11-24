//
//  ConsoleMessagingService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/20/18.
//

import Foundation

class ConsoleMessagingService: MessagingService {
    var messagingLevel: MessagingLevel
    
    init(level: MessagingLevel = .default) {
        self.messagingLevel = level
    }
    
    func flush() {}
    
    func message(_ message: String, level: MessagingLevel = .default, completion: (() -> Void)?) {
        if UInt8(level.rawValue) <= UInt8(messagingLevel.rawValue) {
            print("\(message)")
            completion?()
        }
    }
}
