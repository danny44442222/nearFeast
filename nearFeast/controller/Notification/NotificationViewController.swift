//
//  NotificationViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 09/01/2024.
//

import UIKit

class NotificationViewController: UIViewController {

    
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var generalSwitch: UISwitch!
    @IBOutlet weak var restaurentSwitch: UISwitch!
    @IBOutlet weak var reviewSwitch: UISwitch!
    var isNotify = true
    var isRestNotify = true
    var isReviewNotify = true
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
            self.isNotify = self.user.isNotify
            self.isRestNotify = self.user.isRestaurantNotify
            self.isReviewNotify = self.user.isReviewNotify
            self.generalSwitch.isOn = self.isNotify
            self.restaurentSwitch.isOn = self.isRestNotify
            self.reviewSwitch.isOn = self.isReviewNotify
        }
    }
    @IBAction func generalchanges(_ sender: UISwitch) {
        if self.isNotify{
            self.isNotify = false
            sender.isOn = self.isNotify
        }
        else{
            self.isNotify = true
            sender.isOn = self.isNotify
        }
        self.updateData()
    }
    @IBAction func restarantchanges(_ sender: UISwitch) {
        if self.isRestNotify{
            self.isRestNotify = false
            sender.isOn = self.isRestNotify
        }
        else{
            self.isRestNotify = true
            sender.isOn = self.isRestNotify
        }
        self.updateData()
    }
    @IBAction func reviewchanges(_ sender: UISwitch) {
        if self.isReviewNotify{
            self.isReviewNotify = false
            sender.isOn = self.isReviewNotify
        }
        else{
            self.isReviewNotify = true
            sender.isOn = self.isReviewNotify
        }
        self.updateData()
    }
    func updateData(){
        PopupHelper.showAnimating(self)
        let data = UserModel()
        data.isNotify = self.isNotify
        data.isRestaurantNotify = self.isRestNotify
        data.isReviewNotify = self.isReviewNotify
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: data) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.user.isNotify = self.isNotify
            self.user.isRestaurantNotify = self.isRestNotify
            self.user.isReviewNotify = self.isReviewNotify
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        
    }

}
