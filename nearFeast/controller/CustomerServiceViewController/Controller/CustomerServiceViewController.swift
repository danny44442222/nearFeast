//
//  CustomerServiceViewController.swift
//  iRide
//
//  Created by Buzzware Tech on 25/05/2021.
//

import UIKit

class CustomerServiceViewController: UIViewController {

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
                let chatModel = ChatModel()
                let uid = UUID().uuidString
                chatModel.content = "Name : \(self.tfName.text!), Subject : \(self.tfSubject.text!), Email : \(self.tfEmail.text!), Message : \(self.tfMessage.text!)"
                chatModel.fromID = FirebaseData.getCurrentUserId().0
                chatModel.toID = "\(self.admin.docId)00"
                chatModel.messageId = uid
                chatModel.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
                chatModel.isRead = [FirebaseData.getCurrentUserId().0:true]
                chatModel.type = "text"
                let request = RequestModel()
                request.conversationId = uid
                request.name = self.tfName.text
                request.subject = self.tfSubject.text
                request.email = self.tfEmail.text
                request.message = self.tfMessage.text
                request.userId = FirebaseData.getCurrentUserId().0
                request.timeStamp = Date().milisecondInt64
                request.isSolved = false
                FirebaseData.addMessageToAdminConversation(documentId: uid,request:request, chatModel: chatModel, completion: { error in
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
extension CustomerServiceViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Message"{
            textView.textColor = .black
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Message"{
            textView.textColor = .lightGray
            textView.text = "Message"
        }
    }
}
