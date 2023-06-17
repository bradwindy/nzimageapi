//
//  NZRecordsResult.swift
//  NZImage
//
//  Created by Bradley Windybank on 22/03/23.
//

import Foundation
import Vapor

struct NZRecordsResult: NonNullableResult, Content {
    // MARK: Lifecycle

    init(id: Int?, title: String?, description: String?, thumbnailUrl: URL?, largeThumbnailUrl: URL?, collection: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.largeThumbnailUrl = largeThumbnailUrl
        self.collection = collection
    }

    // MARK: Internal

    typealias ErrorType = NZRecordsResultError

    struct NZRecordsResultError: NonNullableError {
        enum NZRecordsResultErrorKind {
            case nullResultContent
            case nullImageOrTitle
        }

        typealias ErrorKind = NZRecordsResultErrorKind

        var result: any NonNullableResult
        var kind: NZRecordsResultErrorKind
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailUrl = "thumbnail_url"
        case largeThumbnailUrl = "large_thumbnail_url"
        case collection = "display_collection"
    }

    var id: Int?
    var title: String?
    var description: String?
    var thumbnailUrl: URL?
    var largeThumbnailUrl: URL?
    var collection: String?

    func customDescription() -> String {
        return """
        NZRecordsResult with id: \(String(describing: id)),
        title: \(String(describing: title)),
        description: \(String(describing: description)),
        thumbnailUrl: \(String(describing: thumbnailUrl)),
        largeThumbnailUrl: \(String(describing: largeThumbnailUrl)),
        collection: \(String(describing: collection))
        """
    }

    func checkNonNull() throws -> NZRecordsResult {
        if id != nil, title != nil, description != nil, thumbnailUrl != nil, largeThumbnailUrl != nil {
            return self
        }
        else {
            throw NZRecordsResultError(result: self, kind: .nullResultContent)
        }
    }

    func checkHasTitleAndLargeImage() throws -> NZRecordsResult {
        if id != nil, title != nil, largeThumbnailUrl != nil {
            return self
        }
        else {
            throw NZRecordsResultError(result: self, kind: .nullImageOrTitle)
        }
    }
}
