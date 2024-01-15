//
//  FingerPrintViewController.swift
//  nearFeast
//
//  Created by Mac on 03/01/2024.
//

import UIKit

class FingerPrintViewController: UIViewController {

    
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var ivenablewithc: UISwitch!
    @IBOutlet weak var ivstaywithc: UISwitch!
    var isBio = true
    var isStay = true
    var user:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
        // Do any additional setup after loading the view.
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
            self.isBio = self.user.isBio
            self.ivenablewithc.isOn = self.isBio
            self.isStay = self.user.isStay
            self.ivenablewithc.isOn = self.isStay
        }
    }
    @IBAction func ivswthcchanges(_ sender: UISwitch) {
        if self.isBio{
            self.isBio = false
            sender.isOn = self.isBio
        }
        else{
            self.isBio = true
            sender.isOn = self.isBio
        }
        self.updateData()
    }
    @IBAction func ivstayswthcchanges(_ sender: UISwitch) {
        if self.isStay{
            self.isStay = false
            sender.isOn = self.isStay
        }
        else{
            self.isStay = true
            sender.isOn = self.isStay
        }
        self.updateData()
    }
    func updateData(){
        PopupHelper.showAnimating(self)
        let data = UserModel()
        data.isBio = self.isBio
        data.isStay = self.isStay
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: data) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.user.isBio = self.isBio
            self.user.isStay = self.isStay
//            if !self.isBio{
//                FirebaseData.logout()
//            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        
    }

}
