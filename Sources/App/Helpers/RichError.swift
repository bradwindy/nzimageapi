//
//  RichError.swift
//  
//
//  Created by Bradley Windybank on 10/04/23.
//

import Foundation

protocol RichError: Error {
    associatedtype ErrorKind

    var data: [String: Any?] { get }
    var kind: ErrorKind { get }
}
