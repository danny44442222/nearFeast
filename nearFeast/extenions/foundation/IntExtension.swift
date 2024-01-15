//
//  Int.swift
//  Shopp
//
//  Created by Umair Afzal on 10/12/2021.
//

import Foundation

extension Int {

    func toString() -> String {
        return (String(format: "%d", self))
    }
    
    var boolValue: Bool {
           return self != 0
    }
}
