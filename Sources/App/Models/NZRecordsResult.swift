//
//  NZRecordsResult.swift
//  NZImage
//
//  Created by Bradley Windybank on 22/03/23.
//

import Foundation
import Vapor

import Foundation

struct NZRecordsResult: Decodable, Content {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnailUrl: URL?
    var largeThumbnailUrl: URL?
    var collection: String?

    init(id: Int?, title: String?, description: String?, thumbnailUrl: URL?, largeThumbnailUrl: URL?, collection: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.largeThumbnailUrl = largeThumbnailUrl
        self.collection = collection
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailUrl = "thumbnail_url"
        case largeThumbnailUrl = "large_thumbnail_url"
        case collection = "display_collection"
    }
    
    enum NZRecordsResultError: Error {
        case nullResultContent
        case nullImageOrTitle
    }
    
    func checkNonNull() throws -> NZRecordsResult {
        if id != nil, title != nil, description != nil, thumbnailUrl != nil, largeThumbnailUrl != nil {
            return self
        }
        else {
            throw NZRecordsResultError.nullResultContent
        }
    }
    
    func checkHasTitleAndLargeImage() throws -> NZRecordsResult {
        if id != nil, title != nil, largeThumbnailUrl != nil {
            return self
        }
        else {
            throw NZRecordsResultError.nullImageOrTitle
        }
    }
}
