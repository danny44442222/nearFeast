//
//  NSObject.swift
//  Shopp
//
//  Created by Umair Afzal on 10/12/2021.
//

import Foundation

extension NSObject {
    static func className() -> String {
        return String(describing: self)
    }
}
