//
//  TermsViewController.swift
//  nearFeast
//
//  Created by Buzzware Tech on 09/01/2024.
//

import UIKit

class TermsViewController: UIViewController {
    @IBOutlet weak var topBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topBarView.drawTwoCorner(roundTo: .bottom)
        
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
