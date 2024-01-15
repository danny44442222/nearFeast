//
//  UIView+Additions.swift
//  TradeAir
//
//  Created by Adeel on 17/09/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit
import ChameleonFramework
import DKChainableAnimationKit
class UIView_Additions: UIView {

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.frame, andColors: [UIColor().colorsFromAsset(name: .themeColor),UIColor().colorsFromAsset(name: .blueColor)])
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.frame, andColors: [UIColor().colorsFromAsset(name: .whiteColor),UIColor().colorsFromAsset(name: .blueColor)])
//    }
}

extension UIView {

//    @IBInspectable
//    var backgroundImage: UIImage {
//        get {
//            return UIImage(named: "dashbg")!
//        }
//        set {
//            backgroundColor = UIColor.init(patternImage: newValue)
//        }
//    }
        @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
            }
        }

        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }

        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.borderColor = color.cgColor
                } else {
                    layer.borderColor = nil
                }
            }
        }

        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }

        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }

        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }

        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    @IBInspectable
    var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}
extension UIView{
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    //
    func sunriseGradientBackground(_ direction: GradientDirection = .topBottom, startAlpha:CGFloat = 1, endAlpha:CGFloat = 1) {
        removeExistingGradientLayer()
        let gradient        = CAGradientLayer()
        gradient.name       = "gradient"
        gradient.masksToBounds  = true
        gradient.frame      = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width+500, height: frame.height))
        //        gradient.frame = self.frame
        
        
        //      135 Degree
        //        1st #007061 #009485 #00C4B0
        
        gradient.colors = [UIColor(hex: "#007061").cgColor,
                           UIColor(hex: "#009485").cgColor,
                           UIColor(hex: "#00C4B0").cgColor]
        
        gradient.locations  = [0,1,1]
        switch direction {
        case .topBottom: break
        case .leftRight: gradient.startPoint = CGPoint(x: 0, y: 0.5); gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .rightLeft: gradient.startPoint = CGPoint(x: 1, y: 0.5); gradient.endPoint = CGPoint(x: 0, y: 0.5)
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeExistingGradientLayer() {
        if layer.sublayers != nil {
            for l in layer.sublayers! {
                if l is CAGradientLayer && (l as! CAGradientLayer).name == "gradient" {
                    (l as! CAGradientLayer).removeFromSuperlayer()
                }
            }
        }
    }
    
    func setGradient(colors: [CGColor], angle: Float = 0) {
        let gradientLayerView: UIView = UIView(frame: CGRect(x:0, y: 0, width: bounds.width, height: bounds.height))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = colors
        
        let alpha: Float = angle / 360
        //        let startPointX = powf(
        //            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
        //            2
        //        )
        //        let startPointY = powf(
        //            sinf(2 * Float.pi * ((alpha + 0) / 2)),
        //            2
        //        )
        //        let endPointX = powf(
        //            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
        //            2
        //        )
        //        let endPointY = powf(
        //            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
        //            2
        //        )
        
        gradient.endPoint = CGPoint(x: CGFloat(0),y: CGFloat(0))
        gradient.startPoint = CGPoint(x: CGFloat(1), y: CGFloat(1))
        gradientLayerView.cornerRadius = 30.0
        gradientLayerView.layer.insertSublayer(gradient, at: 0)
        layer.insertSublayer(gradientLayerView.layer, at: 0)
    }
    
    func makeCircle() {
        layer.cornerRadius      = max(frame.size.height, frame.size.width) / 2
        layer.masksToBounds     = true
    }
    
    class func autoHeight(_ view: UIView, constraint: NSLayoutConstraint) {
        constraint.constant = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat(MAXFLOAT))).height
    }
    
    class func autoWidth(_ view: UIView, constraint: NSLayoutConstraint) {
        constraint.constant = view.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: view.frame.size.height)).width
    }
    
   //  OUTPUT 1
    func dropShadow(scale: Bool = true) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shadowRadius = 1

            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }

        // OUTPUT 2
        func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offSet
            self.layer.shadowRadius = radius
            //        var bounds = self.bounds
            //        bounds.size.width = bounds.size.width + 50
            //        self.bounds = bounds
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
//    func addDropShadow(color: UIColor = .black, alpha: CGFloat = 0.15) {
//           self.layer.shadowColor = color.withAlphaComponent(alpha).cgColor
//           self.layer.shadowOpacity = 1.0
//           self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 18.0
//       }
       
