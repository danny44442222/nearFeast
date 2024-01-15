//
//  ChangePasswordViewController.swift
//  nearFeast
//
//  Created by Mac on 03/01/2024.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var tfpassword: UITexfield_Additions!
    fileprivate var currentNonce: String?
    var user:UserModel!
    
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
            self.tfpassword.text = userData.password
        }
    }
    @IBAction func btneyepassword(_ sender: Any) {
        if self.tfpassword.isSecureTextEntry{
            self.tfpassword.isSecureTextEntry = false
        }
        else{
            self.tfpassword.isSecureTextEntry = true
        }
    }
    @IBAction func btnpassword(_ sender: Any) {
        var isPassChanged = false
        self.dataDic = [String:Any]()
        if let nameDetail = tfpassword.text,nameDetail.isEmpty,nameDetail.count < 6{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill" + " \("Atleast 6 character")" + " and confirm password", forViewController: self)
            return
        }
        if self.oldPass != tfpassword.text ?? ""{
            isPassChanged = true
        }
        else{
            isPassChanged = false
        }
        dataDic[UserKeys.password.rawValue] = tfpassword.text ?? ""
        dataDic[UserKeys.email.rawValue] = self.user.email ?? ""
        
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
                                PopupHelper.showAlertControllerWithError(forErrorMessage: "Please update email from edit profile", forViewController: self)
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
            self.stopAnimating()
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
extension ChangePasswordViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
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
