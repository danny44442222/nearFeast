//
//  subscribeViewViewController.swift
//  nearFeast
//
//  Created by Mac on 26/12/2023.
//
struct namedata{
    var name:SubscriptionPlan
    var details:String
    var detaisl2:String
    var detaisl3:String
    var detaisl4:String

    var mont:String
    var year:String
    
    var amountmont:Int
    var amuntyear:Int
    
    var daysmont:Int
    var daysyear:Int
    
    var planid:Int64
}
import UIKit
import FSPagerView

class subscribeViewViewController: UIViewController {
    
    @IBOutlet weak var btnsubs: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    
    @IBOutlet weak var topBarView: UIView!

    @IBOutlet weak var ivPagerView: FSPagerView!
    
    var restData:RestaurantModel!
    var array = [namedata]()
    var currentSusb : namedata!
    var isMonth = true
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.topBarView.drawTwoCorner(roundTo: .bottom)

        let nib = UINib(nibName: "UpgradePremium", bundle: nil)
        ivPagerView.register(nib, forCellWithReuseIdentifier: "UpgradePremium")
     
        ivPagerView.transformer = FSPagerViewTransformer(type: .overlap)
        let screenWidth = UIScreen.main.bounds.width
        ivPagerView.itemSize = CGSize(width: 300, height: 440)
        ivPagerView.interitemSpacing = 20

        ivPagerView.dataSource = self
        ivPagerView.delegate = self
        
        self.array.append(namedata(name: .BasicPlan, details: "Read-Only access: We automatically update data every 3 months from the public information", detaisl2: "Only page views",detaisl3: "Read-Only",detaisl4: "No", mont: "10$ Month", year: "100$ Year",amountmont: 10,amuntyear: 100,daysmont: 30,daysyear: 360, planid: 1 ))
        
        self.array.append(namedata(name: .PremiumPlan, details: "Enhanced restaurant listing (including photos, detailed descriptions, menus, and special offers).", detaisl2: "Access to analytics (e.g., page views, click-through rates).",detaisl3: "Read-Reply",detaisl4: "No", mont: "100$ Month", year: "500$ Year",amountmont: 100,amuntyear: 500,daysmont: 30,daysyear: 360, planid: 2))
        
        self.array.append(namedata(name: .ProPlan, details: "Enhanced restaurant listing (including photos, detailed descriptions, menus, and special offers).", detaisl2: "Access to premium analytics with detailed customer insights.",detaisl3: "Read-Reply",detaisl4: "Place restaurant on the app's homepage or in a highlighted section depending on the location of the user.", mont: "200$ Month", year: "1000$ Year",amountmont: 200,amuntyear: 1000,daysmont: 30,daysyear: 360, planid: 3))
        
        self.ivPagerView.reloadData()
        
