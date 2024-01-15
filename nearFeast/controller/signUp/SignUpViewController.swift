//
//  SignUpViewController.swift
//  nearFeast
//
//  Created by Mac on 21/11/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var tfName: UITexfield_Additions!
    @IBOutlet weak var tfEmail: UITexfield_Additions!
    @IBOutlet weak var tfPhone: UITexfield_Additions!
    @IBOutlet weak var tfPassword: UITexfield_Additions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func signupBtnPressed(_ sender:Any){
        
        if self.tfName.text!.isEmpty{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user name", forViewController: self)
            return
        }
        if self.tfEmail.text!.isEmpty{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user email", forViewController: self)
            return
        }
        if !self.tfEmail.text!.isValidEmail(){
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user email in correct format", forViewController: self)
            return
        }
        if self.tfPhone.text!.isEmpty{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill user phone", forViewController: self)
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
        let user = UserModel()
        user.userName = self.tfName.text
        user.email = self.tfEmail.text
        user.phoneNumber = self.tfPhone.text
        user.password = self.tfPassword.text
        user.userRole = UserRole.user.rawValue
        user.userDate = Date().milisecondInt64
        user.isAdminVerify = true
        user.isActive = true
        user.isNotify = true
        user.isRestaurantNotify = true
        user.isReviewNotify = true
        user.isBio = true
        user.isStay = false
        user.sessionTime = Date().milisecondInt64
        FirebaseData.createEmailUser(email: self.tfEmail.text!, password: self.tfPassword.text!, usermodel: user) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.gotonext()
        }
    }
    func gotonext(){
        let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}

extension SignUpViewController{


}
