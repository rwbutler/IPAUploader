//
//  CommandLineArgumentsService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

struct CommandLineArgumentsService: ArgumentsService {
    
    func argumentsValid(_ arguments: [Argument<Any>]) -> Bool {
        let argumentKeys = arguments.map({ $0.key })
        let requiredArguments: [Argument.Key] = [.ipaPath, .username, .password]
        let isValid = requiredArguments.reduce(true, { (result, nextArgument)  in
            return result && argumentKeys.contains(where: { nextArgument == $0 })
        })
        return isValid
    }
    
    func processArguments(_ arguments: [String]) -> [Argument<Any>] {
        var parsingMode: Argument<Any>.Key?
        var result: [Argument<Any>] = []
        
        for i in 1 ..< CommandLine.arguments.count {
            let argumentString = CommandLine.arguments[i]
            if let argumentKey = Argument.Key(rawValue: argumentString) {
                parsingMode = argumentKey
            } else if let mode = parsingMode,
                let argumentModel = mode.argument(value: argumentString) {
                result.append(argumentModel)
            }
        }
        return result
    }
    
}

