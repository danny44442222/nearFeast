//
//  ProfileViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 20/11/2023.
//

import UIKit
import ExpyTableView

struct proSection{
    var image:UIImage!
    var section:ProfileMenuSection!
    var Array:[promodel]!
    var isExpand:Bool
}
struct promodel{
    var name:ProfileMenu!
}
class ProfileViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    @IBOutlet weak var lblName:UILabel!
    
    @IBOutlet weak var ivImage:UIImageView!
    
    
    var proArray = [proSection]()
    var user:UserModel!
    
    var isexapnd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.proArray = [
            proSection(image: UIImage(named: "Profile 1"), section: .MyProfile , Array: [promodel(name: .EditAcccount),promodel(name: .ChangePassword),promodel(name: .BiometricAuth)], isExpand: true),
            proSection(image: UIImage(named: "My Activity"), section: .MyActivity , Array: [promodel(name: .MyReviews),promodel(name: .FavoriteRestaurants),promodel(name: .FavoriteDishes),promodel(name: .RecentSearches)], isExpand: true),
            proSection(image: UIImage(named: "My Restaurants"), section: .MyRestaurants , Array: [promodel(name: .ListARestaurant),/*promodel(name: .ManageRestaurantListings),*/promodel(name: .ViewandRespondtoReviews)], isExpand: true),
            proSection(image: UIImage(named: "Settings"), section: .Settings , Array: [promodel(name: .NotificatonPreferences),promodel(name: .PrivacySettings),promodel(name: .AccountSettings),promodel(name: .DeleteAcccount)], isExpand: true),
            proSection(image: UIImage(named: "Support & Feedback"), section: .SupportFeedback , Array: [promodel(name: .HelpCenter),promodel(name: .ContactSupport),promodel(name: .SubmitFeedback),promodel(name: .FAQs)], isExpand: true),
            proSection(image: UIImage(named: "Legal"), section: .Legal , Array: [promodel(name: .TermsofService),promodel(name: .PrivacyPolicy)], isExpand: true)
        ]
        
        // Do any additional setup after loading the view.
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
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.user = userData
            self.lblName.text = self.user.userName
            if let image = self.user.image{
                self.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1") )
            }
            
        }
    }
    
    @IBAction func logout(_ sender:Any){
        PopupHelper.showAnimating(self)
        FirebaseData.logout()
    }
    @IBAction func notification(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .AllNotificationViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func deleteAccount(){
        let alert = UIAlertController(title: "Delete?", message: "Are you sure want to delete account", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Ok", style: .default, handler: { actn in
            PopupHelper.showAnimating(self)
            
            FirebaseData.deleteAccount(uid: FirebaseData.getCurrentUserId().0) { error in
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "We can't complete your request at the moment please try again later.", forViewController: self)
                    return
                }
                else{
                    FirebaseData.deleteUserData(uid: FirebaseData.getCurrentUserId().0) { error in
                        self.stopAnimating()
                        if let error = error{
                            
                            PopupHelper.showAlertControllerWithError(forErrorMessage: "We can't complete your request at the moment please try again later.", forViewController: self)
                            return
                        }
                        FirebaseData.logout()
                    }
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okaction)
        alert.addAction(cancel)
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

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.proArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.proArray[section].isExpand ? 0 : self.proArray[section].Array.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("CollapsibleTableViewHeader", owner: self, options: nil)?.first as! CollapsibleTableViewHeader
        header.lblName.text = self.proArray[section].section.rawValue
        header.ivImage.image = self.proArray[section].image
        header.setCollapsed(self.proArray[section].isExpand)

        header.section = section
        header.delegate = self

        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let header = Bundle.main.loadNibNamed("CollapsibleTableViewHeader", owner: self, options: nil)?.first as! CollapsibleTableViewHeader
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailsTableViewCell") as! profileDetailsTableViewCell
        
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        
        let arraydata = self.proArray[indexPath.section].Array[indexPath.row]
        cell.lblname.text = arraydata.name.rawValue
        cell.layoutMargins = UIEdgeInsets.zero
        cell.hideSeparator()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.user{
            if let time = user.sessionTime {
                let cdate = Date()
                let dbDate = time.getInt64toTime()
                let minuteDiff = Calendar.current.dateComponents([.minute], from: dbDate, to: cdate)
                let mindiff = minuteDiff.minute ?? 0
                
                if mindiff >= Constant.app_login_time{
                    if let name = self.proArray[indexPath.section].Array[indexPath.row].name{
                        switch name{
                        case.BiometricAuth:
                            if user.isBio{
                                self.gotoLoginViewController()
                                return
                            }
                        default:
                            self.gotoLoginViewController()
                            return
                        }
                    }
                }
                if let name = self.proArray[indexPath.section].Array[indexPath.row].name{
                    switch name{
                    case.FavoriteRestaurants:
                        
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .FavProifleRestViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .FavoriteDishes:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .ProfileFavDishViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .RecentSearches:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .RecentSearchViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .BiometricAuth:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .FingerPrintViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .ChangePassword:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .ChangePasswordViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .EditAcccount:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .EditProfileViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .MyReviews:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .MyReviewViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .ListARestaurant:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .MyRestaurantViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .ViewandRespondtoReviews:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .MyRespondViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .NotificatonPreferences:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .NotificationViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .PrivacySettings:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .PrivacySettingViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .AccountSettings:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .AccountSettingViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .DeleteAcccount:
                        self.deleteAccount()
                    case .PrivacyPolicy:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .PrivacyViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .TermsofService:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .TermsViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .ContactSupport:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .CustomerServiceViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .SubmitFeedback:
                        let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .FeedbackViewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    default:
                        break
                    }
                }
            }
        }
        else{
            self.gotoLoginViewController()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
extension ProfileViewController: CollapsibleTableViewHeaderDelegate {
  func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
    let collapsed = !self.proArray[section].isExpand
        
    // Toggle collapse
    self.proArray[section].isExpand = collapsed
    header.setCollapsed(collapsed)
    
    // Reload the whole section
    self.ivTableview.reloadSections([section], with: .automatic)
  }
}

//
//extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = Bundle.main.loadNibNamed("HeaderView", owner: self)?.first as! HeaderView
//        cell.lblname.text = ""
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.proArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
//        let view = UIView()
//        view.backgroundColor = .clear
//        cell.selectedBackgroundView = view
//        cell.lblName.text = self.proArray[indexPath.row].name.rawValue
//        cell.ivImage.image = self.proArray[indexPath.row].image
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }



//case .MyRestaurants:
//let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .MyRestaurantViewController)
//self.navigationController?.pushViewController(vc, animated: true)
//case .MyCards:
//let vc = UIStoryboard.storyBoard(withName: .profile).loadViewController(withIdentifier: .MyRestaurantViewController)
//self.navigationController?.pushViewController(vc, animated: true)


//
//}
