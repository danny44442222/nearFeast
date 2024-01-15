//
//  ProductDetailViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 21/11/2023.
//

import UIKit
import CoreLocation
import GoogleMaps
class ProductDetailViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    var proArray = [DishModel]()
    var pro1Array = [YelpRestModel]()
    var reviewArray = [ReviewModel]()
    var dishData:DishModel!
    var dietData = [DietTypeModel]()
    var foodData = [FoodTypeModel]()
    var restaurentData = RestaurantModel()
    var userData:UserModel!
    var ingredArray:[String]! = []
    var isProduct = false
    var isvist = true
    var locationManager = CLLocationManager()
    var curentPosition: CLLocationCoordinate2D!
    var curentLoc: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
    }
    private func setupController() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    func loadData(){
        if let ingred = self.dishData.ingredients{
            ingredArray = ingred
        }
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.userData = userData
            FirebaseData.getRestaurentData(uid: self.dishData.res_id) { error, userData in
                
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.restaurentData = userData!
                if self.isvist{
                    self.isvist = false
                    self.saveDailyVisit()
                }
                
                FirebaseData.getDiettypeList { error, userData in
                    
                    if let error = error{
                        self.stopAnimating()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                        return
                    }
                    self.dietData = userData!
                    self.dietData.removeAll { FoodTypeModel1 in
                        if let food = self.dishData.diettype.first(where: { ids in
                            return ids == FoodTypeModel1.docId
                        }){
                            return false
                        }
                        else{
                            return true
                        }
                    }
                    FirebaseData.getFoodtypeList { error, userData in
                        self.stopAnimating()
                        if let error = error{
                            
                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                            return
                        }
                        self.foodData = userData!
                        self.foodData.removeAll { FoodTypeModel1 in
                            if let food = self.dishData.foodtype.first(where: { ids in
                                return ids == FoodTypeModel1.docId
                            }){
                                return false
                            }
                            else{
                                return true
                            }
                        }
                        self.ivTableview.reloadData()
                        self.loadData1()
                    }
                }
            }
        }
        
        
    }
    func loadData1(){
        PopupHelper.showAnimating(self)
        FirebaseData.getDishReviewList(self.dishData.docId) { error, userData in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.reviewArray = userData!
            self.reviewArray.sort { ReviewModel1, ReviewModel2 in
                return ReviewModel1.date > ReviewModel2.date
            }
            FirebaseData.getSimilerProductList(type:self.dishData.foodtype) { error, userData in
                self.stopAnimating()
                if let error = error{
                    
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.proArray = userData!
                self.ivTableview.reloadData()
            }
        }
    }
    func loadRestauentapi(_ address:String){
        var dataDic = [String:Any]()
        dataDic[Constant.term] = Constant.restaurant
        dataDic[Constant.location] = address
        self.callWebService(data:dataDic,action:.businesses_search,.get)
    }
    func saveDailyVisit(){
        let uuid = UUID().uuidString
        var visits = VisitModel()
        visits.userId = FirebaseData.getCurrentUserId().0
        visits.date = Date().milisecondInt64
        visits.visit = 1
        visits.res_id = self.restaurentData.docId
        visits.dis_id = self.dishData.docId
        FirebaseData.saveProdVisitData(uid: uuid, prodId: self.dishData.docId, userData: visits) { error in
            
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let prod = DishModel()
            var ratarry = [String:Int64]()
            if let visit = self.dishData.visit{
                ratarry = visit
            }
            if let myvist = ratarry[FirebaseData.getCurrentUserId().0]{
                ratarry[FirebaseData.getCurrentUserId().0] = myvist + 1
            }
            else{
                ratarry[FirebaseData.getCurrentUserId().0] = 1
            }
            prod.visit = ratarry
            FirebaseData.updateProdData(self.dishData.docId, dic: prod) { error in
                if let error = error{
                    
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
            }
            
        }
    }
    @IBAction func submitBtnPressed(_ sender:Any){
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
                        if let lat = restaurentData.lat,let lng = restaurentData.lng{
                            let restloc = CLLocation(latitude: lat, longitude: lng)
                            let myloc = self.curentLoc ?? CLLocation(latitude: 0.0, longitude: 0.0)
                            let dist = restloc.distance(from: myloc)
                            if dist < 20{
                                let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .CustomerReviewViewController) as! CustomerReviewViewController
                                vc.prodData = self.dishData
                                vc.resData = self.restaurentData
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: "You are not in Restaurant area", forViewController: self)
                            }
                        }
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
    @objc func restBtnPressed(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .RestaurantViewController) as! RestaurantViewController
        vc.restaurentData = self.restaurentData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func rateBtnPressed(_ sender:Any){
        
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .RestaurantReviewViewController) as! RestaurantReviewViewController
        vc.restaurentData = self.restaurentData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func rateScrolBtnPressed(_ sender:Any){
        self.ivTableview.scrollToRow(at: IndexPath(row: 0, section: 4), at: .top, animated: true)
        
    }
    @objc func replyBtnPressed(_ sender:UIButton){
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
                        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ReviewReplyViewController) as! ReviewReplyViewController
                        vc.reviewData = self.reviewArray[sender.tag]
                        vc.dishData = self.dishData
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
    @objc func shareBtnPressed(_ sender:UIButton){
        let vc = UIActivityViewController(activityItems: ["\(Constant.prodDetailUrl)\(self.dishData.docId)"], applicationActivities: [])
        vc.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            if completed{
                
            }
        }
//        vc.excludedActivityTypes = [.airDrop,.assignToContact,.copyToPasteboard,.mail,.markupAsPDF,.message,.openInIBooks,.print,.saveToCameraRoll]
        if UIDevice.current.userInterfaceIdiom == .pad {
            OperationQueue.main.addOperation({() -> Void in
                if let popoverController = vc.popoverPresentationController {
                  popoverController.sourceView = self.view
                    popoverController.sourceRect = sender.frame
                }
                self.present(vc, animated: true, completion: nil)
            })
        }
        else {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    @objc func gotosubs(_ sender:UIButton){
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
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .subscribeViewViewController) as! subscribeViewViewController
                        vc.restData = self.restaurentData
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
    @objc func editBtnPressed(_ sender:UIButton){
        let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .EditReviewViewController) as! EditReviewViewController
        vc.prodData = self.dishData
        vc.resData = self.restaurentData
        vc.reviewData = self.reviewArray[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func callOptionBtnPressed(_ sender:UIButton){
        let alert = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let copy = UIAlertAction(title: "Copy", style: .default) { aact in
            UIPasteboard.general.string = self.restaurentData.phoneNumber
        }
        let call = UIAlertAction(title: "Call", style: .default) { aact in
            if let url = URL(string: "tel://\(self.restaurentData.phoneNumber ?? "0")") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        alert.addAction(cancel)
        alert.addAction(copy)
        alert.addAction(call)
        self.present(alert, animated: true)
        
    }
    
    @objc func navBtnPressed(_ sender:UIButton){
        let alert = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let copy = UIAlertAction(title: "Copy", style: .default) { aact in
            UIPasteboard.general.string = self.restaurentData.address
        }
        let nav = UIAlertAction(title: "Navigate", style: .default) { aact in
            self.navigate()
        }
        alert.addAction(cancel)
        alert.addAction(copy)
        alert.addAction(nav)
        self.present(alert, animated: true)
        
        
        
        
    }
    func navigate(){
        let uid = UUID().uuidString
        let ordr = OrderModel()
        ordr.userId = FirebaseData.getCurrentUserId().0
        ordr.restId = self.restaurentData.docId
        ordr.date = Date().milisecondInt64
        PopupHelper.showAnimating(self)
        FirebaseData.saveOderData(uid: uid, userData: ordr) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            var latt:Double = 0.0
            var long:Double = 0.0
            if let lat = self.restaurentData.lat,let lng = self.restaurentData.lng{
                latt = lat
                long = lng
            }
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latt),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latt),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
    @objc func webOptionBtnPressed(_ sender:UIButton){
        let alert = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let copy = UIAlertAction(title: "Copy", style: .default) { aact in
            UIPasteboard.general.string = self.restaurentData.website
        }
        let call = UIAlertAction(title: "Open in Browser", style: .default) { aact in
            if let urlDestination = URL.init(string: self.restaurentData.website) {
                UIApplication.shared.open(urlDestination)
            }
        }
        alert.addAction(cancel)
        alert.addAction(copy)
        alert.addAction(call)
        self.present(alert, animated: true)
        
    }
    @objc func allOptionBtnPressed(_ sender:UIButton){
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .AllYelpViewController)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func callWebService(_ id:String? = nil,data: [String:Any]? = nil, action:webserviceUrl,_ httpMethod:httpMethod){
        
        WebServicesHelper.callWebService(Parameters: data,suburl: id, action: action, httpMethodName: httpMethod) { (indx,action,isNetwork, error, dataDict) in
            self.stopAnimating()
            print(dataDict)
            
            if isNetwork{
                if let err = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                }
                else{
                    if let dic = dataDict as? Dictionary<String,Any>{
                        switch action {
                        case .businesses_search:
                            if let businesses = dic["businesses"] as? NSArray{
                                self.pro1Array.removeAll()
                                for dada in businesses{
                                    let model = YelpRestModel(dic: dada as! NSDictionary)
                                    self.pro1Array.append(model!)
                                }
                                self.ivTableview.reloadSections([5], with: .automatic)
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        default:
                            break
                        }
                        
                    }
                    else{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: "something went wrong", forViewController: self)
                    }
                }
            }
            else{
                PopupHelper.alertWithNetwork(title: "Network Connection", message: "Please connect your internet connection", controler: self)
                
            }
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
extension ProductDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6{
            return self.reviewArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            if self.isProduct{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreeDetailTableViewCell", for: indexPath) as! ExploreDetailTableViewCell
                let view = UIView()
                view.backgroundColor = .clear
                cell.selectedBackgroundView = view
                cell.lblName.text = self.dishData.name
                cell.lblResName.text = self.restaurentData.name
                cell.lblDescription.text = self.dishData.descriptions
                cell.lblAddress.setTitle("  \(self.restaurentData.address ?? "")", for: .normal)
                cell.lblPhone.setTitle("  \(self.restaurentData.phoneNumber ?? "")", for: .normal)
                cell.lblWebsite.setTitle("  \(self.restaurentData.website ?? "")", for: .normal)
                cell.lblAddress.addTarget(self, action: #selector(self.navBtnPressed(_:)), for: .touchUpInside)
                cell.lblPhone.addTarget(self, action: #selector(self.callOptionBtnPressed(_:)), for: .touchUpInside)
                cell.lblWebsite.addTarget(self, action: #selector(self.webOptionBtnPressed(_:)), for: .touchUpInside)
//                if let foodData = self.foodData,let name = foodData.name{
//                    cell.lblFoodType.text = name
//                }
//                if let dietData = self.dietData,let name = dietData.name{
//                    cell.lblDietType.text = name
//                }
                if let association = self.restaurentData.association{
                    if association{
                        cell.btnclaim.isHidden = true
                    }
                    else{
                        cell.btnclaim.isHidden = false
                    }
                }
                else{
                    cell.btnclaim.isHidden = false
                }
                cell.shareButton.addTarget(self, action: #selector(self.shareBtnPressed(_:)), for: .touchUpInside)
                cell.btnclaim.addTarget(self, action: #selector(self.gotosubs(_:)), for: .touchUpInside)
                cell.ivRestImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.restBtnPressed(_:))))
                if let image = self.dishData.image{
                    cell.ivProductImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
                }
                if let image = self.restaurentData.image{
                    cell.ivRestImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
                }
                if let isFav = self.dishData.isFav{
                    if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                        cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                        
                    }
                    else{
                        cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    }

                }
                if let rating = self.dishData.rating,rating.count > 0{
                    var count = 0.0
                    for rate in rating{
                        count += rate
                    }
                    var rate = count/Double(rating.count)
                    rate = rate.roundToPlaces(places: 1)
                    cell.lblProdRatig.text = "\(rate)"
                    cell.lblProdRateCount.text = "(\(rating.count))"
                    cell.vProductRating.rating = rate
                }
                else{
                    cell.lblProdRatig.text = "(0)"
                    cell.lblProdRateCount.text = "0.0"
                    cell.vProductRating.rating = 0
                }
                if let rating = self.restaurentData.rating,rating.count > 0{
                    var count = 0.0
                    for rate in rating{
                        count += rate
                    }
                    var rate = count/Double(rating.count)
                    rate = rate.roundToPlaces(places: 1)
                    cell.lblResRating.text = "\(rate)"
                    cell.lblResRateCount.text = "(\(rating.count))"
                    cell.vRestRating.rating = rate
                }
                else{
                    cell.lblResRating.text = "(0)"
                    cell.lblResRateCount.text = "0.0"
                    cell.vRestRating.rating = 0
                }
                cell.vProductRating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.rateScrolBtnPressed(_:))))
                cell.vRestRating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.rateBtnPressed(_:))))
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetailTableViewCell", for: indexPath) as! ExploreDetailTableViewCell
                let view = UIView()
                view.backgroundColor = .clear
                cell.selectedBackgroundView = view
                cell.lblName.text = self.dishData.name
                if let image = self.dishData.image{
                    cell.ivProductImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
                }
                if let isFav = self.dishData.isFav{
                    if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                        cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                        
                    }
                    else{
                        cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    }

                }
                if let rating = self.dishData.rating,rating.count > 0{
                    var count = 0.0
                    for rate in rating{
                        count += rate
                    }
                    var rate = count/Double(rating.count)
                    rate = rate.roundToPlaces(places: 1)
                    cell.lblProdRatig.text = "\(rate)"
                    cell.lblProdRateCount.text = "(\(rating.count))"
                    cell.vProductRating.rating = rate
                }
                else{
                    cell.lblProdRatig.text = "(0)"
                    cell.lblProdRateCount.text = "0.0"
                    cell.vProductRating.rating = 0
                }
                return cell
            }
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTypeSearchTableViewCell", for: indexPath) as! FilterTypeSearchTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = "Food Type"
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
            //cell.collectionView.createDirectionCollection(8,.horizontal)
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTypeSearchTableViewCell", for: indexPath) as! FilterTypeSearchTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = "Diet Type"
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
            //cell.collectionView.createDirectionCollection(8,.horizontal)
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
            return cell
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTypeSearchTableViewCell", for: indexPath) as! FilterTypeSearchTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = "Ingredients"
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
            //cell.collectionView.createDirectionCollection(8,.horizontal)
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail1TableViewCell", for: indexPath) as! ExploreDetail1TableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = "Similar Dishes"
            cell.itemCollection.delegate = self
            cell.itemCollection.dataSource = self
            cell.itemCollection.tag = indexPath.section
            cell.itemCollection.createDirectionCollection(8,.horizontal)
            DispatchQueue.main.async {
                cell.itemCollection.reloadData()
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail2TableViewCell", for: indexPath) as! ExploreDetail2TableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.btnAl.addTarget(self, action: #selector(allOptionBtnPressed(_:)), for: .touchUpInside)
            cell.lblName.text = "Also Available At"
            cell.itemCollection.delegate = self
            cell.itemCollection.dataSource = self
            cell.itemCollection.tag = indexPath.section
            cell.itemCollection.createDirectionCollection(8,.vertical)
            DispatchQueue.main.async {
                cell.itemCollection.reloadData()
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell", for: indexPath) as! MyReviewTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            if let user = self.reviewArray[indexPath.row].user,let userName = user.userName{
                cell.lblName.text = userName
            }
            if let user = self.reviewArray[indexPath.row].user,let image = user.image{
                cell.ivUserImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            else{
                cell.ivUserImage.image = #imageLiteral(resourceName: "01 – 1")
            }
            if let review = self.reviewArray[indexPath.row].review{
                cell.lblReview.text = review
            }
            if let date = self.reviewArray[indexPath.row].date{
                cell.lblDate.text = date.getInt64toTime().formattedWith(Globals.__dd_MM_yyyy)
            }
            if let rating = self.reviewArray[indexPath.row].rating{
                
                cell.vRating.rating = rating
            }
            else{
                cell.vRating.rating = 0
            }
            if self.reviewArray[indexPath.row].userId == FirebaseData.getCurrentUserId().0{
                cell.btnEdit.isHidden = false
            }
            else{
                cell.btnEdit.isHidden = true
            }
            if let association = restaurentData.association,let userid = restaurentData.userId{
                if association && userid == FirebaseData.getCurrentUserId().0{
                    cell.btnReply.isHidden = false
                }
                else{
                    cell.btnReply.isHidden = true
                }
            }
            else{
                cell.btnReply.isHidden = true
            }
            cell.btnReply.tag = indexPath.row
            cell.btnReply.addTarget(self, action: #selector(self.replyBtnPressed(_:)), for: .touchUpInside)
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(self.editBtnPressed(_:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ProductDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
        case 1:
            return self.foodData.count
        case 2:
            return self.dietData.count
        case 3:
            return self.ingredArray.count
        case 4:
            return self.proArray.count
        case 5:
            return self.pro1Array.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag{
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeOfSearchCollectionViewCell", for: indexPath) as! TypeOfSearchCollectionViewCell
            
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
            cell.mainView.layer.cornerRadius = 10.0
            cell.dataLabel.text = self.foodData[indexPath.row].name
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeOfSearchCollectionViewCell", for: indexPath) as! TypeOfSearchCollectionViewCell
            
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
            cell.mainView.layer.cornerRadius = 10.0
            cell.dataLabel.text = self.dietData[indexPath.row].name
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeOfSearchCollectionViewCell", for: indexPath) as! TypeOfSearchCollectionViewCell
            
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.borderColor = UIColor(hex: "#EFEFEF").cgColor
            cell.mainView.layer.cornerRadius = 10.0
            cell.dataLabel.text = self.ingredArray[indexPath.row]
            
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            
            cell.lblName.text = self.proArray[indexPath.row].name
            cell.lblDetail.text = self.proArray[indexPath.row].city
            cell.lblPrice.text = "$\(self.proArray[indexPath.row].price ?? "")"
            if let image = self.proArray[indexPath.row].image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let isFav = self.proArray[indexPath.row].isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }
                
            }
            if let rest = self.proArray[indexPath.row].rest,let plan = rest.plan{
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
            if let rest = self.proArray[indexPath.row].rest,let association = rest.association{
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
            if let Special = self.proArray[indexPath.row].Special{
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
            if let Seasonal = self.proArray[indexPath.row].Seasonal{
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
            if let Limited = self.proArray[indexPath.row].Limited{
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
            if let rating = self.proArray[indexPath.row].rating,rating.count > 0{
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
            
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            cell.lblName.text = self.pro1Array[indexPath.row].name
            cell.lblDetail.text = self.pro1Array[indexPath.row].city
            cell.lblPrice.text = self.pro1Array[indexPath.row].price
            if let image = self.pro1Array[indexPath.row].image_url{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let rating = pro1Array[indexPath.row].rating{
                
                cell.lblRating.text = "\(rating)"
                cell.lblRateCount.text = "(\(pro1Array[indexPath.row].review_count ?? 0))"
                cell.vRating.rating = rating
            }
            else{
                cell.lblRateCount.text = "(0)"
                cell.lblRating.text = "0.0"
                cell.vRating.rating = 0
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag{
        case 4:
            let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .DishDetailViewController) as! DishDetailViewController
            vc.dishData = self.proArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            if let urlDestination = URL.init(string: self.pro1Array[indexPath.row].url) {
                UIApplication.shared.open(urlDestination)
            }
            
        default:
            break
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag{
        case 1:
            
            let numberOfItemsPerRows:CGFloat = 3
            let spacingBetweenCellsIphone:CGFloat = 8
            
            let totalSpacing = (2 * spacingBetweenCellsIphone) + ((numberOfItemsPerRows - 1) * spacingBetweenCellsIphone)
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRows
            let labl = UILabel()
            labl.text = self.foodData[indexPath.row].name
            return CGSize(width: labl.intrinsicContentSize.width , height: 40)
        case 2:
            let labl = UILabel()
            labl.text = self.dietData[indexPath.row].name
            return CGSize(width: labl.intrinsicContentSize.width , height: 40)
        case 3:
            let labl = UILabel()
            labl.text = self.ingredArray[indexPath.row]
            return CGSize(width: labl.intrinsicContentSize.width , height: 40)
        case 4:
            let numberOfItemsPerRows:CGFloat = 2.2
            let spacingBetweenCellsIphone:CGFloat = 8
            
            let totalSpacing = (2 * spacingBetweenCellsIphone) + ((numberOfItemsPerRows - 1) * spacingBetweenCellsIphone)
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRows
            return CGSize(width: width , height: width)
        case 5:
            let numberOfItemsPerRows:CGFloat = 2
            let spacingBetweenCellsIphone:CGFloat = 8
            
            let totalSpacing = (2 * spacingBetweenCellsIphone) + ((numberOfItemsPerRows - 1) * spacingBetweenCellsIphone)
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRows
            return CGSize(width: width , height: width)
        default:
            return .zero
        }
    }
    
    
}
extension ProductDetailViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
      self.curentLoc = location
    self.curentPosition = location.coordinate
    if self.curentPosition != nil{
        manager.stopUpdatingLocation()
    }
      let geocoder = GMSGeocoder()
      geocoder.reverseGeocodeCoordinate(location.coordinate){response , error in
          guard let address: GMSAddress = response?.firstResult()
              else
          {
              return
          }
          self.loadRestauentapi(address.locality ?? "New York")
      }
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
