//
//  EditProfileViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 20/11/2023.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
class EditProfileViewController: UIViewController {

    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    
    var array = [SettingModel]()
    fileprivate var currentNonce: String?
    var user:UserModel!
    var isEdit = false
    var oldPass:String!
    var dataDic = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            guard let userData = userData else {return}
            self.user = userData
            self.oldPass = userData.password
            self.array = [
                SettingModel(name: "Full Name",nameplace: "Gregory Smith",cellType: .tfimage,key:.userName,detail:self.user.userName, keyboardType: .default,isEnable: true, isValid: true,imageName: "Acccount"),
                
                SettingModel(name: "Email Address",nameplace: "Gregorysmith@info.com",cellType: .tfimage,key:.email,detail:self.user.email,keyboardType: .default,isEnable: self.user.email == nil ? true:false, isValid: true,imageName: "Notifications"),
                
                SettingModel(name: "Phone number",nameplace: "+98 765 432 10",cellType: .tfimage,key:.phoneNumber,detail:self.user.phoneNumber,keyboardType: .default,isEnable: true, isValid: true,imageName: "Privacy policy")
                
                
//                SettingModel(name: "Password",nameplace: "***************",cellType: .tfimage,key:.password,detail:self.user.password,keyboardType: .default,isEnable: true, isValid: true,imageName: "Log Out")
            ]
            self.ivTableview.reloadData()
        }
    }
    @IBAction func editBtnPressed(_ sender:Any){
        var isPassChanged = false
        self.dataDic = [String:Any]()
        for d in self.array{
            switch d.key{
            case .password:
                if let nameDetail = d.nameDetail,nameDetail.isEmpty,nameDetail.count < 6{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill" + " \(d.name ?? " atleast 6 character")" + " and confirm password", forViewController: self)
                    return
                }
                if self.oldPass != d.nameDetail{
                    isPassChanged = true
                }
                else{
                    isPassChanged = false
                }
                dataDic[d.key.rawValue] = d.nameDetail
            default:
                dataDic[d.key.rawValue] = d.nameDetail
            }
            
        }
        PopupHelper.showAnimating(self)
        if isPassChanged{
            FirebaseData.updateUserPassword(password: dataDic[UserKeys.password.rawValue] as! String) { error in
                
                if let error = error{
                    let authError = error as NSError
                    if authError.code == AuthErrorCode.requiresRecentLogin.rawValue{
                        if let oldPass = self.oldPass{
                            FirebaseData.loginUserData(email: self.dataDic[UserKeys.email.rawValue] as! String, password: oldPass) { auth,error in
                                if let error = error{
                                    self.stopAnimating()
                                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                    return
                                }
                                FirebaseData.updateUserPassword(password: self.dataDic[UserKeys.password.rawValue] as! String) { error in
                                    
                                    if let error = error{
                                        self.stopAnimating()
                                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                        return
                                    }
                                    FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: self.dataDic) { error in
                                        self.stopAnimating()
                                        if let error = error{
                                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                            return
                                        }
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                            }
                        }
                        else{
                            if let email = self.dataDic[UserKeys.email.rawValue] as? String{
                                FirebaseData.linkAuthUserData(email: self.dataDic[UserKeys.email.rawValue] as! String, password: self.dataDic[UserKeys.password.rawValue] as! String, controller: self) { result, error in
                                    if let error = error as? NSError{
                                        self.stopAnimating()
                                        if error.code == 100{
                                            self.Apple_login_Action()
                                            return
                                        }
                                        else{
                                            
                                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                            return
                                        }
                                        
                                    }
                                    FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: self.dataDic) { error in
                                        self.stopAnimating()
                                        if let error = error{
                                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                            return
                                        }
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                            }
                            else{
                                self.stopAnimating()
                                PopupHelper.showAlertControllerWithError(forErrorMessage: "Please enter email", forViewController: self)
                                return
                            }
                            
                        }
                        
                    }
                    return
                }
                FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: self.dataDic) { error in
                    self.stopAnimating()
                    if let error = error{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                        return
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        else{
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: dataDic) { error in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    @objc func imageBtn(_ sender:UIGestureRecognizer){
        takePhoto(btn: sender.view!,mediaType: .image)
    }
    func uploadImage(image:UIImage){
        PopupHelper.showAnimating(self)
        FirebaseData.uploadProfileImage(image: image, name: FirebaseData.getCurrentUserId().0, folder: Constant.NODE_USERS) { url, error, index in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            guard let url = url else {return}
            let uss = UserModel()
            uss.image = url
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: uss) { error in
                self.stopAnimating()
                self.loadData()
            }
            
        }
    }

}
extension EditProfileViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfile1TableViewCell") as! EditProfile1TableViewCell
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            if let user = self.user, let image = user.image{
                cell.ivImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
            }
            else{
                cell.ivImage.image = UIImage(named: "01 – 1")
            }
            cell.ivImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageBtn(_:))))
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as! EditProfileTableViewCell
            
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            
            cell.lblName.text = self.array[indexPath.row].name
            cell.lblDetail.text =  self.array[indexPath.row].nameDetail
            cell.lblDetail.isEnabled =  self.array[indexPath.row].isEnable
            cell.lblDetail.delegate = self
            cell.lblDetail.tag = indexPath.row

            return cell
        }
        

        
    }
    

    
}
extension EditProfileViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.array[textField.tag].nameDetail = textField.text
    }
}
extension EditProfileViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.uploadImage(image: image)
        }
        picker.dismiss(animated: true)
    }
}
extension EditProfileViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    func Apple_login_Action() {
        PopupHelper.showAnimating(self)
        self.startSignInWithAppleFlow()
    }
    func startSignInWithAppleFlow() {
     let nonce = String().randomNonceString()
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
        let passwordProvider = ASAuthorizationPasswordProvider()
        let request1 = passwordProvider.createRequest()
        self.currentNonce = nonce
      let authorizationController = ASAuthorizationController(authorizationRequests: [request,request1])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                let err = "Invalid state: A login callback was received, but no login request was sent."
                print(err)
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                let err = "Unable to fetch identity token"
                print(err)
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                let err = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                print(err)
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            FirebaseData.reAuthUserData(token: credential) { result, error in
                
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                FirebaseData.linkAuthUserData(email: self.dataDic[UserKeys.email.rawValue] as! String, password: self.dataDic[UserKeys.password.rawValue] as! String, controller: self) { result, error in
                    if let error = error{
                        self.stopAnimating()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                        return
                        
                    }
                    FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: self.dataDic) { error in
                        self.stopAnimating()
                        if let error = error{
                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                            return
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.stopAnimating()
        print("Sign in with Apple errored: \(error)")
        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
