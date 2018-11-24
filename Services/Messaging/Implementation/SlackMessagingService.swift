//
//  SlackMessagingService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/20/18.
//

import Foundation

typealias MessageWithCompletion = (String, (() -> Void)?)

class SlackMessagingService: MessagingService {
    let consoleMessagingService: ConsoleMessagingService
    let dispatchGroup = DispatchGroup()
    let hookURL: URL
    private var flushed: Bool = false
    var messagingLevel: MessagingLevel
    var simpleBuffer: [MessageWithCompletion] = []
    var timer: DispatchSourceTimer?
    let queue = DispatchQueue(label: "com.example.repeating.queue", qos: .background)
    
    init(consoleMessagingService: ConsoleMessagingService, hookURL: URL, level: MessagingLevel = .default) {
        self.consoleMessagingService = consoleMessagingService
        self.hookURL = hookURL
        self.messagingLevel = level
    }
    
    deinit {
        cancelTimer()
        flush()
    }
    
    func message(_ message: String, level: MessagingLevel = .default, completion: (() -> Void)?) {
        if UInt8(level.rawValue) <= UInt8(messagingLevel.rawValue) {
            if timer == nil {
                timer = configureTimer()
                timer?.resume()
            }
            buffer(message: message, completion: completion)
        }
    }
    
    /// Sends all unsent messages
    func flush() {
        let group = dispatchGroup
        group.enter()
        sendBufferedMessage {
            group.leave()
        }
        group.wait()
    }
    
}

private extension SlackMessagingService {
    
    func buffer(message: String, completion: (() -> Void)?) {
        simpleBuffer.append((message, completion))
    }
    
   func cancelTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func configureTimer() -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        let repeatInterval = DispatchTimeInterval.seconds(2)
        let deadline: DispatchTime = (DispatchTime.now() + repeatInterval)
        timer.schedule(deadline: deadline, repeating:repeatInterval)
        timer.setEventHandler { [weak self] in
            if let unwrapped = self {
                unwrapped.sendBufferedMessage()
            }
        }
        return timer
    }
    
    func sendBufferedMessage(_ completion: (() -> Void)? = nil) {
        let copiedBuffer = simpleBuffer
        simpleBuffer.removeAll()
        
        // Ensure that there are buffered messages to be sent.
        guard !copiedBuffer.isEmpty else { completion?(); return }
        
        let message = copiedBuffer.map({ $0.0 }).joined(separator: "\n")
            .replacingOccurrences(of: "\"", with: "") // Strip double quotes
        let completion: () -> Void = {
            copiedBuffer.forEach({ (_, completion) in
                completion?()
            })
            completion?()
        }
        let formattedMessage = "\(applicationName()): \(message)\n"
        var request = URLRequest(url: hookURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = "payload={\"text\": \"\(formattedMessage)\"}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                if let errorDescription = error?.localizedDescription {
                    self?.consoleMessagingService.message(errorDescription, level: .warn)
                }
                completion()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                let statusCode = httpStatus.statusCode
                let fullResponse = String(describing: response)
                self?.consoleMessagingService.message("Returned non-200 status code: \(statusCode)\n with response: \(fullResponse)", level: .warn)
                if let responseString = String(data: data, encoding: .utf8) {
                    self?.consoleMessagingService.message(responseString)
                }
            }
            completion()
        }
        task.resume()
    }
    
}

