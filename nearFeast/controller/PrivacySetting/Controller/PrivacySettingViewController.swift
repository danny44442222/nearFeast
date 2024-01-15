//
//  PrivacySettingViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 11/01/2024.
//

import UIKit

class PrivacySettingViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var tfLocation: UITexfield_Additions!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btn1Star:UIButton!
    @IBOutlet weak var btn2Star:UIButton!
    @IBOutlet weak var btn3Star:UIButton!
    @IBOutlet weak var btn4Star:UIButton!
    @IBOutlet weak var btn5Star:UIButton!
    @IBOutlet weak var btnSubmit:UIButton!
    
    var selectedStar:Int64 = 0
    var distance:Int64 = 0
    var userData:UserModel!
    var city = ""
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
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
            self.stopAnimating()
            if let error = error{
                
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.userData = userData
            self.selectedStar = self.userData.defStar ?? 0
            self.distance = self.userData.defDist ?? 0
            self.city = self.userData.defCity ?? ""
            
            self.loadStar()
        }
        
    }
    
    func loadStar(){
        self.lblValue.text = "\(distance)"
        self.rangeSlider.value = Float(distance)
        self.tfLocation.text = city
        switch self.selectedStar{
        case 1:
            self.btn1Star.backgroundColor = .red
            self.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
            self.btn2Star.backgroundColor = .white
            self.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
            self.btn3Star.backgroundColor = .white
            self.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
            self.btn4Star.backgroundColor = .white
            self.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
            self.btn5Star.backgroundColor = .white
            self.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
            
        case 2:
            self.btn1Star.backgroundColor = .white
            self.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
            self.btn2Star.backgroundColor = .red
            self.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
            self.btn3Star.backgroundColor = .white
            self.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
            self.btn4Star.backgroundColor = .white
            self.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
            self.btn5Star.backgroundColor = .white
            self.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
        case 3:
            self.btn1Star.backgroundColor = .white
            self.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
            self.btn2Star.backgroundColor = .white
            self.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
            self.btn3Star.backgroundColor = .red
            self.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
            self.btn4Star.backgroundColor = .white
            self.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
            self.btn5Star.backgroundColor = .white
            self.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
        case 4:
            self.btn1Star.backgroundColor = .white
            self.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
            self.btn2Star.backgroundColor = .white
            self.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
            self.btn3Star.backgroundColor = .white
            self.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
            self.btn4Star.backgroundColor = .red
            self.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
            self.btn5Star.backgroundColor = .white
            self.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
        case 5:
            self.btn1Star.backgroundColor = .white
            self.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
            self.btn2Star.backgroundColor = .white
            self.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
            self.btn3Star.backgroundColor = .white
            self.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
            self.btn4Star.backgroundColor = .white
            self.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
            self.btn5Star.backgroundColor = .red
            self.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
        default:
            self.btn1Star.backgroundColor = .white
            self.btn1Star.setImage(#imageLiteral(resourceName: "1 star"), for: .normal)
            self.btn2Star.backgroundColor = .white
            self.btn2Star.setImage(#imageLiteral(resourceName: "2 star"), for: .normal)
            self.btn3Star.backgroundColor = .white
            self.btn3Star.setImage(#imageLiteral(resourceName: "3 star"), for: .normal)
            self.btn4Star.backgroundColor = .white
            self.btn4Star.setImage(#imageLiteral(resourceName: "4 star"), for: .normal)
            self.btn5Star.backgroundColor = .white
            self.btn5Star.setImage(#imageLiteral(resourceName: "5 star"), for: .normal)
        }
    }
    @IBAction func didChangedSlider(_ sender: UISlider) {

        self.lblValue.text = "\(Int64(sender.value))"
        self.distance = Int64(sender.value)
    }
    @IBAction func didTap1StarButton(_ sender: UIButton) {
        self.selectedStar = 1
        self.loadStar()
    }
    @IBAction func didTap2StarButton(_ sender: UIButton) {
        self.selectedStar = 2
        self.loadStar()
    }
    @IBAction func didTap3StarButton(_ sender: UIButton) {
        self.selectedStar = 3
        self.loadStar()
    }
    @IBAction func didTap4StarButton(_ sender: UIButton) {
        self.selectedStar = 4
        self.loadStar()
    }
    @IBAction func didTap5StarButton(_ sender: UIButton) {
        self.selectedStar = 5
        self.loadStar()
    }
    @IBAction func didTapUpdateButton(_ sender: UIButton) {
        PopupHelper.showAnimating(self)
        let model = UserModel()
        model.defCity = self.tfLocation.text
        model.defDist = self.distance
        model.defStar = self.selectedStar
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: model) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.navigationController?.popViewController(animated: true)
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
extension PrivacySettingViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.city = textField.text!
    }
}
