//
//  RequestManager.swift
//  NZImage
//
//  Created by Bradley Windybank on 10/04/23.
//

import Foundation

protocol ValidatedRequestManager {
    /// Make an async, throwing request to an `endpoint` with an `apiKey` and `parameters`, returns response of `NonNullableResult`, useful for safe handling of API responses with nullable properties.
    func makeRequest<ResponseType: NonNullableResult>(endpoint: String, apiKey: String?, parameters: [String: Any]?, validation: @escaping (URLRequest?, HTTPURLResponse, Data?) -> Result<Void, Error>) async throws -> ResponseType
}
