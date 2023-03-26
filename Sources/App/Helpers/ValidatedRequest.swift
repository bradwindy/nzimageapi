//
//  ValidatedRequest.swift
//  
//
//  Created by Bradley Windybank on 26/03/23.
//

import Alamofire
import Foundation

class ValidatedRequest {
    static func makeRequest<ResponseType: Decodable>(endpoint: String, apiKey: String? = nil, parameters: [String: Any]? = nil) async throws -> ResponseType {
        var headers: HTTPHeaders? = nil
        
        if let apiKey {
            headers = HTTPHeaders(["Authentication-Token": apiKey])
        }

        let request = AF.request(endpoint, parameters: parameters, headers: headers)

        let result = await request
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .serializingDecodable(ResponseType.self)
            .result

        switch result {
        case .success(let value):
            return value

        case .failure(let error):
            throw error
        }
    }
}
