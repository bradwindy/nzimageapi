//
//  RequestManager.swift
//
//
//  Created by Bradley Windybank on 10/04/23.
//

import Foundation

protocol RequestManager {
    func makeRequest<ResponseType: Decodable>(endpoint: String, apiKey: String?, parameters: [String: Any]?) async throws -> ResponseType
}
