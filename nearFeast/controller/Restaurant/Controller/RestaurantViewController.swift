//
//  RestaurantViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 26/12/2023.
//

import UIKit
import CoreLocation
import GoogleMaps
class RestaurantViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    var dishArray = [CategorDish]()
    var restaurentData:RestaurantModel!
    var reviewArray = [ResReviewModel]()
    var userData:UserModel!
    var locationManager = CLLocationManager()
    var curentPosition: CLLocationCoordinate2D!
    var curentLoc: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveDailyVisit()
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
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.userData = userData
            FirebaseData.getProductbyRestandCategoryList(self.restaurentData.docId, category: self.restaurentData.category) { error, userData in
                
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.dishArray = userData!
                self.ivTableview.reloadData()
                self.loadData1()
                
            }
        }
        
    }
    func loadData1(){
        PopupHelper.showAnimating(self)
        FirebaseData.getRestReview1List(self.restaurentData.docId) { error, userData in
            self.stopAnimating()
            if let error = error{
                
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.reviewArray = userData!
            self.reviewArray.sort { ReviewModel1, ReviewModel2 in
                return ReviewModel1.date > ReviewModel2.date
            }
            self.ivTableview.reloadData()
        }
    }
    
    func saveDailyVisit(){
        let uuid = UUID().uuidString
        var visits = VisitModel()
        visits.userId = FirebaseData.getCurrentUserId().0
        visits.date = Date().milisecondInt64
        visits.visit = 1
        visits.res_id = self.restaurentData.docId
        FirebaseData.saveRestVisitData(uid: uuid, resId: self.restaurentData.docId, userData: visits) { error in
            
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let prod = RestaurantModel()
            var ratarry = [String:Int64]()
            if let visit = self.restaurentData.visit{
                ratarry = visit
            }
            if let myvist = ratarry[FirebaseData.getCurrentUserId().0]{
                ratarry[FirebaseData.getCurrentUserId().0] = myvist + 1
            }
            else{
                ratarry[FirebaseData.getCurrentUserId().0] = 1
            }
            prod.visit = ratarry
            FirebaseData.updateResData(self.restaurentData.docId, dic: prod) { error in
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
                                let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .CustomerDetailReviewViewController) as! CustomerDetailReviewViewController
                                vc.prodData = self.dishArray.first?.dishes.first
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
    @objc func rateBtnPressed(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .RestaurantReviewViewController) as! RestaurantReviewViewController
        vc.restaurentData = self.restaurentData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func linkBtnPressed(_ sender:Any){
        if let url = URL(string: "\(Constant.portalDetailUrl)\(FirebaseData.getCurrentUserId().0)") {
            UIApplication.shared.open(url, options: [:])
         }
    }
    @objc func copyBtnPressed(_ sender:UIButton){
        UIPasteboard.general.string = Constant.portalDetailUrl
        sender.setTitle("Copied", for: .normal)
        
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
                        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .ResReviewReplyViewController) as! ResReviewReplyViewController
                        vc.restData = self.restaurentData
                        vc.reviewData = self.reviewArray[sender.tag]
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
        let vc = UIActivityViewController(activityItems: ["\(Constant.restDetailUrl)\(self.restaurentData.docId)"], applicationActivities: [])
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
    @objc func favbtnpressed(_ sender:UIButton){
        if FirebaseData.getCurrentUserId().1{
            
            var favlist = [String:Bool]()
            var rest = self.restaurentData
            
            if let isFav = rest?.isFav{
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
            FirebaseData.updateResData(rest!.docId, dic: restt) { error in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.restaurentData.isFav = favlist
                self.ivTableview.reloadSections([0], with: .automatic)
            }
        }
        else{
            self.gotoLoginViewController()
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
        //vc.prodData = self.dishData
        vc.resData = self.restaurentData
        //vc.reviewData = self.reviewArray[sender.tag]
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RestaurantViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return  4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 2:
            return self.dishArray.count
        case 3:
            return self.reviewArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreeDetailTableViewCell", for: indexPath) as! ExploreDetailTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblResName.text = self.restaurentData.name
            cell.lblAddress.setTitle("  \(self.restaurentData.address ?? "")", for: .normal)
            cell.lblPhone.setTitle("  \(self.restaurentData.phoneNumber ?? "")", for: .normal)
            cell.lblWebsite.setTitle("  \(self.restaurentData.website ?? "")", for: .normal)
            cell.lblAddress.addTarget(self, action: #selector(self.navBtnPressed(_:)), for: .touchUpInside)
            cell.lblPhone.addTarget(self, action: #selector(self.callOptionBtnPressed(_:)), for: .touchUpInside)
            cell.lblWebsite.addTarget(self, action: #selector(self.webOptionBtnPressed(_:)), for: .touchUpInside)
            if let image = self.restaurentData.image{
                cell.ivProductImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            if let image = self.restaurentData.image{
                cell.ivRestImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            cell.shareButton.addTarget(self, action: #selector(self.shareBtnPressed(_:)), for: .touchUpInside)
            cell.favouriteButton.addTarget(self, action: #selector(self.favbtnpressed(_:)), for: .touchUpInside)
            if let isFav = self.restaurentData.isFav{
                if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                    
                }
                else{
                    cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
                }

            }
            if let association = self.restaurentData.association{
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
            cell.vRestRating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.rateBtnPressed(_:))))
            return cell
        case 1:
            if let assoic = self.restaurentData.association,let userid = self.restaurentData.userId{
                if assoic && userid == FirebaseData.getCurrentUserId().0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail3TableViewCell", for: indexPath) as! ExploreDetail3TableViewCell
                    let view = UIView()
                    view.backgroundColor = .clear
                    cell.selectedBackgroundView = view
                    cell.btnlink.addTarget(self, action: #selector(self.linkBtnPressed(_:)), for: .touchUpInside)
                    cell.btncopy.addTarget(self, action: #selector(self.copyBtnPressed(_:)), for: .touchUpInside)
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail33TableViewCell", for: indexPath) as! ExploreDetail3TableViewCell
                    return cell
                }
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail33TableViewCell", for: indexPath) as! ExploreDetail3TableViewCell
                return cell
            }
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreDetail2TableViewCell", for: indexPath) as! ExploreDetail2TableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = self.dishArray[indexPath.row].cateogry.name
            cell.itemCollection.delegate = self
            cell.itemCollection.dataSource = self
            cell.itemCollection.tag = indexPath.row
            cell.itemCollection.createDirectionCollection(8,.vertical)
            DispatchQueue.main.async {
                cell.itemCollection.reloadData()
            }
            return cell
        case 3:
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
            return UITableViewCell(frame: .zero)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension RestaurantViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dishArray[collectionView.tag].dishes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.lblName.text = self.dishArray[collectionView.tag].dishes[indexPath.row].name
        cell.lblDetail.text = self.dishArray[collectionView.tag].dishes[indexPath.row].city
        cell.lblPrice.text = "$\(self.dishArray[collectionView.tag].dishes[indexPath.row].price ?? "")"
        if let image = self.dishArray[collectionView.tag].dishes[indexPath.row].image{
            cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        if let isFav = self.dishArray[collectionView.tag].dishes[indexPath.row].isFav{
            if let fav = isFav[FirebaseData.getCurrentUserId().0],fav{
                cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart1"), for: .normal)
                
            }
            else{
                cell.favouriteButton.setImage(UIImage(named: "Icon ionic-ios-heart"), for: .normal)
            }
            
        }
        if let plan = self.restaurentData.plan{
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
        if let association = self.restaurentData.association{
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
        if let Special = self.dishArray[collectionView.tag].dishes[indexPath.row].Special{
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
        if let Seasonal = self.dishArray[collectionView.tag].dishes[indexPath.row].Seasonal{
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
        if let Limited = self.dishArray[collectionView.tag].dishes[indexPath.row].Limited{
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
        if let rating = self.dishArray[collectionView.tag].dishes[indexPath.row].rating,rating.count > 0{
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
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.storyBoard(withName: .explore).loadViewController(withIdentifier: .DishDetailViewController) as! DishDetailViewController
        vc.dishData = dishArray[collectionView.tag].dishes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRows:CGFloat = 2
        let spacingBetweenCellsIphone:CGFloat = 8
        
        let totalSpacing = (2 * spacingBetweenCellsIphone) + ((numberOfItemsPerRows - 1) * spacingBetweenCellsIphone)
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRows
        return CGSize(width: width , height: width)
    }
    
    
}
extension RestaurantViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
      self.curentLoc = location
    self.curentPosition = location.coordinate
    if self.curentPosition != nil{
        manager.stopUpdatingLocation()
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
