//
//  ReviewHeaderView.swift
//  nearFeast
//
//  Created by Buzzware Tech on 26/12/2023.
//

import UIKit
import Cosmos
class ReviewHeaderView: UIView {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblReview:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var vRating:CosmosView!
    @IBOutlet weak var ivUserImage:UIImageView!
    @IBOutlet weak var btnReply:UIButton!
    @IBOutlet weak var btnEdit:UIButton!
    @IBOutlet weak var btnDelete:UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblReview:UILabel!
    @IBOutlet weak var ivUserImage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
