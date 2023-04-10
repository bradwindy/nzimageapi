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

    init(requestManager: RequestManager, collectionWeights: OrderedDictionary<String, Double>) {
        self.requestManager = requestManager
        self.collectionWeights = collectionWeights
    }

    // MARK: Internal

    enum DigitalNZAPIDataSourceError: Error {
        case noResults
    }

    func newResult() async throws -> NZRecordsResult {
        let collection = self.collectionWeights.weightedRandomPick()
        let secondRequestResultsPerPage = 100
        let endpoint = "https://api.digitalnz.org/records.json"
        let apiKey: String? = nil

        let initialRequestParameters: [String: Any] = ["page": 1,
                                                       "per_page": 0,
                                                       "and[category][]": "Images",
                                                       "and[primary_collection][]": collection]

        let initialResponse: NZRecordsResponse = try await requestManager.makeRequest(endpoint: endpoint,
                                                                                      apiKey: apiKey,
                                                                                      parameters: initialRequestParameters)

        let validatedResultCount = try initialResponse
            .checkNonNull()
            .search!
            .checkNonNull()
            .resultCount!

        let pageCount = validatedResultCount / secondRequestResultsPerPage

        guard pageCount > 0 else { throw DigitalNZAPIDataSourceError.noResults }

        let pageNumber = Int.random(in: 1 ... pageCount)

        let secondaryRequestParameters: [String: Any] = ["page": pageNumber,
                                                         "per_page": secondRequestResultsPerPage,
                                                         "and[category][]": "Images",
                                                         "and[primary_collection][]": collection]

        let secondaryResponse: NZRecordsResponse = try await requestManager.makeRequest(endpoint: endpoint,
                                                                                        apiKey: apiKey,
                                                                                        parameters: secondaryRequestParameters)

        let validatedSearch = try secondaryResponse.checkNonNull().search!.checkNonNull()

        let chosenResultPosition = Int.random(in: 0 ..< secondRequestResultsPerPage)

        return try validatedSearch
            .results!
            .throwingAccess(chosenResultPosition)
            .checkHasTitleAndLargeImage()
    }

    // MARK: Private

    private let requestManager: RequestManager
    private let collectionWeights: OrderedDictionary<String, Double>
}
