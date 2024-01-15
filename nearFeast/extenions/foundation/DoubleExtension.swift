//
//  Double.swift
//  Shopp
//
//  Created by Umair Afzal on 10/12/2021.
//

import Foundation

extension Double {

    func toString() -> String {
        return String(format: "%.0f", self)
    }

    func toStringWith2Decimals() -> String {
        return (String(format: "%.2f", self))
    }
}
