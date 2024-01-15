//
//  AddCardViewController.swift
//  iRide
//
//  Created by Buzzware Tech on 25/05/2021.
//

import UIKit
import FormTextField
import Stripe
class AddCardViewController: UIViewController {

    @IBOutlet weak var tfCardNumber:FormTextField!
    @IBOutlet weak var tfExpiryDate:FormTextField!
    @IBOutlet weak var tfcvcNumber:FormTextField!
    @IBOutlet weak var tfpostcode:UITextField!
    @IBOutlet weak var btnAddCard:UIButton!
    
    var delegate = UIViewController()
    var ammount: Double!
    var type: String!
    var dataDic: [String:Any]!
    var user:UserModel!
    var isSubcribe = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tfcard()
        self.tfdate()
        self.tfcvc()
        self.loadData()
        self.btnAddCard.setTitle("Confirm $\(self.ammount ?? 0)", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func cardNumberChnaged(_ textField:UITextField){
        switch STPCardValidator.brand(forNumber: self.tfCardNumber.text!) {
        case .visa:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_visa"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
            
        case .mastercard:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_mastercard"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .amex:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_amex"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .dinersClub:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_diners"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .discover:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_discover"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .JCB:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_jcb"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .unionPay:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_unionpay_en"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .unknown:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_unknown"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        default:
            textField.textColor = .red
            break
        }
    }
    @IBAction func expiryDateChnaged(_ textField:UITextField){
        if textField.text!.contains("/"){
            if let date = textField.text?.components(separatedBy: "/") as? [String]?{
                
                if let month = date?[0],let year = date?[1]{
                    if STPCardValidator.validationState(forExpirationMonth: month) == .valid && STPCardValidator.validationState(forExpirationYear: year, inMonth: month) == .valid{
                        textField.textColor = .green
                    }
                    else{
                        textField.textColor = .red
                    }
                }
                else{
                    if let month = date?[0]{
                        if STPCardValidator.validationState(forExpirationMonth: month) == .valid{
                            textField.textColor = .green
                        }
                        else{
                            textField.textColor = .red
                        }
                    }
                }
            }
            else{
                textField.textColor = .red
            }
        }
        else{
            if let month = textField.text{
                if STPCardValidator.validationState(forExpirationMonth: month) == .valid{
                    textField.textColor = .green
                }
                else{
                    textField.textColor = .red
                }
            }
        }
        
    }
    @IBAction func cvcNumberChnaged(_ textField:UITextField){
        if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .visa) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .amex) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .dinersClub) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .discover) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .JCB) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .mastercard) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .unionPay) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .unknown) == .valid{
            textField.textColor = .green
        }
        else{
            textField.textColor = .red
        }
    }
    func loadData(){
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            guard let userData = userData else {
                return
            }
            self.user = userData
            if userData.stripeCustid == nil{
                var data = [String:Any]()
                data[UserKeys.email.rawValue] = userData.email
                data[UserKeys.userId.rawValue] = FirebaseData.getCurrentUserId().0
                self.callWebService(data: data, action: .checkcustidexistornot, .post)
            }
        }
    }
    func tfcard(){
        self.tfCardNumber.inputType = .integer
        self.tfCardNumber.formatter = CardNumberFormatter()
        self.tfCardNumber.placeholder = "Card Number"
        
        let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_unknown"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        }
        arrow.contentMode = .scaleAspectFit
        self.tfCardNumber.leftView = arrow
        self.tfCardNumber.leftViewMode = .always

        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        self.tfCardNumber.inputValidator = inputValidator
    }
    func tfdate(){
        self.tfExpiryDate.inputType = .integer
        self.tfExpiryDate.formatter = CardExpirationDateFormatter()
        self.tfExpiryDate.placeholder = "MM/YY"

        let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_cvc_amex"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        }
        arrow.contentMode = .scaleAspectFit
        self.tfExpiryDate.leftView = arrow
        self.tfExpiryDate.leftViewMode = .always
        
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        self.tfExpiryDate.inputValidator = inputValidator
    }
    func tfcvc(){
        self.tfcvcNumber.inputType = .integer
        self.tfcvcNumber.placeholder = "CVC"

        let arrow = UIImageView(image: #imageLiteral(resourceName: "stp_card_cvc"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        }
        arrow.contentMode = .scaleAspectFit
        self.tfcvcNumber.leftView = arrow
        self.tfcvcNumber.leftViewMode = .always
        
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        self.tfcvcNumber.inputValidator = inputValidator
        
    }
    @IBAction func payCardBtnPressed(_ sender:Any) {
        if self.tfCardNumber.textColor == UIColor.red || !self.tfCardNumber.isValid() || self.tfExpiryDate.textColor == UIColor.red || !self.tfExpiryDate.isValid() || self.tfcvcNumber.textColor == UIColor.red || !self.tfcvcNumber.isValid(){
            
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill all field of valid column", forViewController: self)
        }
        else{
            let expDateArray = tfExpiryDate.text!.components(separatedBy: "/")
            let cardParams = STPCardParams()
            cardParams.number = self.tfCardNumber.text!
            cardParams.expMonth = UInt(expDateArray[0])!
            cardParams.expYear = UInt(expDateArray[1])!
            cardParams.cvc = self.tfcvcNumber.text!
        
            if isSubcribe{
                self.SimplePaymentSubcription()
            }
            else{
                self.SimplePayment()
            }
            
            
        }
    }
    func SimplePaymentSubcription() {
        
        PopupHelper.showAnimating(self)
        var dataDic = [String:Any]()
        dataDic[Constant.email] = self.user.email
        dataDic[Constant.cus_id] = self.user.stripeCustid
        dataDic[Constant.price] = Int((self.ammount ?? 1) * 100)
        dataDic[Constant.recurring] = self.type
        dataDic[Constant.interval_count] = 1
        
        
        self.callWebService(data:dataDic,action:.createsubscription,.post)
        
    }
    
    
    func SimplePayment() {
        
        PopupHelper.showAnimating(self)
        var dataDic = [String:Any]()
        dataDic[Constant.cus_id] = self.user.stripeCustid
        self.callWebService(data:dataDic,action:.firststep,.post)
    }
    func SimplePayment1(pm_id:String) {
        PopupHelper.showAnimating(self)
        var dataDic = [String:Any]()
        dataDic[Constant.cus_id] = self.user.stripeCustid
        dataDic[Constant.pm_id] = pm_id
        dataDic[Constant.amount] = Int((self.ammount ?? 1) * 100)
        self.callWebService(data:dataDic,action:.accoutpaymentnew,.post)
    }
    func stripeSimplePayment(key:String) {
        PopupHelper.showAnimating(self)
        let expDateArray = tfExpiryDate.text!.components(separatedBy: "/")
        let cardParams = STPCardParams()
        cardParams.name = self.user.firstName
        cardParams.number = self.tfCardNumber.text!
        cardParams.expMonth = UInt(expDateArray[0])!
        cardParams.expYear = UInt(expDateArray[1])!
        cardParams.cvc = self.tfcvcNumber.text!
        cardParams.address.country = "US"
        cardParams.address.postalCode = self.tfpostcode.text
        
        let cardParameters = STPPaymentMethodCardParams(cardSourceParams: cardParams)
        let paymentMethodParams = STPPaymentMethodParams(card: cardParameters, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPSetupIntentConfirmParams(clientSecret: key)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        //paymentIntentParams.setupFutureUsage = .offSession
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmSetupIntent(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            self.self.stopAnimating()
            switch (status) {
            case .failed:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                
            case .canceled:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                
            case .succeeded:
                print(paymentIntent?.paymentMethodID)
                if self.ammount != nil{
                    if self.isSubcribe{
                        self.SimplePaymentSubcription()
                    }
                    else{
                        self.SimplePayment1(pm_id: paymentIntent!.paymentMethodID!)
                    }
                    
                }
                else{
                    switch self.delegate{
                    case let controller as subscribeViewViewController:
                        self.dismissVCAction()
                    default:
                        break
                    }
                }
                
            @unknown default:
                fatalError()
                break
            }
        }
    }
    func stripeSimplePayment1(_ paymentIntentClientSecret:String) {
        PopupHelper.showAnimating(self)
        
        
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        //paymentIntentParams.paymentMethodParams = paymentMethodParams
        //paymentIntentParams.setupFutureUsage = .offSession
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            self.self.stopAnimating()
            switch (status) {
            case .failed:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                
            case .canceled:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                
            case .succeeded:
                print(paymentIntent?.paymentMethodId)
                switch self.delegate{
                case let controller as subscribeViewViewController:
                    controller.paySucces(paymentIntentClientSecret)
                    self.dismissVCAction()
                default:
                    break
                }
                
            @unknown default:
                fatalError()
                break
            }
        }
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
                        case .firststep:
                            if let key = dic["key"] as? String{
                                self.stripeSimplePayment(key: key)
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        case .accoutpaymentnew:
                            if let data = dic["transferinfo"] as? String{
                                self.stripeSimplePayment1(data)
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
                                    self.loadData()
                                }
                            }
                        case .createsubscription:
                            
                            if let SubsData = dic["data"] as? Dictionary<String,Any>{
                                
                                if let dataa = SubsData["subscription_id"] as? String{
                                    
                                    switch self.delegate{
                                    case let controller as subscribeViewViewController:
                                        controller.paySucces(dataa, cusid: self.user.stripeCustid)
                                        self.dismissVCAction()
                                    default:
                                        break
                                    }

                                }
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
extension AddCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
