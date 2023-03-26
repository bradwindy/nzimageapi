//
//  Collection+Safe.swift
//  NZImage
//
//  Created by Bradley Windybank on 23/03/23.
//

import Foundation

enum CollectionError: Error {
    case indexOutOfBounds(index: Int, count: Int)
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// Returns the element at the specified index if it is within bounds, otherwise throws an error.
    func throwingAccess(_ index: Index) throws -> Element {
        if indices.contains(index) {
            return self[index]
        }
        else {
            throw CollectionError.indexOutOfBounds(index: self.distance(from: self.startIndex, to: index), count: self.count)
        }
    }
}
