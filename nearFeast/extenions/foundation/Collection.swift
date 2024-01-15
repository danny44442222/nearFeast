//
//  Collection.swift
//  Shopp
//
//  Created by Umair Afzal on 05/02/2022.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func notEmpty() -> Bool {
        return !isEmpty
    }
}
