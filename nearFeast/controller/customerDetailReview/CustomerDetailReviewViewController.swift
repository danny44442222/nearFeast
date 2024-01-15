//
//  CustomerDetailReviewViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
struct ResReview{
    var name:ResReviewKeys!
    var review:[ResReviews]!
}
struct ResReviews{
    var name:ReviewGrade!
    var isSelectd:Bool! = false
}
class CustomerDetailReviewViewController: UIViewController {
    
    @IBOutlet weak var bottomTabBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var resData:RestaurantModel!
    var prodData:DishModel!
    var reviewArray:[ResReview]!
    var review = "Write something"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.reviewArray = [
            ResReview(name: .Service,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .FoodQuality,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .Ambience,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .Cleanliness,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .ValueforPrice,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .MenuVariety,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .SpeedofService,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .Location,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .SpecialAccommodations,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .BeverageSelection,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .KidFriendliness,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .NoiseLevel,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .WifiQuality,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
            ResReview(name: .ParkingEase,review: [
                ResReviews(name: .Poor),
                ResReviews(name: .Fair),
                ResReviews(name: .Good,isSelectd: true),
                ResReviews(name: .Verygood),
                ResReviews(name: .Excellent)
            ]),
        ]
    }
    @IBAction func submitBtnPressed(_ sender:Any){
        PopupHelper.showAnimating(self)
        var revieww = ""
        if self.review != "Write something" || !self.review.isEmpty{
            revieww = self.review
        }
        let uuid = UUID().uuidString
        var val = [String:Any]()
        var arr = [Double]()
        for rev in self.reviewArray{
            if let index = rev.review.firstIndex(where: { ResReviews in
                return ResReviews.isSelectd
            }){
                let indx = index + 1
                val[rev.name.rawValue] = indx
                arr.append(Double(indx))
            }
            
        }
        var count:Double = 0
        for aa in arr{
            count += aa
        }
        var rate = count/Double(arr.count)
        rate = rate.roundToPlaces(places: 1)
        val[ResReviewKeys.rating.rawValue] = rate
        val[ResReviewKeys.userId.rawValue] = FirebaseData.getCurrentUserId().0
        val[ResReviewKeys.res_id.rawValue] = self.resData.docId
        if let prod = self.prodData{
            val[ResReviewKeys.dis_id.rawValue] = prod.docId
        }
        
        val[ResReviewKeys.date.rawValue] = Date().milisecondInt64
        val[ResReviewKeys.review.rawValue] = revieww
        FirebaseData.saveRedReviewData(uid: uuid, resId: self.resData.docId, userData: val) { error in
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let rest = RestaurantModel()
            var res = [Double]()
            if let rating = self.resData.rating{
                res = rating
            }
            res.append(rate)
            rest.rating = res
            var noti = [String:Bool]()
            if let notify = self.resData.notify{
                noti = notify
            }
            noti[FirebaseData.getCurrentUserId().0] = true
            rest.notify = noti
            FirebaseData.updateResData(self.resData.docId, dic: rest) { error in
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
extension CustomerDetailReviewViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something"{
            textView.text = ""
            textView.textColor = .black
            self.review = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Write something"
            textView.textColor = .lightGray
            self.review = "Write something"
        }
        else{
            self.review = textView.text
        }
    }
}
extension CustomerDetailReviewViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.reviewArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailReviewTableViewCell") as! CustomerDetailReviewTableViewCell
            cell.lblResName.text = self.resData.name
            if let prod = self.prodData,let name = prod.name{
                cell.lblDishName.text = "Review to \(name)"
            }
            else {
                cell.lblDishName.text = "Review to all dishes"
            }
            
            if let image = resData.image{
                cell.ivResImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            else{
                cell.ivResImage.image =  #imageLiteral(resourceName: "01 – 1")
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewMarksTableViewCell") as! ReviewMarksTableViewCell
            cell.lblName.text = self.reviewArray[indexPath.row].name.rawValue
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.row
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewMarks1TableViewCell") as! ReviewMarks1TableViewCell
            cell.tvReview.delegate = self
            cell.tvReview.text = self.review
            return cell
        default:
            return UITableViewCell()
        }
    }
}
extension CustomerDetailReviewViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviewArray[collectionView.tag].review.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewMarksCollectionViewCell", for: indexPath) as! ReviewMarksCollectionViewCell
        cell.lblName.text = self.reviewArray[collectionView.tag].review[indexPath.row].name.rawValue
        if self.reviewArray[collectionView.tag].review[indexPath.row].isSelectd{
            cell.lblName.textColor = .white
            cell.backgroundColor = UIColor().colorsFromAsset(name: .red)
        }
        else{
            cell.lblName.textColor = .black
            cell.backgroundColor = .white
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for (i,_) in self.reviewArray[collectionView.tag].review.enumerated(){
            self.reviewArray[collectionView.tag].review[i].isSelectd = false
        }
        self.reviewArray[collectionView.tag].review[indexPath.row].isSelectd = true
        collectionView.reloadData()
    }
    
}
