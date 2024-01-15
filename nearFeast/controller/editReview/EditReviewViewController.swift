//
//  EditReviewViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import Cosmos
class EditReviewViewController: UIViewController {

    @IBOutlet weak var lblResName:UILabel!
    @IBOutlet weak var lblProdName:UILabel!
    @IBOutlet weak var vRating:CosmosView!
    @IBOutlet weak var tvReview:UITextView_Additions!
    @IBOutlet weak var ivResImage:UIImageView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    var resData:RestaurantModel!
    var prodData:DishModel!
    var reviewData:ReviewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblResName.text = self.resData.name
        if let prod = self.prodData{
            self.lblProdName.text = "Review to \(prod.name ?? "")"
        }
        else{
            self.lblProdName.text = ""
        }
        
        if let image = resData.image{
            self.ivResImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            self.ivResImage.image =  #imageLiteral(resourceName: "01 – 1")
        }
        self.vRating.rating = self.reviewData.rating
        self.tvReview.text = self.reviewData.review
    }
    @IBAction func submitreviewBtnPressed(_ sender:Any){
        var review = ""
        if self.tvReview.text != "Write something" || !self.tvReview.text!.isEmpty{
            review = self.tvReview.text!
        }
        
        var reviews = ReviewModel()
        reviews.review = review
        reviews.rating = self.vRating.rating
        PopupHelper.showAnimating(self)
        FirebaseData.updateReviewData(self.prodData.docId, reviewid: self.reviewData.docId, dic: reviews) { error in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let prod = DishModel()
            var ratarry = [Double]()
            if let rating = self.prodData.rating{
                ratarry = rating
            }
            for (i,val) in ratarry.enumerated(){
                if val == self.reviewData.rating{
                    ratarry[i] = self.vRating.rating
                    break
                }
            }
            ratarry.append(self.vRating.rating)
            prod.rating = ratarry
            FirebaseData.updateProdData(self.prodData.docId, dic: prod) { error in
                self.stopAnimating()
                if let error = error{
                    
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.backToRootAction()
            }
            
        }
    }
    
}
extension EditReviewViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Write something"
            textView.textColor = .lightGray
        }
    }
}