        let dateaa = array[0]
        self.currentSusb = dateaa
        self.btnsubs.setTitle("Subscribe $\(self.currentSusb.amountmont)", for: .normal)
        
    }
    
    func paySucces(_ pi:String,cusid:String? = nil){
        let user = UserModel()
        user.isSubcribe = true
        if let cus = cusid{
            user.stripeCustid = cus
        }
        user.stripeclient_secret = pi
        
        let userid = FirebaseData.getCurrentUserId().0
        var edate = ""
        let restId = RestaurantModel()
        restId.association = true
        restId.userId = userid
        restId.plan = self.currentSusb.name.rawValue
        restId.planId = self.currentSusb.planid
        restId.isNotify = true
        if self.isMonth{
            edate = Date().add(days: self.currentSusb.daysmont).formattedWithString(Globals.__yyyy_MM_dd)
            restId.expire_at = edate
        }
        else{
            edate = Date().add(days: self.currentSusb.daysyear).formattedWithString(Globals.__yyyy_MM_dd)
            restId.expire_at = edate
        }
        
        FirebaseData.updateResData(self.restData.docId, dic: restId.dictionary) { error in
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: user) { error in
                let uid = UUID().uuidString
                let submo = SubcribModel()
                submo.startDate = Date().add(days: self.currentSusb.daysmont).formattedWithString(Globals.__yyyy_MM_dd)
                submo.endDate = edate
                submo.userId = userid
                submo.subName = self.currentSusb.name.rawValue
                submo.restId = self.restData.docId
                if self.isMonth{
                    submo.price = "\(self.currentSusb.amountmont)"
                    submo.subType = "month"
                }
                else{
                    submo.price = "\(self.currentSusb.amuntyear)"
                    submo.subType = "year"
                }
                FirebaseData.saveSubcribeUserData(uid: uid, userData: submo) { error in
                    
                    self.stopAnimating()
                    if let err = error{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: err.localizedDescription, forViewController: self)
                        return
                    }
                    let alert = UIAlertController(title: "Congrats", message: "Subscription activated succesful", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Copy", style: .default){ act in
                        
                        UIPasteboard.general.string = Constant.portalDetailUrl
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    let openAction = UIAlertAction(title: "Open portal", style: .default){ act in
                        self.linkBtnPressed()
                    }
                    alert.addAction(okAction)
                    alert.addAction(openAction)
                    self.present(alert, animated: true)
                    //PopupHelper.showAlertControllerWithSuccessBack(forErrorMessage: "Subscription activated succesful", forViewController: self)
                }
            }
        }
       
    }
    func linkBtnPressed(){
        if let url = URL(string: Constant.portalDetailUrl) {
            UIApplication.shared.open(url, options: [:])
         }
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnsubs(_ sender: Any) {
        if let dataaa = self.currentSusb{
            
            let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .AddCardViewController) as! AddCardViewController
            vc.delegate = self
            if self.isMonth{
                vc.ammount = Double(dataaa.amountmont)
                vc.type = "month"
            }
            else{
                vc.ammount = Double(dataaa.amuntyear)
                vc.type = "year"
            }
            
            self.present(vc, animated: true)
            
        }
        else{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Error occured", forViewController: self)
        }
    }
    @IBAction func monthBtn(_ sender: Any) {
        self.isMonth = true
        self.btnMonth.setTitleColor(.white, for: .normal)
        self.btnMonth.backgroundColor = UIColor().colorsFromAsset(name: .red1Color)
        self.btnYear.setTitleColor(.black, for: .normal)
        self.btnYear.backgroundColor = .white
        self.ivPagerView.reloadData()
        self.ivPagerView.scrollToItem(at: self.ivPagerView.currentIndex, animated: true)
    }
    @IBAction func yearBtn(_ sender: Any) {
        self.isMonth = false
        self.btnMonth.setTitleColor(.black, for: .normal)
        self.btnMonth.backgroundColor = .white
        self.btnYear.setTitleColor(.white, for: .normal)
        self.btnYear.backgroundColor = UIColor().colorsFromAsset(name: .red1Color)
        self.ivPagerView.reloadData()
        self.ivPagerView.scrollToItem(at: self.ivPagerView.currentIndex, animated: true)
    }
}
extension subscribeViewViewController: FSPagerViewDataSource,FSPagerViewDelegate{
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return array.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell{
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "UpgradePremium", at: index) as! UpgradePremium
        
        
        cell.titlelbl.text = self.array[index].name.rawValue
        cell.lbldetails.text = self.array[index].details
        cell.lbldetails2.text = self.array[index].detaisl2
        
        cell.lbldetail3.text = self.array[index].detaisl3
        cell.lbldetails4.text = self.array[index].detaisl4
        
        cell.lblmonthprice.text = self.array[index].mont
        cell.lblyearprice.text = self.array[index].year
        
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        let dateaa = array[pagerView.currentIndex]
        self.currentSusb = dateaa
        if self.isMonth{
            self.btnsubs.setTitle("Subscribe $\(self.currentSusb.amountmont)", for: .normal)
        }
        else{
            self.btnsubs.setTitle("Subscribe $\(self.currentSusb.amuntyear)", for: .normal)
        }
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let dateaa = array[pagerView.currentIndex]
        self.currentSusb = dateaa
        if self.isMonth{
            self.btnsubs.setTitle("Subscribe $\(self.currentSusb.amountmont)", for: .normal)
        }
        else{
            self.btnsubs.setTitle("Subscribe $\(self.currentSusb.amuntyear)", for: .normal)
        }
        
    }
    
    
    
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return 3
//    }
//
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//
//
//        let headerView = Bundle.main.loadNibNamed("UpgradePremium", owner: self)?.first as! UpgradePremium
//        headerView.frame = CGRect(x: 0, y: 0, width: 180, height: 250)
//
//        if index == 1{
//
//            headerView.lblMonth.textColor = .white
//            headerView.uiviewback.backgroundColor = UIColor().colorsFromAsset(name: .buttonColor)
//            headerView.lblmonth.textColor = .white
//            headerView.lblusd.textColor = .white
//            headerView.lblsave.textColor = .white
//            headerView.uiviewpercent.backgroundColor = UIColor().colorsFromAsset(name: .tabColor).withAlphaComponent(0.4)
//
//        }
//        else{
//
//            headerView.lblMonth.textColor = .label
//            headerView.uiviewback.backgroundColor = UIColor().colorsFromAsset(name: .bgColor2)
//            headerView.lblmonth.textColor = .label
//            headerView.lblusd.textColor = .label
//            headerView.lblsave.textColor = .label
//            headerView.uiviewpercent.backgroundColor = UIColor().colorsFromAsset(name: .bgColor2).withAlphaComponent(0.4)
//        }
//
//        return headerView
//    }
    
    
}
extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}
