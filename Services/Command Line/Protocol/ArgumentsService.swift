//
//  ArgumentsService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

protocol ArgumentsService {
    func argumentsValid(_ arguments: [Argument<Any>]) -> Bool
    func processArguments(_ arguments: [String]) -> [Argument<Any>]
}
