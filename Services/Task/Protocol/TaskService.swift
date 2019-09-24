//
//  TaskService.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

protocol TaskService {
    func run(task: Task) throws -> String
}
