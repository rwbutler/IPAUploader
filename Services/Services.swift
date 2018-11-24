//
//  Services.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

public struct Services {
    
    static var commandLine: ArgumentsService {
        return CommandLineArgumentsService()
    }
    
    static func messaging(level: MessagingLevel = .default,
                          options: MessagingOptions = .console,
                          slackHookURL: URL? = nil) -> MessagingService {
        return CoordinatedMessagingService(level: level, options: options, slackHookURL: slackHookURL)
    }
    
    static var task: TaskService {
        return DefaultTaskService()
    }
    
}
