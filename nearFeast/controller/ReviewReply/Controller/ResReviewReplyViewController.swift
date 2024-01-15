//
//  ResReviewReplyViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 30/12/2023.
//

import UIKit

class ResReviewReplyViewController: UIViewController {

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    @IBOutlet weak var tfComment: UITexfield_Additions!
    var comentsArray = [CommentModel]()
    
    var reviewData :ResReviewModel!
    var restData:RestaurantModel!
    var isProduct = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.bottomBarView.drawTwoCorner(roundTo: .top)
        self.loadData()
        if let assoic = self.restData.association,let userid = self.restData.userId{
            if assoic && userid == FirebaseData.getCurrentUserId().0{
                self.bottomBarView.isHidden = false
            }
            else{
                self.bottomBarView.isHidden = true
            }
        }
        else{
            self.bottomBarView.isHidden = true
        }
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getRestReviewWithCommentList(self.restData.docId, reviewid: self.reviewData.docId) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.comentsArray = userData!
            self.ivTableview.reloadData()
        }
    }
    
    @IBAction func sendBtnPressed(_ sender:Any){
        if self.tfComment.text.isEmpty{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please type a comments", forViewController: self)
            return
        }
        PopupHelper.showAnimating(self)
        let uuid = UUID().uuidString
        let coment = ChatModel()
        coment.messageId = uuid
        coment.fromID = FirebaseData.getCurrentUserId().0
        coment.toID = FirebaseData.getCurrentUserId().0
        coment.timestamp = Date().milisecondInt64
        coment.type = "text"
        coment.content = self.tfComment.text
        coment.isRead = [FirebaseData.getCurrentUserId().0:true]
        FirebaseData.saveRestReviewCommData(restid: self.restData.docId, reviewid: self.reviewData.docId, uid: uuid, userData: coment) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
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
extension ResReviewReplyViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comentsArray.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("ReviewHeaderView", owner: self)?.first as! ReviewHeaderView
        if let user = self.reviewData.user,let userName = user.userName{
            cell.lblName.text = userName
        }
        if let user = self.reviewData.user,let image = user.image{
            cell.ivUserImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            cell.ivUserImage.image = #imageLiteral(resourceName: "01 – 1")
        }
        if let review = self.reviewData.review{
            cell.lblReview.text = review
        }
        if let date = self.reviewData.date{
            cell.lblDate.text = date.getInt64toTime().formattedWith(Globals.__dd_MM_yyyy)
        }
        if let rating = self.reviewData.rating{
            
            cell.vRating.rating = rating
        }
        else{
            cell.vRating.rating = 0
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        if let user = self.comentsArray[indexPath.row].user,let userName = user.userName{
            cell.lblName.text = userName
        }
        if let user = self.comentsArray[indexPath.row].user,let image = user.image{
            cell.ivUserImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            cell.ivUserImage.image = #imageLiteral(resourceName: "01 – 1")
        }
        if let comment = self.comentsArray[indexPath.row].comment,let content = comment.content{
            cell.lblReview.text = content
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
