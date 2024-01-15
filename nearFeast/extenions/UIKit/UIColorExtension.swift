//
//  UIColorExtension.swift
//  Shopp
//
//  Created by Umair Afzal on 10/12/2021.
//

import UIKit

extension UIColor {
    static let desert = UIColor.init(named: "desert") ?? UIColor.black
    static let primaryBackground = UIColor.init(named: "primaryBackground") ?? UIColor.black
    static let border = UIColor.init(named: "border") ?? UIColor.black
    static let red = UIColor.init(named: "red") ?? UIColor.black


    static let black = UIColor.init(named: "Black") ?? UIColor.black
    static let bluePurple = UIColor.init(named: "BluePurple") ?? UIColor.blue
    static let pink = UIColor.init(named: "Pink") ?? UIColor.black
    static let tfcolor = UIColor.init(named:"tfcolor") ?? UIColor.black
    static let borderColor = UIColor.init(named:"bordercolor") ?? UIColor.black

    /// convert hexadecimal to UIColor
    /// - Returns: UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        let cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
