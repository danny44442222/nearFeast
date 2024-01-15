//
//  FilterDropDownTableViewCell.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import iOSDropDown

class FilterDropDownTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var dropDownTextField: DropDown!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownTextField.delegate = self
        dropDownTextField.optionArray = ["Option 1", "Option 2", "Option 3"]
        dropDownTextField.arrowSize = 7.0
        dropDownTextField.arrowColor = .black
        dropDownTextField.textColor = UIColor.black
        dropDownTextField.didSelect{(selectedText , index ,id) in
        print( "Selected String: \(selectedText) \n index: \(index)")
        }

    }
}
