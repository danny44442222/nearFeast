//
//  UIViewExtension.swift
//  Shopp
//
//  Created by Umair Afzal on 10/12/2021.
//

import UIKit

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func dropShadow(color: UIColor = .black, alpha: CGFloat = 0.2) {
        self.layer.shadowColor = color.withAlphaComponent(alpha).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 15
    }
    
    func addShadow(shadowColor: UIColor = .black,
                   offSet: CGSize = CGSize(width: 0, height: 5),
                   opacity: Float = 0.15,
                   shadowRadius: CGFloat = 12,
                   cornerRadius: CGFloat = 5.0,
                   corners: UIRectCorner = [.allCorners],
                   fillColor: UIColor = UIColor.black) {
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
    
    func pinchGestureRecognizer(recognizer: UIPinchGestureRecognizer) {
        guard let superView = self.superview else { return }
        let pinchScale: CGFloat = recognizer.scale
        let width = self.frame.width * pinchScale
        if width <= superView.frame.width - 40 {
            self.transform = self.transform.scaledBy(x: pinchScale, y: pinchScale)
        }
        recognizer.scale = 1.0
    }
}


