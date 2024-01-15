//
//  LoginViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//
import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseMessaging
import LocalAuthentication


class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITexfield_Additions!
    @IBOutlet weak var tfPassword: UITexfield_Additions!
    @IBOutlet weak var forgotButton: UIButton!
    fileprivate var currentNonce: String?
    
    var context = LAContext()
    var user:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        underlineButtonWithRedColor()
        // Do any additional setup after loading the view.
        self.loadData()
    }
    func loadData(){
        if FirebaseData.getCurrentUserId().1{
            FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
                self.user = userData
            }
        }
    }
    func underlineButtonWithRedColor() {
        
            // Get the current title of the button
            if let buttonText = forgotButton.titleLabel?.text {
                // Create an attributed string with underline and red color attributes
                let attributes: [NSAttributedString.Key: Any] = [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.red
                ]
                let underlineAttributedString = NSAttributedString(string: buttonText, attributes: attributes)

                // Set the attributed text to the button
                forgotButton.setAttributedTitle(underlineAttributedString, for: .normal)
            }
        }
    @IBAction func signinBtnPressed(_ sender:Any){
        
        
        if self.tfEmail.text!.isEmpty{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user email", forViewController: self)
            return
        }
        if !self.tfEmail.text!.isValidEmail(){
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user email in correct format", forViewController: self)
            return
        }
        if self.tfPassword.text!.isEmpty{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user password", forViewController: self)
            return
        }
        if self.tfPassword.text!.count < 6{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user password min 6 character", forViewController: self)
            return
        }
        PopupHelper.showAnimating(self)
        FirebaseData.loginUserData(email: self.tfEmail.text!, password: self.tfPassword.text!) { error, user in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let mod = UserModel()
            mod.sessionTime = Date().milisecondInt64
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: mod) { error in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.gotonext()
            }
            
            //let usrlogin = userLogin(islogin: true)
            //CommonHelper.saveCachedUserData(userData: usrlogin)
        }
    }
    func gotonext(){
        let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    
    func BiometricVerification(){
        
        var biometry = context.biometryType
        
        var error: NSError?
        var permissions = context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        )

        if permissions {
            print("Proceed")
            ProceedFaceID()
        }
        else {
            print("error")
        }
        
        
    }
    
    func ProceedFaceID(){
        
        let reason = "Log in with Face ID"
        context.evaluatePolicy(
            // .deviceOwnerAuthentication allows
            // biometric or passcode authentication
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, error in
            if success {
                // Handle successful authentication
                print("faceID Success")
                PopupHelper.showAnimating(self)
                DispatchQueue.main.async {
                    let mod = UserModel()
                    mod.sessionTime = Date().milisecondInt64
                    FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: mod) { error in
                        self.stopAnimating()
                        if let error = error{
                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                            return
                        }
                        self.gotonext()
                    }
                }
            }
            else {
                print("faceID error")
                // Handle LAError error
            }
        }
        
    }
    func ProceedTouchID(){
        
        let reason = "Log in with Touch ID"
        context.evaluatePolicy(
            // .deviceOwnerAuthentication allows
            // biometric or passcode authentication
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, error in
            if success {
                
                print("TouchID Success")
                // Handle successful authentication
            } else {
                print("TouchID error")

                // Handle LAError error
            }
        }
        
    }
    
    
    
    
    
    @IBAction func btnforget(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Forgot Password?", message: "Please enter a valid email", preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send", style: .default) { action in
            if let textfield = alertController.textFields?.first{
                if textfield.text!.isValidEmail(){
                    self.forgot(email: textfield.text!)
                }
                else{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "Invalid Email", forViewController: self)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { action in
            
        }
        alertController.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Enter Email"
        })
        alertController.addAction(sendAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func forgot(email:String){
        PopupHelper.showAnimating(self)
        
        FirebaseData.forgotUserPassword(email: email) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            PopupHelper.showAlertControllerWithSucces(forErrorMessage: "Please check your email", forViewController: self)
        }
    }
    
    
    
    @IBAction func btnloginface(_ sender: Any) {
        
        if FirebaseData.getCurrentUserId().1{
            
            if let user = self.user,user.isBio{
                
                BiometricVerification()
                
            }
            else{
                
                PopupHelper.alertWithOk(title: "Log in with FaceID", message: "This feature is unavailable.You must enable from setting", controler: self)
                
            }
        }
        else{
            PopupHelper.alertWithOk(title: "Log in with FaceID", message: "This feature is unavailable.You haven't logged in yet. Please first login with your email and password or Login with social.", controler: self)
        }
        
    }
    
    @IBAction func btnsignup(_ sender: Any) {
        
        let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .SignUpViewController)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btneyepassword(_ sender: Any) {
        if self.tfPassword.isSecureTextEntry{
            self.tfPassword.isSecureTextEntry = false
        }
        else{
            self.tfPassword.isSecureTextEntry = true
        }
    }
    @IBAction func Facebook_login_Action(_ sender: Any) {
        PopupHelper.showAnimating(self)
        FirebaseData.signinFacebook(controller: self) { error in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            let mod = UserModel()
            mod.sessionTime = Date().milisecondInt64
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: mod) { error in
                self.stopAnimating()
                if let error = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.gotonext()
            }
            //let usrlogin = userLogin(islogin: true)
             //CommonHelper.saveCachedUserData(userData: usrlogin)
            
        }
        
    }
