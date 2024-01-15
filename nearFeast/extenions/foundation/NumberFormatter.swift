//
//  NumberFormatter.swift
//  Shopp
//
//  Created by Umair Afzal on 07/03/2022.
//

import Foundation

extension NumberFormatter {

    static let largeNumber = formatter()

    private static func formatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
