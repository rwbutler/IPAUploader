//
//  DefaultMessagingService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/20/18.
//

import Foundation

class CoordinatedMessagingService: MessagingService {
    
    var emitApplicationName: Bool {
        didSet {
            messagingServices.forEach({ $0.emitApplicationName = emitApplicationName })
        }
    }
    var messagingLevel: MessagingLevel {
        didSet {
            messagingServices.forEach({ $0.messagingLevel = messagingLevel })
        }
    }
    let messagingServices: [MessagingService]
    
    init(emitApplicationName: Bool = false, level: MessagingLevel = .default, options: MessagingOptions = .all,
         slackHookURL: URL? = nil) {
        self.emitApplicationName = emitApplicationName
        self.messagingLevel = level
        var services: [MessagingService] = []
        let consoleMessagingService = ConsoleMessagingService(level: level)
        if options.contains(.console) {
            services.append(consoleMessagingService)
        }
        if options.contains(.slack), let hookURL = slackHookURL {
            services.append(SlackMessagingService(consoleMessagingService: consoleMessagingService,
                                                  hookURL: hookURL, level: level))
        }
        self.messagingServices = services
    }
    
    func flush() {
        messagingServices.forEach({ messagingService in
            messagingService.flush()
        })
    }
    
    func message(_ message: String, level: MessagingLevel, completion: (() -> Void)?) {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        messagingServices.forEach({ messagingService in
            dispatchGroup.enter()
            messagingService.message(message, level: level) {
                dispatchGroup.leave()
            }
        })
        dispatchGroup.wait()
        completion?()
    }
    
}
