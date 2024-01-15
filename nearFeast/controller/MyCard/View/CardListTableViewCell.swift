//
//  CardListTableViewCell.swift
//  iRide
//
//  Created by Buzzware Tech on 04/01/2022.
//

import UIKit

class CardListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCardNumber:UILabel!
    @IBOutlet weak var lblCardExpiry:UILabel!
    @IBOutlet weak var ivCardType:UIImageView!
    @IBOutlet weak var btnDelete:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