@IBAction func Google_login_Action(_ sender: Any) {
    PopupHelper.showAnimating(self)
    FirebaseData.signinGoogle(controller: self) { error in
        
        if let error = error{
            self.stopAnimating()
            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
            return
        }
        let mod = UserModel()
        mod.sessionTime = Date().milisecondInt64
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: mod) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.gotonext()
        }
        //let usrlogin = userLogin(islogin: true)
         //CommonHelper.saveCachedUserData(userData: usrlogin)
        
    }

}
}

extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    @IBAction func Apple_login_Action(_ sender: Any) {
        PopupHelper.showAnimating(self)
        self.startSignInWithAppleFlow()
    }
    func startSignInWithAppleFlow() {
     let nonce = String().randomNonceString()
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256()
        self.currentNonce = nonce
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
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
            let dataDic = UserModel()
            dataDic.email = appleIDCredential.email
            dataDic.userName = appleIDCredential.fullName?.givenName
            dataDic.token = Messaging.messaging().fcmToken
            
            dataDic.authToken = idTokenString
            
            
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            FirebaseData.loginAuthUserData(token: credential){result,error in
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                else{
                    guard let user = result else {return}
                    FirebaseData.getUserData(uid: user.user.uid) { error, userData in
                        if error != nil{
                            
                            dataDic.userRole = UserRole.user.rawValue
                            dataDic.userDate = Date().milisecondInt64
                            dataDic.deviceType = "IOS"
                            dataDic.isActive = true
                            dataDic.isAdminVerify = true
                            dataDic.isNotify = true
                            dataDic.isRestaurantNotify = true
                            dataDic.isReviewNotify = true
                            dataDic.isBio = true
                            dataDic.isStay = false
                            //dataDic.isAnonymus = false
                            //dataDic.address = self.location.address
                            //dataDic.lat = self.location.addressLat
                            //dataDic.lng = self.location.addressLng
                            FirebaseData.saveUserData(uid: user.user.uid, userData: dataDic){
                                error in
                                self.stopAnimating()
                                if let error = error{
                                    
                                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                    return
                                }
                                else{
                                    self.gotonext()
                                }
                            }
                        }
                        else{
                            FirebaseData.checkUserData() { error,users in
                                if let error = error{
                                    self.stopAnimating()
                                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                    return
                                }
                                else{
                                    
                                    guard let userss = users else {return}
                                    if let userName = userss.userName,!userName.isEmpty{
                                        dataDic.userName = userName
                                    }
                                    if let image = userss.image,!image.isEmpty{
                                        dataDic.image = image
                                    }
                                    dataDic.sessionTime = Date().milisecondInt64
                                    FirebaseData.updateUserData(user.user.uid, dic: dataDic){
                                        error in
                                        self.stopAnimating()
                                        if let error = error{
                                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                            return
                                        }
                                        else{
                                            //let usrlogin = userLogin(islogin: true)
                                             //CommonHelper.saveCachedUserData(userData: usrlogin)
                                            self.gotonext()
                                        }
                                    }
                                }
                            }
                        }
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
