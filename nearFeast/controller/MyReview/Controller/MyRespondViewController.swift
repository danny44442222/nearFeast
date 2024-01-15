//
//  MyRespondViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 09/01/2024.
//

import UIKit

class MyRespondViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    var proArray = [ReviewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        self.loadData()
    }
    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getRespondReviewWithCommentList(FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.proArray = userData!
            self.ivTableview.reloadData()
        }
    }
    @objc func deleteChat(_ sender:UIButton){
        PopupHelper.showAnimating(self)
        let conversationId = self.proArray[sender.tag]
        FirebaseData.deleteReviewData(dishid: conversationId.dish.docId, reviewid: conversationId.docId) { error in
            self.stopAnimating()
            if let error = error{
                
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.proArray.remove(at: sender.tag)
            self.ivTableview.reloadData()
            
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
extension MyRespondViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.proArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comm = self.proArray[section].comment,comm.count > 0{
            return comm.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("Review1HeaderView", owner: self)?.first as! ReviewHeaderView
        if let user = self.proArray[section].user,let userName = user.userName{
            cell.lblName.text = userName
        }
        if let user = self.proArray[section].user,let image = user.image{
            cell.ivUserImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            cell.ivUserImage.image = #imageLiteral(resourceName: "01 – 1")
        }
        if let review = self.proArray[section].review{
            cell.lblReview.text = review
        }
        if let date = self.proArray[section].date{
            cell.lblDate.text = date.getInt64toTime().formattedWith(Globals.__dd_MM_yyyy)
        }
        if let rating = self.proArray[section].rating{
            
            cell.vRating.rating = rating
        }
        else{
            cell.vRating.rating = 0
        }
        cell.btnDelete.tag = section
        cell.btnDelete.addTarget(self, action: #selector(self.deleteChat(_:)), for: .touchUpInside)
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
        if let comm = self.proArray[indexPath.section].comment,let user = comm[indexPath.row].user,let userName = user.userName{
            cell.lblName.text = userName
        }
        if let comm = self.proArray[indexPath.section].comment,let user = comm[indexPath.row].user,let image = user.image{
            cell.ivUserImage.imageURLProfile(image, placholdr: #imageLiteral(resourceName: "01 – 1"))
        }
        else{
            cell.ivUserImage.image = #imageLiteral(resourceName: "01 – 1")
        }
        if let comm = self.proArray[indexPath.section].comment,let comment = comm[indexPath.row].comment,let content = comment.content{
            cell.lblReview.text = content
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            let btn = UIButton()
            btn.tag = indexPath.row
            self.deleteChat(btn)
            
                completionHandler(true)
            }
        delete.backgroundColor = UIColor.red

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}
