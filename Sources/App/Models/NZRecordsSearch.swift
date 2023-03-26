//
//  NZRecordsSearch.swift
//  NZImage
//
//  Created by Bradley Windybank on 22/03/23.
//

import Foundation

struct NZRecordsSearch: Decodable {
    var resultCount: Int?
    var results: [NZRecordsResult]?

    init(resultCount: Int?, results: [NZRecordsResult]?) {
        self.resultCount = resultCount
        self.results = results
    }

    enum CodingKeys: String, CodingKey {
        case resultCount = "result_count"
        case results
    }

    func checkNonNull() throws -> NZRecordsSearch {
        enum NZRecordsSearchError: Error {
            case nullSearchContent
        }

        if resultCount != nil, results != nil {
            return self
        }
        else {
            throw NZRecordsSearchError.nullSearchContent
        }
    }
}
