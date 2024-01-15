//
//  FavouriteCollectionViewCell.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import Cosmos
import IBAnimatable
class FavouriteCollectionViewCell: AnimatableCollectionViewCell {
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRateCount: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var vRating: CosmosView!
    @IBOutlet weak var ivFeaturedImage: UIImageView!
    @IBOutlet weak var ivSpecialImage: UIImageView!
    @IBOutlet weak var ivSeasonalImage: UIImageView!
    @IBOutlet weak var ivLimitedImage: UIImageView!
    @IBOutlet weak var ivHotImage: UIImageView!
    @IBOutlet weak var ivNewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
