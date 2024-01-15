//
//  RestaurantReviewTableViewCell.swift
//  nearFeast
//
//  Created by Buzzware Tech on 26/12/2023.
//

import UIKit
import Cosmos
class RestaurantReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var vRating:CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
