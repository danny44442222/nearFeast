//
//  AlertRestaurantViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 12/01/2024.
//

import UIKit
import Cosmos
class AlertRestaurantViewController: UIViewController {

    @IBOutlet weak var lblResName:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var lblResRating:UILabel!
    @IBOutlet weak var lblResRateCount:UILabel!
    @IBOutlet weak var ivRestImage:UIImageView!
    @IBOutlet weak var vRestRating:CosmosView!
    @IBOutlet weak var ivClaimImage:UIImageView!
    @IBOutlet weak var favouriteButton:UIButton!
    
    var dishArray = [CategorDish]()
    var restaurentData:RestaurantModel!
    var reviewArray = [ResReviewModel]()
    var userData:UserModel!
    var restId = ""
    var delegate = HomeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            UIView.animate(withDuration: 1.0, delay: 0.1,options: .curveEaseInOut) {
                self.view.backgroundColor = UIColor().colorsFromAsset(name: .black80Color)
            } completion: { value in
                
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.userData = userData
            FirebaseData.getRestaurentData(uid: self.restId) { error, userData in
                self.stopAnimating()
                if let error = error{
                    
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.restaurentData = userData!
                self.loadData1()
                
            }
        }
        
    }
    func loadData1(){
       
        self.lblResName.text = self.restaurentData.name
        
        if let image = self.restaurentData.image{
            self.ivRestImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        if let isFav = self.restaurentData.isFav{
            if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                self.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                
            }
            else{
                self.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
            }

        }
        if let association = self.restaurentData.association{
            if association{
                self.ivClaimImage.isHidden = false
            }
            else{
                self.ivClaimImage.isHidden = true
            }
        }
        else{
            self.ivClaimImage.isHidden = true
        }
        if let rating = self.restaurentData.rating,rating.count > 0{
            var count = 0.0
            for rate in rating{
                count += rate
            }
            var rate = count/Double(rating.count)
            rate = rate.roundToPlaces(places: 1)
            self.lblResRating.text = "\(rate)"
            self.lblResRateCount.text = "(\(rating.count))"
            self.vRestRating.rating = rate
        }
        else{
            self.lblResRating.text = "(0)"
            self.lblResRateCount.text = "0.0"
            self.vRestRating.rating = 0
        }
    }
    
    
    @IBAction func submitBtnPressed(_ sender:Any){
        self.dismiss(animated: true) {
            self.delegate.gotorest(rst: self.restaurentData)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
