//
//  AllNotificationViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 10/01/2024.
//

import UIKit

class AllNotificationViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var ivTableview:UITableView!
    var proArray = [NotificationModel]()
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
        FirebaseData.getNotificationList(FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.proArray = userData!
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
extension AllNotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.proArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        if let name = self.proArray[indexPath.row].name{
            cell.lblName.text = name
        }
        if let details = self.proArray[indexPath.section].details{
            cell.lblReview.text = details
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
