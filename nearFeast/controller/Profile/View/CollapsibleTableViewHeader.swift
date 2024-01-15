//
//  HeaderView.swift
//  Trucker World
//
//  Created by Mac on 04/08/2023.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}
class CollapsibleTableViewHeader: UIView {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var ivImage:UIImageView!
    @IBOutlet weak var arrowImage:  UIImageView!
    //let arrowLabel = UILabel()
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation (see Extensions.swf)
        arrowImage.rotate(collapsed ? 0.0 : .pi / 2)
    }
    

}
extension UIView{
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}
