//
//  FilterRangeSliderTableViewCell.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import RangeSeekSlider

class FilterRangeSliderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
