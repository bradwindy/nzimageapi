//
//  DigitalNZAPIDataSource.swift
//  NZImage
//
//  Created by Bradley Windybank on 25/03/23.
//

import Foundation
import OrderedCollections

class DigitalNZAPIDataSource {
    // MARK: Lifecycle

    init(requestManager: ValidatedRequestManager, collectionWeights: OrderedDictionary<String, Double>) {
        self.requestManager = requestManager
        self.collectionWeights = collectionWeights
    }

    // MARK: Internal

    struct DigitalNZAPIDataSourceError: RichError {
        typealias ErrorKind = DigitalNZAPIDataSourceErrorKind

        enum DigitalNZAPIDataSourceErrorKind {
            case noResults
            case non200StatusCode
            case nonJsonResponse
        }

        var kind: DigitalNZAPIDataSourceErrorKind
        var data: [String: Any?]
    }

    func newResult() async throws -> NZRecordsResult {
        let collection = collectionWeights.weightedRandomPick()
        let secondRequestResultsPerPage = 100
        let endpoint = "https://api.digitalnz.org/records.json"
        let apiKey: String? = nil

        let initialRequestParameters: [String: Any] = ["page": 1,
                                                       "per_page": 0,
                                                       "and[category][]": "Images",
                                                       "and[primary_collection][]": collection]

        let initialResponse: NZRecordsResponse = try await requestManager.makeRequest(endpoint: endpoint,
                                                                                      apiKey: apiKey,
                                                                                      parameters: initialRequestParameters,
                                                                                      validation: validation)

        let validatedResultCount = try initialResponse
            .checkNonNull()
            .search!
            .checkNonNull()
            .resultCount!

        let pageCount = validatedResultCount / secondRequestResultsPerPage

        guard pageCount > 0 else { throw DigitalNZAPIDataSourceError(kind: .noResults, data: ["initial response": initialResponse]) }

        let pageNumber = Int.random(in: 1 ... pageCount)

        let secondaryRequestParameters: [String: Any] = ["page": pageNumber,
                                                         "per_page": secondRequestResultsPerPage,
                                                         "and[category][]": "Images",
                                                         "and[primary_collection][]": collection]

        let secondaryResponse: NZRecordsResponse = try await requestManager.makeRequest(endpoint: endpoint,
                                                                                        apiKey: apiKey,
                                                                                        parameters: secondaryRequestParameters,
                                                                                        validation: validation)

        let validatedSearch = try secondaryResponse.checkNonNull().search!.checkNonNull()

        let chosenResultPosition = Int.random(in: 0 ..< secondRequestResultsPerPage)

        return try validatedSearch
            .results!
            .throwingAccess(chosenResultPosition)
            .checkHasTitleAndLargeImage()
    }

    // MARK: Private

    private let validation: (URLRequest?, HTTPURLResponse, Data?) -> Result<Void, Error> = { request, response, data in
        let acceptableStatusCodes = 200 ..< 300

        guard acceptableStatusCodes.contains(response.statusCode) else { return .failure(DigitalNZAPIDataSourceError(kind: .non200StatusCode, data: ["request": request,
                                                                                                                                                     "response": response,
                                                                                                                                                     "data": data])) }
        
        guard response.mimeType == "application/json" else { return .failure(DigitalNZAPIDataSourceError(kind: .nonJsonResponse, data: ["request": request,
                                                                                                                                        "response": response,
                                                                                                                                        "data": data])) }
        return .success(())
    }

    private let requestManager: ValidatedRequestManager
    private let collectionWeights: OrderedDictionary<String, Double>
}
