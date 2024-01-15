//
//  AccountSettingViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 09/01/2024.
//

import UIKit

class AccountSettingViewController: UIViewController {

    @IBOutlet weak var distanceSwitch:UISwitch!
    @IBOutlet weak var lblDistance:UILabel!
    @IBOutlet weak var topBarView: UIView!
    var ismile = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if let miles = UserDefaults.standard.value(forKey: Constant.distance) as? Bool{
            if miles{
                self.distanceSwitch.isOn = miles
                self.ismile = miles
                self.lblDistance.text = Constant.Miles
            }
            else{
                self.distanceSwitch.isOn = miles
                self.ismile = miles
                self.lblDistance.text = Constant.Kilometers
            }
        }
        else{
            UserDefaults.standard.setValue(true, forKey: Constant.distance)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        
    }
    @IBAction func switchchange(_ sender:UISwitch){
        if self.ismile{
            self.ismile = false
            self.lblDistance.text = Constant.Kilometers
            UserDefaults.standard.setValue(false, forKey: Constant.distance)
        }
        else{
            self.ismile = true
            self.lblDistance.text = Constant.Miles
            UserDefaults.standard.setValue(true, forKey: Constant.distance)
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
