//
//  FavouriteViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit
import CoreLocation
class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnDish: UIButton!
    @IBOutlet weak var btnRest: UIButton!
    
    var dishArray = [DishModel]()
    var filterDishArray = [DishModel]()
    var restArray = [RestaurantModel]()
    var filterRestArray = [RestaurantModel]()
    var userData:UserModel!
    var isSearch = false
    var locationManager = CLLocationManager()
    var curentPosition: CLLocationCoordinate2D!
    var curentLoc: CLLocation!
    var isDish = true
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.userData = userData
        }
        if self.isDish{
            FirebaseData.getFavDishWithRestList(FirebaseData.getCurrentUserId().0) { error, userData in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.dishArray = userData!
                self.collectionView.reloadData()
            }
        }
        else{
            FirebaseData.getFavRestWithDishList(FirebaseData.getCurrentUserId().0) { error, userData in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.restArray = userData!
                self.collectionView.reloadData()
            }
        }
        
    }
    func loadfilterData(selectedCity:String!,dishby:String? = nil,distance:Int = 1,selectedDietType:[DietTypeModel]! = [],selectedFoodType:[FoodTypeModel]! = [],selectedReview:[reviewbymodel]! = [],selectedStar:Int = 0){
        
        PopupHelper.showAnimating(self)
        FirebaseData.getFavDishWithRestList(FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            var ismile = true
            if let miles = UserDefaults.standard.value(forKey: Constant.distance) as? Bool{
                if miles{
                    
                    ismile = miles
                }
                else{
                    
                    ismile = miles
                    
                }
            }
            self.dishArray = userData!
            self.dishArray.removeAll { DishModel1 in
                if let rest = DishModel1.rest,let lat = rest.lat,let lng = rest.lng{
                    let loc = CLLocation(latitude: lat, longitude: lng)
                    let dist = loc.distance(from: self.curentLoc)
                    if ismile{
                        let mile = dist.metersToMiles()
                        if Int(mile) >= distance{
                            return true
                        }
                    }
                    else{
                        let kilo = dist.metersToKilometers()
                        if Int(kilo) >= distance{
                            return true
                        }
                    }
                }
                return false
            }
            self.dishArray.removeAll { DishModel1 in
//                if let type = selectedDietType{
//                    if let typp = type.first(where: {$0.docId != DishModel1.diettype}){
//                        return true
//                    }
//                    
//                }
//                if let type = selectedFoodType{
//                    if let typp = type.first(where: {$0.docId != DishModel1.foodtype}){
//                        return true
//                    }
//                }
                return false
            }
            self.dishArray.removeAll { DishModel1 in
                if let type = selectedCity{
                    return DishModel1.city.lowercased() != type.lowercased()
                }
                return false
            }
            if selectedStar > 0{
                self.dishArray.removeAll { DishModel1 in
                    if let rating = DishModel1.rating,rating.count > 0{
                        var count = 0.0
                        for rate in rating{
                            count += rate
                        }
                        var rate = Int(count)/rating.count
                        if rate != selectedStar{
                            return true
                        }
                        return false
                    }
                    else{
                        return true
                    }
                    
                }
            }
            if self.dishArray.count > 0{
                self.dishArray.sort { DishModel1, DishModel2 in
                    if let rest1 = DishModel1.rest,let association1 = rest1.association,let rest2 = DishModel2.rest,let association2 = rest2.association{
                        if association1{
                            return true
                        }
                        if association2{
                            return true
                        }
                    }
                    return false
                }
            }
            self.collectionView.reloadData()
            
        }
    }
    private func setupController() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    @IBAction func dishBtnPressed(_ sender:Any){
        self.isDish = true
        self.btnDish.setTitleColor(.white, for: .normal)
        self.btnDish.backgroundColor = .red
        self.btnRest.setTitleColor(.black, for: .normal)
        self.btnRest.backgroundColor = .white
        self.loadData()
    }
    @IBAction func resBtnPressed(_ sender:Any){
        self.isDish = false
        self.btnDish.setTitleColor(.black, for: .normal)
        self.btnDish.backgroundColor = .white
        self.btnRest.setTitleColor(.white, for: .normal)
        self.btnRest.backgroundColor = .red
        self.loadData()
    }
    @objc func favbtnpressed(_ sender:UIButton){
        if let user = self.userData,user.isBio{
            if let time = userData.sessionTime {
                let cdate = Date()
                let timeStamp2 = Int64(time)
                let dbDate = time.getInt64toTime()
                let minuteDiff = Calendar.current.dateComponents([.minute], from: dbDate, to: cdate)
                let mindiff = minuteDiff.minute ?? 0
                
                if mindiff >= Constant.app_login_time{
                    self.gotoLoginViewController()
                }
                else{
                    self.favdata(sender)
                }
            }
        }
        else{
            self.gotoLoginViewController()
        }
        
    }
    func favdata(_ sender:UIButton){
        var favlist = [String:Bool]()
        if self.isDish{
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
                if self.isSearch{
                    self.filterDishArray.remove(at: sender.tag)
                }
                else{
                    self.dishArray.remove(at: sender.tag)
                }
                self.collectionView.reloadData()
            }
        }
        else{
            var rest:RestaurantModel!
            if self.isSearch{
                rest = self.filterRestArray[sender.tag]
            }
            else{
                rest = self.restArray[sender.tag]
            }
            
            if let isFav = rest.isFav{
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
            let restt = RestaurantModel()
            restt.isFav = favlist
            PopupHelper.showAnimating(self)
            FirebaseData.updateResData(rest.docId, dic: restt) { error in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                if self.isSearch{
                    self.filterRestArray.remove(at: sender.tag)
                }
                else{
                    self.restArray.remove(at: sender.tag)
                }
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        if self.isDish{
            let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .FilterViewController) as! FilterViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text,!text.isEmpty{
            self.isSearch = true
            if self.isDish{
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
        }
        else{
            self.isSearch = false
            self.filterDishArray.removeAll()
            self.filterRestArray.removeAll()
        }
        self.collectionView.reloadData()
    }
}
extension FavouriteViewController:UITextFieldDelegate{
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
extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearch{
            if self.isDish{
                return self.filterDishArray.count
            }
            else{
                return self.filterRestArray.count
            }
        }
        else{
            if self.isDish{
                return self.dishArray.count
            }
            else{
                return self.restArray.count
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
        if self.isSearch{
            if self.isDish{
                cell.lblName.text = self.filterDishArray[indexPath.row].name
                cell.lblDetail.text = self.filterDishArray[indexPath.row].city
                cell.lblPrice.text = "$\(self.filterDishArray[indexPath.row].price ?? "")"
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
                if let rest = self.filterDishArray[indexPath.row].rest,let plan = rest.plan{
                    switch SubscriptionPlan(rawValue: plan){
                    case .ProPlan:
                        cell.ivFeaturedImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
                }
                if let Special = self.filterDishArray[indexPath.row].Special{
                    if Special{
                        cell.ivSpecialImage.isHidden = false
                        
                    }
                    else{
                        cell.ivSpecialImage.isHidden = true
                    }
                    
                }
                else{
                    cell.ivSpecialImage.isHidden = true
                }
                if let Seasonal = self.filterDishArray[indexPath.row].Seasonal{
                    if Seasonal{
                        cell.ivSeasonalImage.isHidden = false
                        
                    }
                    else{
                        cell.ivSeasonalImage.isHidden = true
                    }
                    
                }
                else{
                    cell.ivSeasonalImage.isHidden = true
                }
                if let Limited = self.filterDishArray[indexPath.row].Limited{
                    if Limited{
                        cell.ivLimitedImage.isHidden = false
                        
                    }
                    else{
                        cell.ivLimitedImage.isHidden = true
                    }
                    
                }
                else{
                    cell.ivLimitedImage.isHidden = true
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
                cell.lblName.text = self.filterRestArray[indexPath.row].name
                cell.lblDetail.text = self.filterRestArray[indexPath.row].city
                cell.lblPrice.text = ""
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
                if let plan = self.filterRestArray[indexPath.row].plan{
                    switch SubscriptionPlan(rawValue: plan){
                    case .ProPlan:
                        cell.ivFeaturedImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
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
        }
        else{
            if self.isDish{
                cell.lblName.text = self.dishArray[indexPath.row].name
                cell.lblDetail.text = self.dishArray[indexPath.row].city
                cell.lblPrice.text = "$\(self.dishArray[indexPath.row].price ?? "")"
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
                if let rest = self.dishArray[indexPath.row].rest,let plan = rest.plan{
                    switch SubscriptionPlan(rawValue: plan){
                    case .ProPlan:
                        cell.ivFeaturedImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
                }
                if let Special = self.dishArray[indexPath.row].Special{
                    if Special{
                        cell.ivSpecialImage.isHidden = false
                        
                    }
                    else{
                        cell.ivSpecialImage.isHidden = true
                    }
                    
                }
                else{
                    cell.ivSpecialImage.isHidden = true
                }
                if let Seasonal = self.dishArray[indexPath.row].Seasonal{
                    if Seasonal{
                        cell.ivSeasonalImage.isHidden = false
                        
                    }
                    else{
                        cell.ivSeasonalImage.isHidden = true
                    }
                    
                }
                else{
                    cell.ivSeasonalImage.isHidden = true
                }
                if let Limited = self.dishArray[indexPath.row].Limited{
                    if Limited{
                        cell.ivLimitedImage.isHidden = false
                        
                    }
                    else{
                        cell.ivLimitedImage.isHidden = true
                    }
                    
                }
                else{
                    cell.ivLimitedImage.isHidden = true
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
            else{
                cell.lblName.text = self.restArray[indexPath.row].name
                cell.lblDetail.text = self.restArray[indexPath.row].city
                cell.lblPrice.text = ""
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
                if let plan = self.restArray[indexPath.row].plan{
                    switch SubscriptionPlan(rawValue: plan){
                    case .ProPlan:
                        cell.ivFeaturedImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
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
        }
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(self.favbtnpressed(_:)), for: .touchUpInside)
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.addShadowColor(shadowColor: UIColor.black, offSet: CGSize(width: 0.0, height: 1.0), opacity: 0.2, shadowRadius: 3.0, cornerRadius: 16, corners: UIRectCorner.allCorners, fillColor: UIColor.white)
        cell.animate(.slideFade(way: .in, direction: .right), duration: 2.0, damping: 0.6, velocity: 1.0, force: 1.0).completion {
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/2 - 40
        let height = width + 20
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isDish{
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
        else{
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
}

extension FavouriteViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
      self.curentLoc = location
    self.curentPosition = location.coordinate
    if self.curentPosition != nil{
        manager.stopUpdatingLocation()
       
    }
    
    self.curentPosition = location.coordinate
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
        PopupHelper.alertWithAppSetting(title: "Alert", message: "Please enable your location", controler: self)
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
