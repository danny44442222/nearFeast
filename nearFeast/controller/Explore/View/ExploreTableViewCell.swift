//
//  ExploreTableViewCell.swift
//  nearFeast
//
//  Created by Buzzware Tech on 21/11/2023.
//

import UIKit
import IBAnimatable
class ExploreTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var ivImage:UIImageView!
    @IBOutlet weak var ivDiscoverImage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
