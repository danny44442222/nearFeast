//
//  BoolExtension.swift
//  Shopp
//
//  Created by Umair Afzal on 30/01/2022.
//

import Foundation

extension Bool {
    
    func asData() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    var intValue: Int {
        return self ? 1 : 0
    }
}
