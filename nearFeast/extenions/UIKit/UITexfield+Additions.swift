//
//  UITexfield+Additions.swift
//  TradeAir
//
//  Created by Adeel on 07/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown

extension UILabel {
    
    func abbreviatedCount(from number: Int) {
//               let abbreviations = ["", "k", "m", "b", "t"]
//                var num = Double(number)
//               var index = 0
//
//               while num >= 1000 && index < abbreviations.count - 1 {
//                   num /= 1000
//                   index += 1
//               }
//
//               let roundedNum = String(format: "%.1f", num)
//                self.text = "\(roundedNum)\(abbreviations[index])"
//           }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if number < 1_000 {
            self.text = "\(number)"
        } else if number < 1_000_000 {
            let thousandsCount = Double(number) / 1_000
            let formattedCount = Int(thousandsCount)
            self.text = "\(formattedCount)K"
        } else {
            let millionsCount = Double(number) / 1_000_000
            let formattedCount = Int(millionsCount)
            self.text = "\(formattedCount)M"
        }
    }
}

class UITexfield_Additions_DropDown: DropDown {
    
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
class UITexfield_Additions: UITextField {
    
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension UITextField{
    
    func isValid() -> Bool {
        if self.text?.isEmpty == true {
            return false
        }
        return true
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    //    func addPadding(padding: CGFloat) {
    //
    //        self.leftViewMode = .always
    //        self.layer.masksToBounds = true
    //
    //            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
    //            // left
    //            self.leftView = equalPaddingView
    //            self.leftViewMode = .always
    //            // right
    //            self.rightView = equalPaddingView
    //            self.rightViewMode = .always
    //    }
    
    
    
}
extension UITextView {
    func isValid() -> Bool {
        if self.text?.isEmpty == true {
            return false
        }
        return true
    }
    
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
