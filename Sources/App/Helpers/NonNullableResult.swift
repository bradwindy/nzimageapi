//
//  NonNullableResult.swift
//  NZImage
//
//  Created by Bradley Windybank on 10/04/23.
//

protocol NonNullableResult: Decodable {
    associatedtype ErrorType: NonNullableError
    func checkNonNull() throws -> Self
}

protocol NonNullableError: Error {
    associatedtype ErrorKind

    var result: any NonNullableResult { get }
    var kind: ErrorKind { get }
}
