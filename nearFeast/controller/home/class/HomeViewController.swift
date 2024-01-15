//
//  HomeViewController.swift
//  nearFeast
//
//  Created by Mac on 20/11/2023.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
class HomeViewController: UIViewController {
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var mapButtonView: UIStackView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dishesView: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnDish: UIButton!
    @IBOutlet weak var btnRest: UIButton!
    
    var isSearch = false
    var isMap = false
    var isDish = true
    var zoomLevel: Float = 10.0
    var cellDelay = 0.1
    var locationManager = CLLocationManager()
    var curentPosition: CLLocationCoordinate2D!
    var curentLoc: CLLocation!
    var clusterManager: GMUClusterManager!
    var mapPosition: CLLocationCoordinate2D!

    var dishArray = [DishModel]()
    var filterDishArray = [DishModel]()
    var restArray = [RestaurantModel]()
    var filterRestArray = [RestaurantModel]()
    var userData:UserModel!
    var foodType = [FoodTypeModel]()
    var dietType = [DietTypeModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // bottomTabBarView.applyGradient(colors: [.init(red: 210.0, green: 26.0, blue: 0.01, alpha: 1.0), .init(red: 182.0, green: 0.0, blue: 4.0, alpha: 1.0)], angle: 130.0)
        setupController()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlertMessage(_:)), name: .visit, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
    }
    func loadData(){
        self.loadtypes()
        if FirebaseData.getCurrentUserId().1{
            PopupHelper.showAnimating(self)
            FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
                if let error = error{
                    self.stopAnimating()
                    FirebaseData.logout()
                    return
                }
                self.userData = userData
                self.loadUserData()
                self.loadproduct()
            }
        }
        else{
            self.loadproduct()
        }
        
    }
    
    func loadproduct(){
        
        PopupHelper.showAnimating(self)
        if self.isDish{
            FirebaseData.getDishWithRestList { error, userData in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.dishArray = userData!
                self.dishArray.sort { DishModel1, DishModel2 in
                    if let rest1 = DishModel1.rest,let association1 = rest1.planId,let rest2 = DishModel2.rest,let association2 = rest2.planId{
                        return association1 > association2
                    }
                    return false
                }
                self.collectionView.reloadData()
            }
        }
        else{
            FirebaseData.getRestWithDishList { error, userData in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.restArray = userData!
                self.restArray.sort { DishModel1, DishModel2 in
                    if let association1 = DishModel1.planId,let association2 = DishModel2.planId{
                        return association1 > association2
                    }
                    return false
                }
                self.collectionView.reloadData()
            }
        }
    }
    func loadtypes(){
        FirebaseData.getFoodtypeList { error, userData in
            if let error = error{
                
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.foodType = userData!
            FirebaseData.getDiettypeList { error, userData1 in

                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.dietType = userData1!
                
            }
        }
    }
    func loadUserData(){
        if let image = self.userData.image{
            self.ivProfile.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            self.ivProfile.image = #imageLiteral(resourceName: "01 – 1")
        }
    }
//    func animateTableCells() {
//        collectionView.reloadData() // Reload the table view to prepare the cells for animation
//        
//        let visibleCells = collectionView.visibleCells
//        for (index, cell) in visibleCells.enumerated() {
//            // Calculate the animation delay for each cell
//            let delay = Double(index) * cellDelay
//
//            // Start the cell's position outside the view (off-screen to the left)
//            cell.transform = CGAffineTransform(translationX: -collectionView.bounds.size.width, y: 0)
//
//            // Animate the cell into its final position with a bounce effect
//            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//        }
//    }
    func loadfilterData(selectedCity:String!,dishby:String? = nil,distance:Int = 1,selectedDietType:[DietTypeModel]! = [],selectedFoodType:[FoodTypeModel]! = [],selectedReview:[reviewbymodel]! = [],selectedStar:Int = 0){
        
        PopupHelper.showAnimating(self)
        FirebaseData.getDishWithRestList { error, userData in
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
                    if let rest1 = DishModel1.rest,let association1 = rest1.planId,let rest2 = DishModel2.rest,let association2 = rest2.planId{
                        return association1 > association2
                    }
                    return false
                }
            }
//            self.dishArray.sort { DishModel1, DishModel2 in
//                if let rating1 = DishModel1.rating,rating1.count > 0,let rating2 = DishModel2.rating,rating2.count > 0{
//                    var count1 = 0.0
//                    for rate in rating1{
//                        count1 += rate
//                    }
//                    var rate1 = Int(count1)/rating1.count
//                    var count2 = 0.0
//                    for rate in rating2{
//                        count2 += rate
//                    }
//                    var rate2 = Int(count2)/rating2.count
//                    if isAsending{
//                        return rate1 < rate2
//                    }
//                    else{
//                        return rate1 > rate2
//                    }
//                }
//                else{
//                    return false
//                }
//            }
            self.collectionView.reloadData()
            
        }
    }
    
    private func setupController() {
        setupGoogleMap()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: 0.0,
                                              longitude: 0.0,
                                              zoom: zoomLevel)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,clusterIconGenerator: iconGenerator)
        
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,renderer: renderer)

            // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
      //  mapView.delegate = self
        showHideView(isTrue: false)
    }
    
    func setupGoogleMap() {
      do {
       if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
        self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
       } else {
        NSLog("Unable to find style.json")
       }
      } catch {
       NSLog("One or more of the map styles failed to load. \(error)")
      }
     }
    func loadRestbar(){
        self.mapView.clear()
        self.clusterManager.clearItems()
        if self.isSearch{
            let filetr = self.filterDishArray.filter({ DishModel1 in
                if let rest = DishModel1.rest,let lat = rest.lat,let lng = rest.lng{
                    let myloc = CLLocation(latitude: self.mapPosition.latitude, longitude: self.mapPosition.longitude)
                    let barloc = CLLocation(latitude: lat, longitude: lng)
                    let dist = myloc.distance(from: barloc).metersToKilometers()
                    
                    if dist < 30{
                        return true
                    }
                }
                return false
            })
            if filetr.count > 0{
                for (i,dd) in filetr.enumerated(){
                    if let rest = dd.rest{
                        let cord = CLLocationCoordinate2D(latitude: rest.lat ?? 0.0, longitude: rest.lng ?? 0.0)
                        let marker = GMSMarker(position: cord)
                        marker.title = dd.name
                        marker.icon = #imageLiteral(resourceName: "Group 16268")
                        marker.tracksInfoWindowChanges = true
                        //marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                        marker.appearAnimation = .pop
                        marker.accessibilityHint = "\(i)"
                        //marker.map = self.mapView
                        clusterManager.add(marker)
                        //marker.map = self.mapView
                    }
                }
            }
            
        }
        else{
            let filetr = self.dishArray.filter({ DishModel1 in
                if let rest = DishModel1.rest,let lat = rest.lat,let lng = rest.lng{
                    let myloc = CLLocation(latitude: self.mapPosition.latitude, longitude: self.mapPosition.longitude)
                    let barloc = CLLocation(latitude: lat, longitude: lng)
                    let dist = myloc.distance(from: barloc).metersToKilometers()
                    
                    if dist < 30{
                        return true
                    }
                }
                return false
            })
            if filetr.count > 0{
                for (i,dd) in self.dishArray.enumerated(){
                    if let rest = dd.rest{
                        let cord = CLLocationCoordinate2D(latitude: rest.lat ?? 0.0, longitude: rest.lng ?? 0.0)
                        let marker = GMSMarker(position: cord)
                        marker.title = dd.name
                        marker.icon = #imageLiteral(resourceName: "Group 16268")
                        marker.tracksInfoWindowChanges = true
                        //marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                        marker.accessibilityHint = "\(i)"
                        //marker.map = self.mapView
                        clusterManager.add(marker)
                        //marker.map = self.mapView
                    }
                }
            }
            else{
                if let rest = self.dishArray.first?.rest{
                    let cord = CLLocationCoordinate2D(latitude: rest.lat ?? 0.0, longitude: rest.lng ?? 0.0)
                    let marker = GMSMarker(position: cord)
                    marker.title = rest.name
                    marker.icon = #imageLiteral(resourceName: "Group 16268")
                    marker.tracksInfoWindowChanges = true
                    //marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                    marker.appearAnimation = .pop
                    marker.accessibilityHint = "\(2)"
                    //marker.map = self.mapView
                    clusterManager.add(marker)
                }
            }
        }
        clusterManager.cluster()
    }
    private func showHideView(isTrue: Bool) {
        dishesView.isHidden = isTrue
        mapView.isHidden = !isTrue
        mapButtonView.isHidden = !isTrue

    }
    
    @IBAction func didTapShowMapButton(_ sender: Any) {
        self.loadRestbar()
        self.isMap = true
        showHideView(isTrue: true)
    }
    
    @IBAction func didTapShowDishesButton(_ sender: UIButton) {
        self.isMap = false
        showHideView(isTrue: false)
    }
    
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        if self.isDish{
            let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .FilterViewController) as! FilterViewController
            vc.modalPresentationStyle = .overCurrentContext
            //vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    @IBAction func dishBtnPressed(_ sender:Any){
        self.isDish = true
        self.btnDish.setTitleColor(.white, for: .normal)
        self.btnDish.backgroundColor = .red
        self.btnRest.setTitleColor(.black, for: .normal)
        self.btnRest.backgroundColor = .white
        self.loadproduct()
    }
    @IBAction func resBtnPressed(_ sender:Any){
        self.isDish = false
        self.btnDish.setTitleColor(.black, for: .normal)
        self.btnDish.backgroundColor = .white
        self.btnRest.setTitleColor(.white, for: .normal)
        self.btnRest.backgroundColor = .red
        self.loadproduct()
    }
    @objc func favbtnpressed(_ sender:UIButton){
        if FirebaseData.getCurrentUserId().1{
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
                    self.filterDishArray[sender.tag].isFav = favlist
                }
                else{
                    self.dishArray[sender.tag].isFav = favlist
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
                    self.filterRestArray[sender.tag].isFav = favlist
                }
                else{
                    self.restArray[sender.tag].isFav = favlist
                }
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text,!text.isEmpty{
            self.isSearch = true
            if self.isMap{
                self.filterDishArray = self.dishArray.filter({ remind in
                    if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                        print(name)
                        return true
                    }
                    if let country = remind.country,!country.isEmpty,country.lowercased().contains(text.lowercased()){
                        print(country)
                        return true
                    }
                    if let foodtype = remind.foodtype,!foodtype.isEmpty{
                        if let food = self.foodType.first(where: {$0.name.lowercased().contains(text.lowercased())}){
                            print(food.name ?? "")
                            return true
                        }
                    }
                    if let diettype = remind.diettype,!diettype.isEmpty{
                        if let food = self.dietType.first(where: {$0.name.lowercased().contains(text.lowercased())}){
                            print(food.name ?? "")
                            return true
                        }
                    }
                    if let ingredients = remind.ingredients,!ingredients.isEmpty{
                        if let d = ingredients.first(where: {$0.lowercased().contains(text.lowercased())}){
                            print(d)
                            return true
                        }
                    }
                    if let rest = remind.rest,let name = rest.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                        print(name)
                        return true
                    }
                    return false
                    
                })
            }
            else{
                if self.isDish{
                    self.filterDishArray = self.dishArray.filter({ remind in
                        if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                            print(name)
                            return true
                        }
                        if let country = remind.country,!country.isEmpty,country.lowercased().contains(text.lowercased()){
                            print(country)
                            return true
                        }
                        if let foodtype = remind.foodtype,!foodtype.isEmpty{
                            if let food = self.foodType.first(where: {$0.name.lowercased().contains(text.lowercased())}){
                                print(food.name ?? "")
                                return true
                            }
                        }
                        if let diettype = remind.diettype,!diettype.isEmpty{
                            if let food = self.dietType.first(where: {$0.name.lowercased().contains(text.lowercased())}){
                                print(food.name ?? "")
                                return true
                            }
                        }
                        if let ingredients = remind.ingredients,!ingredients.isEmpty{
                            if let d = ingredients.first(where: {$0.lowercased().contains(text.lowercased())}){
                                print(d)
                                return true
                            }
                        }
                        if let rest = remind.rest,let name = rest.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                            print(name)
                            return true
                        }
                        return false
                        
                    })
                }
                else{
                    self.filterRestArray = self.restArray.filter({ remind in
                        if let name = remind.name,!name.isEmpty,name.lowercased().contains(text.lowercased()){
                            print(name)
                            return true
                        }
                        if let city = remind.city,!city.isEmpty,city.lowercased().contains(text.lowercased()){
                            print(city)
                            return true
                        }
                        if let dish = remind.dishes{
//                            if let food = self.foodType.first(where: {$0.name.lowercased().contains(text.lowercased())}){
//                                if let foodtype = dish.first(where: {$0.foodtype == food.docId}){
//                                    print(food.name ?? "")
//                                    return true
//                                }
//                            }
                        }
                        if let dish = remind.dishes{
//                            if let diet = self.dietType.first(where: {$0.name.lowercased().contains(text.lowercased())}){
//                                if let diettype = dish.first(where: {$0.diettype == diet.docId}){
//                                    print(diet.name ?? "")
//                                    return true
//                                }
//                            }
                        }
                        if let dish = remind.dishes{
                            if let dishe = dish.first(where: { DishModel in
                                if let ingredients = DishModel.ingredients,!ingredients.isEmpty{
                                    if let d = ingredients.first(where: {$0.lowercased().contains(text.lowercased())}){
                                        print(d)
                                        return true
                                    }
                                }
                                return false
                            }){
                                return true
                            }
                        }
                        
                        if let dish = remind.dishes{
                            if let dishname = dish.first(where: {$0.name.lowercased().contains(text.lowercased())}){
                                print(dishname.name ?? "")
                                return true
                            }
                        }
                        return false
                        
                    })
                }
            }
        }
        else{
            self.isSearch = false
            self.filterDishArray.removeAll()
            self.filterRestArray.removeAll()
        }
        if self.isMap{
            self.loadRestbar()
        }
        else{
            if self.isDish{
                if self.filterDishArray.count > 0{
                    self.filterDishArray.sort { DishModel1, DishModel2 in
                        if let rest1 = DishModel1.rest,let association1 = rest1.planId,let rest2 = DishModel2.rest,let association2 = rest2.planId{
                            return association1 > association2
//                            if association1 == "Pro Plan"{
//                                return true
//                            }
//                            if association2 == "Pro Plan"{
//                                return true
//                            }
                        }
                        return false
                    }
                }
            }
            else{
                if self.filterRestArray.count > 0{
                    self.filterRestArray.sort { restModel1, restModel2 in
                        if let association1 = restModel1.planId,let association2 = restModel2.planId{
                            return association1 > association2
//                            if association1 == "Pro Plan"{
//                                return true
//                            }
//                            if association2 == "Pro Plan"{
//                                return true
//                            }
                        }
                        return false
                    }
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    @objc func showAlertMessage(_ sender:NSNotification){
        if let data = sender.userInfo as? [String:Any]{
            let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .AlertRestaurantViewController) as! AlertRestaurantViewController
            vc.restId = data["resid"] as! String
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true)
           
        }
        
        
    }
    func gotorest(rst:RestaurantModel!){
        if FirebaseData.getCurrentUserId().1{
            if let user = self.userData,user.isBio{
                if let time = userData.sessionTime {
                    let cdate = Date()
                    let dbDate = time.getInt64toTime()
                    let minuteDiff = Calendar.current.dateComponents([.minute], from: dbDate, to: cdate)
                    let mindiff = minuteDiff.minute ?? 0
                    
                    if mindiff >= Constant.app_login_time{
                        self.gotoLoginViewController()
                    }
                    else{
                        let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .CustomerDetailReviewViewController) as! CustomerDetailReviewViewController
                        vc.prodData = rst.dishes?.first
                        vc.resData = rst
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            else{
                self.gotoLoginViewController()
            }
            
        }
        else{
            self.gotoLoginViewController()
        }
    }
}
extension HomeViewController:UITextFieldDelegate{
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
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.ivFeaturedImage.isHidden = true
        cell.ivSpecialImage.isHidden = true
        cell.ivSeasonalImage.isHidden = true
        cell.ivLimitedImage.isHidden = true
        cell.ivHotImage.isHidden = true
        cell.ivNewImage.isHidden = true
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
                        cell.ivPremiumImage.isHidden = true
                    case .PremiumPlan:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
                    cell.ivPremiumImage.isHidden = true
                }
                if let rest = self.filterDishArray[indexPath.row].rest,let association = rest.association{
                    if association{
                        cell.ivClaimImage.isHidden = false
                    }
                    else{
                        cell.ivClaimImage.isHidden = true
                    }
                }
                else{
                    cell.ivClaimImage.isHidden = true
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
                        cell.ivPremiumImage.isHidden = true
                    case .PremiumPlan:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
                    cell.ivPremiumImage.isHidden = true
                }
                if let association = self.filterRestArray[indexPath.row].association{
                    if association{
                        cell.ivClaimImage.isHidden = false
                    }
                    else{
                        cell.ivClaimImage.isHidden = true
                    }
                }
                else{
                    cell.ivClaimImage.isHidden = true
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
                        cell.ivPremiumImage.isHidden = true
                    case .PremiumPlan:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
                    cell.ivPremiumImage.isHidden = true
                }
                if let rest = self.dishArray[indexPath.row].rest,let association = rest.association{
                    if association{
                        cell.ivClaimImage.isHidden = false
                    }
                    else{
                        cell.ivClaimImage.isHidden = true
                    }
                }
                else{
                    cell.ivClaimImage.isHidden = true
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
                        cell.ivPremiumImage.isHidden = true
                    case .PremiumPlan:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = false
                    default:
                        cell.ivFeaturedImage.isHidden = true
                        cell.ivPremiumImage.isHidden = true
                    }
                }
                else{
                    cell.ivFeaturedImage.isHidden = true
                    cell.ivPremiumImage.isHidden = true
                }
                if let association = self.restArray[indexPath.row].association{
                    if association{
                        cell.ivClaimImage.isHidden = false
                    }
                    else{
                        cell.ivClaimImage.isHidden = true
                    }
                }
                else{
                    cell.ivClaimImage.isHidden = true
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
extension HomeViewController:GMSMapViewDelegate,GMUClusterManagerDelegate,GMUClusterRendererDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapPosition = position.target
        self.zoomLevel = position.zoom
        self.loadRestbar()
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let _ = marker.userData as? GMUCluster {
          //mapView.animate(toZoom: mapView.camera.zoom + 1)
          NSLog("Did tap cluster")
          return nil
        }
        let cell = Bundle.main.loadNibNamed("DishMapView", owner: self)?.first as! DishMapView
        cell.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let tag = Int(marker.accessibilityHint ?? "0") ?? 0
        if self.isSearch{
            cell.lblName.text = self.filterDishArray[tag].name
            if let rest = self.filterDishArray[tag].rest,let name = rest.name{
                cell.lblDetail.text = name
            }
            else{
                cell.lblDetail.text = self.filterDishArray[tag].city
            }
            
            if let image = self.filterDishArray[tag].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.filterDishArray[tag].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
            }
            if let rating = self.filterDishArray[tag].rating,rating.count > 0{
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
            cell.lblName.text = self.dishArray[tag].name
            if let rest = self.dishArray[tag].rest,let name = rest.name{
                cell.lblDetail.text = name
            }
            else{
                cell.lblDetail.text = self.dishArray[tag].city
            }
            if let image = self.dishArray[tag].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.dishArray[tag].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
            }
            
            if let rating = self.dishArray[tag].rating,rating.count > 0{
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
        cell.favouriteButton.tag = tag
        cell.favouriteButton.addTarget(self, action: #selector(self.favbtnpressed(_:)), for: .touchUpInside)
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.addShadowColor(shadowColor: UIColor.black, offSet: CGSize(width: 0.0, height: 1.0), opacity: 0.2, shadowRadius: 3.0, cornerRadius: 16, corners: UIRectCorner.allCorners, fillColor: UIColor.white)
        
        return cell
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        if let _ = marker.userData as? GMUCluster {
          //mapView.animate(toZoom: mapView.camera.zoom + 1)
          NSLog("Did tap cluster")
          return false
        }
        mapView.selectedMarker = marker
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ProductDetailViewController) as! ProductDetailViewController
        let tag = Int(marker.accessibilityHint ?? "0") ?? 0
        if self.isSearch{
            vc.dishData = self.filterDishArray[tag]
        }
        else{
            vc.dishData = self.dishArray[tag]
        }
        
        vc.isProduct = true
        self.navigationController?.pushViewController(vc, animated: true)
        mapView.selectedMarker = nil
    }
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let mark = marker.userData as? GMUCluster {
            //marker.icon = #imageLiteral(resourceName: "Icon awesome-map-marker-alt")
            let image = UIImage(named: "Icon awesome-map-marker-alt")!.drawImagesAndText1("\(mark.count)")
            print("hello:\(mark.count)")
            marker.iconView = UIImageView(image: image)
        return
      }
        if let mark = marker.userData as? GMUStaticCluster {
            //marker.icon = #imageLiteral(resourceName: "Icon awesome-map-marker-alt")
            
            //let image = UIImage(named: "Icon awesome-map-marker-alt")!.drawImagesAndText1("\(mark.count)")
            print("hello:\(mark.count)")
            //marker.iconView = UIImageView(image: image)
        return
      }
        
    }
}
extension HomeViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
      self.curentLoc = location
    self.curentPosition = location.coordinate
      self.mapPosition = location.coordinate
    if self.curentPosition != nil{
        manager.stopUpdatingLocation()
//        let loc = LocationModels()
//        loc.addressLat = self.curentPosition.latitude
//        loc.addressLng = self.curentPosition.longitude
//        self.locations.append(loc)
    }
      
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)
    mapView.animate(to: camera)
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
