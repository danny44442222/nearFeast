//
//  MyCardViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 30/12/2023.
//


import UIKit
import Stripe
class MyCardViewController: UIViewController {

    @IBOutlet weak var ivTableView:UITableView!
    @IBOutlet weak var btnpayments: UIButton!
    @IBOutlet weak var lblYourPrice: UILabel!
    var cardArray = [CardModel]()
    var user:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ivTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func addCardBtnPressed(_ sender:Any){
        //PopupHelper.alertCardViewController(array:self.cardArray, controler: self)
        
    }
    
    
    
    func loadData(){
        self.callFirebase()
    }
    
    func callFirebase(){
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            
            if let err = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: err.localizedDescription, forViewController: self)
                return
            }
            guard let userData = userData else{return}
            self.user = userData
            if userData.stripeCustid == nil{
                PopupHelper.showAnimating(self)
                var data = [String:Any]()
                data[UserKeys.email.rawValue] = userData.email
                data[DishKeys.userId.rawValue] = FirebaseData.getCurrentUserId()
                self.callWebService(data: data, action: .checkcustidexistornot, .post)
            }
            else{
                self.btnpayments.setTitle("ADD PAYMENT METHOD", for: .normal)
                self.loadCardData()
                
            }
            
        }
    }
    func loadCardData(){
        PopupHelper.showAnimating(self)
        var data = [String:Any]()
        data[Constant.cus_id] = self.user.stripeCustid
        self.callWebService(data: data, action: .paymentMethods, .post)
    }
    
    func callWebService(_ id:String? = nil,data: [String:Any]? = nil, action:webserviceUrl,_ httpMethod:httpMethod,_ index:Int? = nil){
        
        WebServicesHelper.callWebService(Parameters: data,suburl: id, action: action, httpMethodName: httpMethod,index) { (indx,action,isNetwork, error, dataDict) in
            self.stopAnimating()
            if isNetwork{
                if let err = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                }
                else{
                    if let dic = dataDict as? Dictionary<String,Any>{
                        switch action {
                        case .paymentMethods:
                            if let cards = dic["paymentMethods"] as? NSArray{
                                self.cardArray.removeAll()
                                for card in cards{
                                    self.cardArray.append(CardModel(dictionary: card as AnyObject)!)
                                }
                                self.ivTableView.reloadData()
                                
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        case .checkcustidexistornot:
                            if let data = dic["cust_id"] as? String{
                                self.user.stripeCustid = data
                                let use = UserModel()
                                use.stripeCustid = data
                                FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: use) { error in
                                    
                                }
                                self.loadCardData()
                                
                            }
                        case .detatch:
                            self.cardArray.remove(at: indx ?? 0)
                            self.ivTableView.reloadData()
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
    @objc func deleteCard(_ sender:UIButton){
        PopupHelper.showAnimating(self)
        var data = [String:Any]()
        data["pm_id"] = self.cardArray[sender.tag].id
        self.callWebService(data: data, action: .detatch, .post,sender.tag)
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
extension MyCardViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTableViewCell", for: indexPath) as! CardListTableViewCell
        if let card = self.cardArray[indexPath.row].last4{
            cell.lblCardNumber.text = "**** **** **** \(card)"

        }
//        if let exp_year = self.cardArray[indexPath.row].exp_year,let exp_month = self.cardArray[indexPath.row].exp_month{
//            cell.lblCardExpiry.text = "\(exp_month)/\(exp_year)"
//        }
        if let card = self.cardArray[indexPath.row].brand{
            cell.ivCardType.image = UIImage(named: "stp_card_\(card)")

        }
        //cell.btnDelete.addTarget(self, action: #selector(self.deleteCard(_:)), for: .touchUpInside)
        //cell.btnDelete.tag = indexPath.row
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PopupHelper.alertUpdateCardViewController(controler: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            let btn = UIButton()
            btn.tag = indexPath.row
            self.deleteCard(btn)
            
                completionHandler(true)
            }
        delete.backgroundColor = UIColor().colorsFromAsset(name: .red)

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}
