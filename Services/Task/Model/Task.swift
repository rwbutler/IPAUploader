//
//  Task.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

protocol Task {
    var arguments: [String]? { get }
    var processURL: URL { get }
    var workingDirectoryURL: URL? { get }
}
