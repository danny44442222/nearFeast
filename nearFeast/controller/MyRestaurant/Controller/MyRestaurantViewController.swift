//
//  MyRestaurantViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 27/12/2023.
//

import UIKit

class MyRestaurantViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    var isSearch = false
    var restArray = [RestaurantModel]()
    var filterRestArray = [RestaurantModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // bottomTabBarView.applyGradient(colors: [.init(red: 210.0, green: 26.0, blue: 0.01, alpha: 1.0), .init(red: 182.0, green: 0.0, blue: 4.0, alpha: 1.0)], angle: 130.0)
        
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getRestByUserList(FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.restArray = userData!
            self.collectionView.reloadData()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text,!text.isEmpty{
            self.isSearch = true
            self.filterRestArray = self.restArray.filter({ remind in
                if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                    print("notes")
                    return true
                }
                if let details = remind.details,!details.isEmpty,details.lowercased().contains(text.lowercased()){
                    print("type")
                    return true
                }
                return false
                
            })
        }
        else{
            self.isSearch = false
            self.filterRestArray.removeAll()
        }
        self.collectionView.reloadData()
    }
    
}
extension MyRestaurantViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isSearch = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty{
            self.isSearch = false
        }
        else{
            self.isSearch = true
        }
        self.collectionView.reloadData()
    }
}
extension MyRestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearch{
            return self.filterRestArray.count
        }
        else{
            return self.restArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        if self.isSearch{
            cell.lblName.text = self.filterRestArray[indexPath.row].name
            cell.lblDetail.text = self.filterRestArray[indexPath.row].name
            if let image = self.filterRestArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let rating = self.filterRestArray[indexPath.row].rating,rating.count > 0{
                var count = 0.0
                for rate in rating{
                    count += rate
                }
                var rate = count/Double(rating.count)
                rate = rate.roundToPlaces(places: 1)
                cell.lblRating.text = "\(rate)"
                cell.lblRateCount.text = "(\(rating.count))"
                cell.vRating.rating = rate
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
                cell.vRating.rating = 1
            }
        }
        else{
            cell.lblName.text = self.restArray[indexPath.row].name
            cell.lblDetail.text = self.restArray[indexPath.row].name
            if let image = self.restArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let rating = self.restArray[indexPath.row].rating,rating.count > 0{
                var count = 0.0
                for rate in rating{
                    count += rate
                }
                var rate = count/Double(rating.count)
                rate = rate.roundToPlaces(places: 1)
                cell.lblRating.text = "\(rate)"
                cell.lblRateCount.text = "(\(rating.count))"
                cell.vRating.rating = rate
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
                cell.vRating.rating = 1
            }
        }
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.addShadowColor(shadowColor: UIColor.black, offSet: CGSize(width: 0.0, height: 1.0), opacity: 0.2, shadowRadius: 3.0, cornerRadius: 16, corners: UIRectCorner.allCorners, fillColor: UIColor.white)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/2 - 40
        let height = width + 20
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .RestaurantViewController) as! RestaurantViewController
        if self.isSearch{
            vc.restaurentData = self.filterRestArray[indexPath.row]
        }
        else{
            vc.restaurentData = self.restArray[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


