//
//  passwordTextField.swift
//  smPhysique
//
//  Created by Mac on 04/10/2023.
//

import UIKit

class PasswordTextField: UITexfield_Additions {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.isSecureTextEntry = true
        //show/hide button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: ""), for: .normal)
        button.tintColor = UIColor.gray
        button.setImage(UIImage(named: ""), for: .selected)
        rightView = button
        rightViewMode = .always
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // Add padding to the righ
        

        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}
