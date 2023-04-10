//
//  ValidatedRequest.swift
//  NZImage
//
//  Created by Bradley Windybank on 26/03/23.
//

import Alamofire
import Foundation

class NetworkRequestManager: ValidatedRequestManager {
    func makeRequest<ResponseType: NonNullableResult>(endpoint: String, apiKey: String? = nil, parameters: [String: Any]? = nil, validation: @escaping (URLRequest?, HTTPURLResponse, Data?) -> Result<Void, Error>) async throws -> ResponseType {
        var headers: HTTPHeaders? = nil

        if let apiKey {
            headers = HTTPHeaders(["Authentication-Token": apiKey])
        }

        let request = AF.request(endpoint, parameters: parameters, headers: headers)

        let result = await request
            .validate(validation)
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
