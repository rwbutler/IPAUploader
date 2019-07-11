//
//  ReturnCode.swift
//  ipa-uploader-cli
//
//  Created by Ross Butler on 7/11/19.
//

import Foundation

enum ReturnCode: Int32 {
    case success = 0
    case invalidArguments = 1
    case uploadFailed
    case itmsTransporterDidNotComplete
    case fileDoesNotExist
    case fileURLNotSpecified
}
