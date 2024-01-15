//
//  CustomerReviewViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import Cosmos
class CustomerReviewViewController: UIViewController {

    @IBOutlet weak var lblResName:UILabel!
    @IBOutlet weak var lblProdName:UILabel!
    @IBOutlet weak var vRating:CosmosView!
    @IBOutlet weak var tvReview:UITextView_Additions!
    @IBOutlet weak var ivResImage:UIImageView!
    var resData:RestaurantModel!
    var prodData:DishModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblResName.text = self.resData.name
        self.lblProdName.text = "Review to \(self.prodData.name ?? "")"
        if let image = resData.image{
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
        var reviews = ReviewModel()
        reviews.userId = FirebaseData.getCurrentUserId().0
        reviews.date = Date().milisecondInt64
        reviews.review = review
        reviews.rating = self.vRating.rating
        reviews.res_id = self.resData.docId
        reviews.dis_id = self.prodData.docId
        PopupHelper.showAnimating(self)
        FirebaseData.saveProdReviewData(uid: uuid, prodId: self.prodData.docId, userData: reviews) { error in
            
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
            ratarry.append(self.vRating.rating)
            prod.rating = ratarry
            var noti = [String:Bool]()
            if let notify = self.prodData.notify{
                noti = notify
            }
            noti[FirebaseData.getCurrentUserId().0] = true
            prod.notify = noti
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
    @IBAction func reviewBtnPressed(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .CustomerDetailReviewViewController) as! CustomerDetailReviewViewController
        vc.prodData = self.prodData
        vc.resData = self.resData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension CustomerReviewViewController:UITextViewDelegate{
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
