//
//  FavProifleRestViewController.swift
//  nearFeast
//
//  Created by Mac on 03/01/2024.
//

import UIKit

class FavProifleRestViewController: UIViewController {
    
    @IBOutlet weak var bottomTabBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var restArray = [RestaurantModel]()
    var filterRestArray = [RestaurantModel]()
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getFavRestList(FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.restArray = userData!
            self.collectionView.reloadData()
        }
        
    }
    
    @objc func favbtnpressed(_ sender:UIButton){
        var favlist = [String:Bool]()
        var dish:RestaurantModel!
        if self.isSearch{
            dish = self.filterRestArray[sender.tag]
        }
        else{
            dish = self.restArray[sender.tag]
        }
        
        if let isFav = dish.isFav{
            favlist = isFav
            if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                favlist[FirebaseData.getCurrentUserId().0] = false
                
            }
            else{
                favlist[FirebaseData.getCurrentUserId().0] = true
            }
        }
        else{
            favlist[FirebaseData.getCurrentUserId().0] = true
        }
        let dishh = RestaurantModel()
        dishh.isFav = favlist
        PopupHelper.showAnimating(self)
        FirebaseData.updateResData(dish.docId, dic: dishh) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.restArray.remove(at: sender.tag)
            self.collectionView.reloadData()
        }
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text,!text.isEmpty{
            self.isSearch = true
            self.filterRestArray = self.restArray.filter({ remind in
                if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                    print("notes")
                    return true
                }
                if let address = remind.address,!address.isEmpty,address.lowercased().contains(text.lowercased()){
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
extension FavProifleRestViewController:UITextFieldDelegate{
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
extension FavProifleRestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearch{
            return self.filterRestArray.count
        }
        else{
            return self.restArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
        if self.isSearch{
            cell.lblName.text = self.filterRestArray[indexPath.row].name
            cell.lblDetail.text = self.filterRestArray[indexPath.row].name
            if let image = self.filterRestArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.filterRestArray[indexPath.row].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
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
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
            }
        }
        else{
            cell.lblName.text = self.restArray[indexPath.row].name
            cell.lblDetail.text = self.restArray[indexPath.row].name
            if let image = self.restArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.restArray[indexPath.row].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
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
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
            }
        }
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(self.favbtnpressed(_:)), for: .touchUpInside)
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

