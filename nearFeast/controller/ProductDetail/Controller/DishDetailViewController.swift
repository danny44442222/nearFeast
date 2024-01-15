//
//  DishDetailViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 11/01/2024.
//

import UIKit

class DishDetailViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    var reviewArray = [ReviewModel]()
    var dishData:DishModel!
    var dietData = [DietTypeModel]()
    var foodData = [FoodTypeModel]()
    var restaurentData = RestaurantModel()
    var userData:UserModel!
    var ingredArray:[String]! = []
    var isvist = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
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
                        let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .CustomerReviewViewController) as! CustomerReviewViewController
                        vc.prodData = self.dishData
                        vc.resData = self.restaurentData
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DishDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4{
            return self.reviewArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreeDetailTableViewCell", for: indexPath) as! ExploreDetailTableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            cell.lblName.text = self.dishData.name
            cell.lblDescription.text = self.dishData.descriptions
            
            cell.shareButton.addTarget(self, action: #selector(self.shareBtnPressed(_:)), for: .touchUpInside)
            
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
            
            cell.vProductRating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.rateScrolBtnPressed(_:))))
            
            return cell
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
extension DishDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
        case 1:
            return self.foodData.count
        case 2:
            return self.dietData.count
        case 3:
            return self.ingredArray.count
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
        default:
            return UICollectionViewCell()
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
        default:
            return .zero
        }
    }
    
    
}