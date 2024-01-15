//
//  ProfileFavDishViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 09/01/2024.
//

import UIKit

class ProfileFavDishViewController: UIViewController {
    
    @IBOutlet weak var bottomTabBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var dishArray = [DishModel]()
    var filterDishArray = [DishModel]()
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
        FirebaseData.getFavProductList(FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.dishArray = userData!
            self.collectionView.reloadData()
        }
        
    }
    
    @objc func favbtnpressed(_ sender:UIButton){
        var favlist = [String:Bool]()
        var dish:DishModel!
        if self.isSearch{
            dish = self.filterDishArray[sender.tag]
        }
        else{
            dish = self.dishArray[sender.tag]
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
        let dishh = DishModel()
        dishh.isFav = favlist
        PopupHelper.showAnimating(self)
        FirebaseData.updateProdData(dish.docId, dic: dishh) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.dishArray.remove(at: sender.tag)
            self.collectionView.reloadData()
        }
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text,!text.isEmpty{
            self.isSearch = true
            self.filterDishArray = self.dishArray.filter({ remind in
                if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                    print("notes")
                    return true
                }
                if let country = remind.country,!country.isEmpty,country.lowercased().contains(text.lowercased()){
                    print("type")
                    return true
                }
                return false
                
            })
        }
        else{
            self.isSearch = false
            self.filterDishArray.removeAll()
        }
        self.collectionView.reloadData()
    }
}
extension ProfileFavDishViewController:UITextFieldDelegate{
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
extension ProfileFavDishViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearch{
            return self.filterDishArray.count
        }
        else{
            return self.dishArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
        if self.isSearch{
            cell.lblName.text = self.filterDishArray[indexPath.row].name
            cell.lblDetail.text = self.filterDishArray[indexPath.row].name
            if let image = self.filterDishArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.filterDishArray[indexPath.row].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
            }
            if let rating = self.filterDishArray[indexPath.row].rating,rating.count > 0{
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
            cell.lblName.text = self.dishArray[indexPath.row].name
            cell.lblDetail.text = self.dishArray[indexPath.row].name
            if let image = self.dishArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.dishArray[indexPath.row].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
            }
            
            if let rating = self.dishArray[indexPath.row].rating,rating.count > 0{
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
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ProductDetailViewController) as! ProductDetailViewController
        if self.isSearch{
            vc.dishData = self.filterDishArray[indexPath.row]
        }
        else{
            vc.dishData = self.dishArray[indexPath.row]
        }
        
        vc.isProduct = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

