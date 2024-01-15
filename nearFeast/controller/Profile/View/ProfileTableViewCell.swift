//
//  ProfileTableViewCell.swift
//  nearFeast
//
//  Created by Buzzware Tech on 20/11/2023.
//

import UIKit
import ExpyTableView

class ProfileTableViewCell: UITableViewCell,ExpyTableViewHeaderCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var ivImage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            hideSeparator()
            arrowDown(animated: !cellReuse)
            
        case .willCollapse:
            print("WILL COLLAPSE")
            arrowRight(animated: !cellReuse)
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            showSeparator()
            print("DID COLLAPSE")
        }
    }
    
    private func arrowDown(animated: Bool) {
//        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
//            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
//        }
    }
    
    private func arrowRight(animated: Bool) {
//        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
//            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: 0)
//        }
    }

}
extension UITableViewCell {

    func showSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        }
    }
}
