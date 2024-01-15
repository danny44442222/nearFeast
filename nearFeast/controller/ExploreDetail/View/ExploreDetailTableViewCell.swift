//
//  ExploreDetailTableViewCell.swift
//  nearFeast
//
//  Created by Buzzware Tech on 21/11/2023.
//

import UIKit
import Cosmos
class ExploreDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblResName:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var lblAddress:UIButton!
    @IBOutlet weak var lblPhone:UIButton!
    @IBOutlet weak var lblFoodType:UILabel!
    @IBOutlet weak var lblDietType:UILabel!
    @IBOutlet weak var lblWebsite:UIButton!
    @IBOutlet weak var lblResRating:UILabel!
    @IBOutlet weak var lblResRateCount:UILabel!
    @IBOutlet weak var lblProdRatig:UILabel!
    @IBOutlet weak var lblProdRateCount:UILabel!
    @IBOutlet weak var ivProductImage:UIImageView!
    @IBOutlet weak var ivRestImage:UIImageView!
    @IBOutlet weak var ivClaimImage:UIImageView!
    @IBOutlet weak var favouriteButton:UIButton!
    @IBOutlet weak var shareButton:UIButton!
    @IBOutlet weak var vProductRating:CosmosView!
    @IBOutlet weak var vRestRating:CosmosView!
    @IBOutlet weak var btnclaim: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ExploreDetail0TableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblDetail:UILabel!
    @IBOutlet weak var ivImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ExploreDetail1TableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var itemCollection:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ExploreDetail2TableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var btnAl:UIButton!
    @IBOutlet weak var itemCollection:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ExploreDetail3TableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPassword:UILabel!
    @IBOutlet weak var btnlink:UIButton!
    @IBOutlet weak var btncopy:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
