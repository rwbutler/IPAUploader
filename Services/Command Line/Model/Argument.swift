//
//  Argument.swift
//  ipa-uploader
//
//  Created by Ross Butler on 11/19/18.
//

import Foundation

struct Argument<T> {
    typealias Key = ArgumentKey
    
    let key: Key
    let value: T?
}
