//
//  NZRecordsResponse.swift
//  NZImage
//
//  Created by Bradley Windybank on 22/03/23.
//

struct NZRecordsResponse: Decodable {
    var search: NZRecordsSearch?

    init(search: NZRecordsSearch?) {
        self.search = search
    }

    enum CodingKeys: String, CodingKey {
        case search
    }
    
    func checkNonNull() throws -> NZRecordsResponse {
        enum NZRecordsResponseError: Error {
            case nullResponseContent
        }
        
        if search != nil {
            return self
        }
        else {
            throw NZRecordsResponseError.nullResponseContent
        }
    }
}
