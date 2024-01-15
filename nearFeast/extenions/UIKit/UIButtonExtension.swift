//
//  UIButtonExtension.swift
//  ConceptApp
//
//  Created by Mac on 12/06/2023.
//

import UIKit
import CoreMotion

extension UIButton {
 
    func setupButton() {
        self.layer.cornerRadius = 10.0
        self.dropShadow(color: UIColor.white, alpha: 0.08)
    }
    
    func setupButtonImage(text: String, image: String) {
         let imageName = image
         // Replace with your image name
            let buttonText = text
         let attributedText = NSMutableAttributedString(string: buttonText)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.getFont(type: .montserratMedium, fontSize: 14.0),
                .foregroundColor: UIColor.black
            ]
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: buttonText.count))
            
            // Create an attachment for the image
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: imageName)
         let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
            
            // Create an attributed string for the image with text
            let imageString = NSAttributedString(attachment: imageAttachment)
            let finalString = NSMutableAttributedString()
            finalString.append(imageString)
         finalString.append(NSAttributedString(string: " "))
            finalString.append(attributedText)
            
            // Set the attributed string as the button's title
            setAttributedTitle(finalString, for: .normal)
            
            // Adjust the content alignment and insets
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
           // imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 8)
        // Adjust the image inset as needed
//            titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // Adjust the title inset as needed
        }
    
    func setLeftImage(image: String) {
//        self.setImage(UIImage(named: image), for: .normal)
//        self.imageView?.contentMode = .scaleAspectFit
//        self.contentHorizontalAlignment = .left
//
//        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let image = UIImage(named: image)
        let title = "Button Title"

        // Create an attributed string with the image and text
        let attributedString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: " " + title)) // Add some space before the title

        // Set the attributed string as the button's title
        self.setAttributedTitle(attributedString, for: .normal)
               self.contentHorizontalAlignment = .left

        // Optionally, adjust the content edge insets to add spacing
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
}



class SwitchButton: UIButton {

    var status: Bool = false {
        didSet {
            self.update()
        }
    }
    var onImage = UIImage(named: "on-image")
    var offImage = UIImage(named: "off-image")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStatus(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        UIView.transition(with: self, duration: 0.10, options: .transitionCrossDissolve, animations: {
            self.status ? self.setImage(self.onImage, for: .normal) : self.setImage(self.offImage, for: .normal)
        }, completion: nil)
    }
    func toggle() {
        self.status ? self.setStatus(false) : self.setStatus(true)
    }
    
    func setStatus(_ status: Bool) {
        self.status = status
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.sendHapticFeedback()
        self.toggle()
    }
    
    func sendHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
}
