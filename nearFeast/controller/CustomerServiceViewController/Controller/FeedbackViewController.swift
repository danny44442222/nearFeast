//
//  FeedbackViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 09/01/2024.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var tfName:UITextField!
    @IBOutlet weak var tfEmail:UITextField!
    @IBOutlet weak var tfSubject:UITextField!
    @IBOutlet weak var tfMessage:UITextView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    var admin:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAdminData()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
    }
//    func openChatController(conversationID:String, receiverUser:UserModel){
//
//        let chatVC = ChatViewController.instantiateVC()
//        chatVC.conversationID = conversationID
//        chatVC.receiverUser = receiverUser
//        chatVC.isSendAdmin = true
//        let nav = UINavigationController(rootViewController: chatVC)
//        nav.modalPresentationStyle = .fullScreen
//        self.navigationController?.present(nav, animated: true, completion: nil)
//
//    }
    @IBAction func myRequestBtnPressed(_ sender:Any){
        self.performSegue(withIdentifier: "toList", sender: nil)
    }
    @IBAction func submitBtnPressed(_ sender:Any){
        if !self.tfName.isValid() || !self.tfEmail.isValid() || !self.tfSubject.isValid() || !self.tfMessage.isValid(){
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill all data", forViewController: self)
        }
        else{
            if self.admin != nil{
                PopupHelper.showAnimating(self)
                
                let request = RequestModel()
                request.name = self.tfName.text
                request.subject = self.tfSubject.text
                request.email = self.tfEmail.text
                request.message = self.tfMessage.text
                request.userId = FirebaseData.getCurrentUserId().0
                request.timeStamp = Date().milisecondInt64
                request.isSolved = false
                FirebaseData.addFeedbackToAdminConversation(request:request, completion: { error in
                    self.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
//                    FirebaseData.getConverstationOfTwoUsersSerivce(FirebaseData.getCurrentUserId().0, conversationId: uid) { user, error in
//                        self.stopAnimating()
//                        guard let user = user else {
//                            return
//                        }
//                        self.openChatController(conversationID: uid, receiverUser: user)
//                    }
                })
            }
            else{
                PopupHelper.showAlertControllerWithError(forErrorMessage: "CSR not found contact admin", forViewController: self)
            }
            
           
        }
    }
    func loadAdminData(){
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.admin = userData
        }
//        FirebaseData.getAdminUserData() { error, userModel in
//            self.admin = self.user
//            self.admin = userModel
//        }
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
extension FeedbackViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Feedback"{
            textView.textColor = .black
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Feedback"{
            textView.textColor = .lightGray
            textView.text = "Feedback"
        }
    }
}
