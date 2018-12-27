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
        timer.schedule(deadline: deadline, repeating: repeatInterval)
        timer.setEventHandler { [weak self] in
            if let unwrapped = self {
                unwrapped.sendBufferedMessage()
            }
        }
        return timer
    }
    
    func formattedMessage(messages: [String]) -> String {
        let message = messages.joined(separator: "\n")
            .replacingOccurrences(of: "\"", with: "") // Strip double quotes
        return "\(applicationName()): \(message)\n"
    }
    
    func bufferEmpty() -> Bool {
        return simpleBuffer.isEmpty
    }
    
    func bufferedMessagesWithCompletion() -> [MessageWithCompletion] {
        let copiedBuffer = simpleBuffer
        simpleBuffer.removeAll()
        return copiedBuffer
    }
    
    func bufferedMessages(_ messages: [MessageWithCompletion]) -> [String] {
        return messages.map({ $0.0 })
    }
    
    func completionClosures(_ messages: [MessageWithCompletion]) -> [() -> Void] {
        return messages.compactMap({ $0.1 })
    }
    
    func sendBufferedMessage(_ completion: (() -> Void)? = nil) {
        // Ensure that there are buffered messages to be sent.
        guard !bufferEmpty() else { completion?(); return }
        
        let messagesWithCompletion: [MessageWithCompletion] = bufferedMessagesWithCompletion()
        let completions = completionClosures(messagesWithCompletion)
        let message = formattedMessage(messages: bufferedMessages(messagesWithCompletion))
        let completion: () -> Void = {
            completions.forEach({ $0() })
            completion?()
        }
        let request = urlRequest(url: hookURL, message: message)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.sendErrorMessage(error: error)
                completion()
                return
            }
            self?.sendResponseMessage(response: response, body: data)
            completion()
        }
        task.resume()
    }
    
    private func sendErrorMessage(error: Error?) {
        if let errorDescription = error?.localizedDescription {
            consoleMessagingService.message(errorDescription, level: .warn)
        }
    }
    
    /// Reports an error when response is return with a non-200 HTTP status code.
    private func sendResponseMessage(response: URLResponse?, body: Data) {
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            let statusCode = httpStatus.statusCode
            let fullResponse = String(describing: response)
            let message = "Returned non-200 status code: \(statusCode)\n with response: \(fullResponse)"
            consoleMessagingService.message(message, level: .warn)
            if let responseString = String(data: body, encoding: .utf8) {
                consoleMessagingService.message(responseString)
            }
        }
    }
    
    private func urlRequest(url: URL, message: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = "payload={\"text\": \"\(message)\"}".data(using: .utf8)
        return request
    }

}