//       func addShadow(shadowColor: UIColor = .black,
//                      offSet: CGSize = CGSize(width: 0, height: 5),
//                      opacity: Float = 0.15,
//                      shadowRadius: CGFloat = 12,
//                      cornerRadius: CGFloat = 18.0,
//                      corners: UIRectCorner = [.allCorners],
//                      fillColor: UIColor = UIColor.white) {
//           self.layer.sublayers?.removeAll(where: {
//               $0.name == "newShadowLayer"
//           })
//           DispatchQueue.main.async { [weak self] in
//               guard let self = self else { return }
//               let shadowLayer = CAShapeLayer()
//               shadowLayer.name = "newShadowLayer"
//               let size = CGSize(width: cornerRadius, height: cornerRadius)
//               let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
//               shadowLayer.path = cgPath //2
//               shadowLayer.fillColor = fillColor.cgColor //3
//               shadowLayer.shadowColor = shadowColor.cgColor //4
//               shadowLayer.shadowOffset = offSet //5
//               shadowLayer.shadowOpacity = opacity
//               shadowLayer.shadowRadius = shadowRadius
//               shadowLayer.masksToBounds = false
//               self.layer.masksToBounds = false
//               self.layer.shouldRasterize = true
//               self.layer.rasterizationScale = UIScreen.main.scale
//               self.layer.insertSublayer(shadowLayer, at: 0)
//           }
//       }
    
}
extension UIView{
    enum roundingCorner {
        case top,bottom,left,right
    }
    func drawTwoCorner(roundTo: roundingCorner){
        switch roundTo {
        case .top:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case .bottom:
            return self.layer.maskedCorners =  [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .left:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        case .right:
            return self.layer.maskedCorners =  [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        
        }
    }
    enum roundingCorners {
        case topRight,topLeft,bottomLeft,bottomRight
    }
    func drawThreeCorner(roundTo: roundingCorners){
        switch roundTo {
        case .topRight:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .topLeft:
            return self.layer.maskedCorners =  [.layerMinXMaxYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .bottomLeft:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        case .bottomRight:
            return self.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        }
    }
    func drawOneCorner(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
            let mask = _round(corners: corners, radius: radius)
            addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
        }
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            return mask
        }
        
        func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
            let borderLayer = CAShapeLayer()
            borderLayer.path = mask.path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = borderWidth
            borderLayer.frame = bounds
            layer.addSublayer(borderLayer)
        }
   
}
extension UIImage{
//    func drawImagesAndText1(_ string: String,rotate:Float = 0) -> UIImage {
//        
//        let view = Bundle.main.loadNibNamed("SerachView", owner: self)?.first as! SerachView
//        view.lblName.text = string
//        view.ivImage.image = self
//        view.lblName.sizeToFit()
//        view.sizeToFit()
//        
//        view.setNeedsLayout()
//        view.setNeedsUpdateConstraints()
//        view.setNeedsDisplay()
//        
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
//        
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage!.rotate(radians: rotate)!
//    }
    func drawImagesAndText(_ string: String,rotate:Float = 0) -> UIImage {
        
        var textFontAttributes: [NSAttributedString.Key: Any]!
        var point:CGPoint!
        let style = NSMutableParagraphStyle()

        style.alignment = NSTextAlignment.center
        textFontAttributes = [
            .font: UIFont(name: Constant.montserratMFont, size: 13) ?? UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.white,
            .paragraphStyle: style
        ]
        
        point = CGPoint(x: 0, y: self.size.height/4)
        

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))

        let rect = CGRect(origin: point, size: self.size)
        string.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!.rotate(radians: rotate)!
    }
    func rotate(radians: Float) -> UIImage? {
            var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
            // Trim off the extremely small float value to prevent core graphics from rounding it up
            newSize.width = floor(newSize.width)
            newSize.height = floor(newSize.height)

            UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
            let context = UIGraphicsGetCurrentContext()!

            // Move origin to middle
            context.translateBy(x: newSize.width/2, y: newSize.height/2)
            // Rotate around middle
            context.rotate(by: CGFloat(radians))
            // Draw the image at its center
            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
}
extension UIView {
    func applyGradient(colors: [UIColor], angle: CGFloat) {
           // Create gradient layer
           let gradientLayer = CAGradientLayer()

           // Convert UIColors to CGColors
           let cgColors = colors.map { $0.cgColor }

           // Set the colors for the gradient
           gradientLayer.colors = cgColors

           // Set the angle of the gradient (in radians)
           let startPoint = pointForAngle(angle)
           let endPoint = pointForAngle(angle + 180.0) // 180 degrees away for linear gradient
           gradientLayer.startPoint = startPoint
           gradientLayer.endPoint = endPoint

           // Set the frame for the gradient layer
           gradientLayer.frame = bounds

           // Remove existing gradient layers before adding a new one
           layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }

           // Add the gradient layer to the view's layer
           layer.insertSublayer(gradientLayer, at: 0)
       }

       private func pointForAngle(_ angle: CGFloat) -> CGPoint {
           let radians = angle * .pi / 180.0
           return CGPoint(x: 0.5 + 0.5 * cos(radians), y: 0.5 - 0.5 * sin(radians))
       }
    
    func dropShadowColor(color: UIColor = .black, alpha: CGFloat = 0.2) {
        self.layer.shadowColor = color.withAlphaComponent(alpha).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
    }
    
    func addShadowColor(shadowColor: UIColor = .black,
                   offSet: CGSize = CGSize(width: 0, height: 5),
                   opacity: Float = 0.15,
                   shadowRadius: CGFloat = 12,
                   cornerRadius: CGFloat = 5.0,
                   corners: UIRectCorner = [.allCorners],
                        fillColor: UIColor = UIColor.white) {
        self.layer.sublayers?.removeAll(where: {
            $0.name == "newShadowLayer"
        })
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let shadowLayer = CAShapeLayer()
            shadowLayer.name = "newShadowLayer"
            let size = CGSize(width: cornerRadius, height: cornerRadius)
            let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
            shadowLayer.path = cgPath //2
            shadowLayer.fillColor = fillColor.cgColor //3
            shadowLayer.shadowColor = shadowColor.cgColor //4
            shadowLayer.shadowOffset = offSet //5
            shadowLayer.shadowOpacity = opacity
            shadowLayer.shadowRadius = shadowRadius
            shadowLayer.masksToBounds = false
            self.layer.masksToBounds = false
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

