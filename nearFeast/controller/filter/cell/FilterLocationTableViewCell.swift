//
//  FilterLocationTableViewCell.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit

class FilterLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var milesButton: UIButton!
    @IBOutlet weak var kilometerButton: UIButton!
    @IBOutlet weak var locationTextField: UITexfield_Additions!
    @IBOutlet weak var tfLocation: UITexfield_Additions!
    override func awakeFromNib() {
        super.awakeFromNib()
//        kilometerButton.layer.cornerRadius = 8.0
//        kilometerButton.drawTwoCorner(roundTo: .left)
//        milesButton.layer.cornerRadius = 8.0
//        milesButton.drawTwoCorner(roundTo: .right)
    }
    
    
}
