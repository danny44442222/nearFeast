//
//  ExploreDetailCollectionViewCell.swift
//  nearFeast
//
//  Created by Buzzware Tech on 21/11/2023.
//

import UIKit
import Cosmos
class ExploreDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblDetail:UILabel!
    @IBOutlet weak var ivImage:UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRateCount: UILabel!
    @IBOutlet weak var vRating: CosmosView!
}
