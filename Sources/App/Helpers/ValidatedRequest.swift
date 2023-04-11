//
//  ValidatedRequest.swift
//  NZImage
//
//  Created by Bradley Windybank on 26/03/23.
//

import Alamofire
import Foundation

class NetworkRequestManager: ValidatedRequestManager {
    struct NetworkRequestManagerError: RichError {
        typealias ErrorKind = NetworkRequestManagerErrorKind

        enum NetworkRequestManagerErrorKind {
            case non200StatusCode
            case nonJsonResponse
        }

        var kind: NetworkRequestManagerErrorKind
        var data: [String: Any?]
    }

    var validation: (URLRequest?, HTTPURLResponse, Data?) -> Result<Void, Error> = { request, response, data in
        let acceptableStatusCodes = 200 ..< 300

        guard acceptableStatusCodes.contains(response.statusCode) else { return .failure(NetworkRequestManagerError(kind: .non200StatusCode, data: ["request": request,
                                                                                                                                                    "response": response,
                                                                                                                                                    "data": data])) }

        guard response.mimeType == "application/json" else { return .failure(NetworkRequestManagerError(kind: .nonJsonResponse, data: ["request": request,
                                                                                                                                       "response": response,
                                                                                                                                       "data": data])) }
        return .success(())
    }

    func makeRequest<ResponseType: NonNullableResult>(endpoint: String, apiKey: String? = nil, parameters: [String: Any]? = nil) async throws -> ResponseType {
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
