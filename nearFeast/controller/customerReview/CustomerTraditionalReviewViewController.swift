//
//  CustomerTraditionalReviewViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 10/01/2024.
//

import UIKit
import Cosmos
class CustomerTraditionalReviewViewController: UIViewController {

    @IBOutlet weak var lblResName:UILabel!
    @IBOutlet weak var lblProdName:UILabel!
    @IBOutlet weak var vRating:CosmosView!
    @IBOutlet weak var tvReview:UITextView_Additions!
    @IBOutlet weak var ivResImage:UIImageView!
    
    var prodData:TraditionDishModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblResName.text = self.prodData.name
        self.lblProdName.text = "Review to \(self.prodData.name ?? "")"
        if let image = prodData.image{
            self.ivResImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            self.ivResImage.image =  #imageLiteral(resourceName: "01 – 1")
        }
    }
    @IBAction func submitreviewBtnPressed(_ sender:Any){
        var review = ""
        if self.tvReview.text != "Write something" || !self.tvReview.text!.isEmpty{
            review = self.tvReview.text!
        }
        let uuid = UUID().uuidString
        let reviews = ReviewModel()
        reviews.userId = FirebaseData.getCurrentUserId().0
        reviews.date = Date().milisecondInt64
        reviews.review = review
        reviews.rating = self.vRating.rating
        reviews.dis_id = self.prodData.docId
        PopupHelper.showAnimating(self)
        FirebaseData.saveTraditionalDishReviewData(uid: uuid, prodId: self.prodData.docId, userData: reviews) { error in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let prod = TraditionDishModel()
            var ratarry = [Double]()
            if let rating = self.prodData.rating{
                ratarry = rating
            }
            ratarry.append(self.vRating.rating)
            prod.rating = ratarry
            var noti = [String:Bool]()
            if let notify = self.prodData.notify{
                noti = notify
            }
            noti[FirebaseData.getCurrentUserId().0] = true
            prod.notify = noti
            FirebaseData.updateTraditionalDishData(self.prodData.docId, dic: prod) { error in
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
extension CustomerTraditionalReviewViewController:UITextViewDelegate{
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
