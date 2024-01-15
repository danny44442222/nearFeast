//
//  MyReviewTableViewCell.swift
//  nearFeast
//
//  Created by Buzzware Tech on 20/11/2023.
//

import UIKit
import Cosmos
class MyReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblReview:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var vRating:CosmosView!
    @IBOutlet weak var ivUserImage:UIImageView!
    @IBOutlet weak var btnReply:UIButton!
    @IBOutlet weak var btnEdit:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
