//
//  OrderedDictionary+WeightedPick.swift
//  NZImage
//
//  Created by Bradley Windybank on 10/04/23.
//

import Foundation
import OrderedCollections

public extension OrderedDictionary<String, Double> {
    func weightedRandomPick() -> String {
        let randomFloatThreshold = Double.random(in: 0 ..< 1)
        var totalCombinedWeights: Double = 0

        for position in 0 ..< self.count {
            totalCombinedWeights += self.elements[position].value

            if totalCombinedWeights > randomFloatThreshold {
                return self.elements[position].key
            }
        }

        return self.elements[self.count - 1].key
    }
}
