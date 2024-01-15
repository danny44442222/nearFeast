//
//  DatePickerView.swift
//  Rugel-International
//
//  Created by Buzzware Tech on 23/11/2022.
//

import UIKit
protocol DatePickerViewDelegate: AnyObject
{
    func didFinish(pickerView:UIDatePicker)
    func didCancel()
//    func webServiceDataParsingOnResponseReceivedArr(
//    viewControllerObj: UIViewController,
//    dataDict: NSArray)
    
}
class DatePickerView {

    var mainPickerView: UIDatePicker!
    var mainToolBar: UIToolbar!
    weak var delegate: DatePickerViewDelegate?
    
    init(_ textfield: UITextField,controller:UIViewController,mode:UIDatePicker.Mode = .date)
    
    {
        mainPickerView = UIDatePicker()
        mainToolBar = UIToolbar()
        
        mainPickerView.tag = textfield.tag
        mainPickerView.accessibilityHint = textfield.accessibilityHint
        mainPickerView.datePickerMode = mode
        if #available(iOS 13.4, *) {
            mainPickerView.preferredDatePickerStyle = .wheels
        }
        //mainPickerView.delegate?.pickerView!(mainPickerView, didSelectRow: 0, inComponent: 0)
        mainToolBar.barStyle = .default
        mainToolBar.tintColor = UIColor().colorsFromAsset(name: .red)
       mainToolBar.isTranslucent = false
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: controller.view.frame.size.width / 3, height: controller.view.frame.size.height))
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            mainPickerView.frame = CGRect(x: mainPickerView.frame.origin.x, y: mainPickerView.frame.origin.y, width: mainPickerView.frame.width, height: mainPickerView.frame.height+80)
            mainToolBar.frame = CGRect(x:0, y:controller.view.frame.size.height/6, width:controller.view.frame.size.width, height:70.0)
            //mainToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70)
            mainToolBar.layer.position = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height-50.0)
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            
        }
        else
        {
            if UIScreen.main.bounds.height <= 1136
            {
                mainPickerView.frame = CGRect(x: mainPickerView.frame.origin.x, y: mainPickerView.frame.origin.y, width: mainPickerView.frame.width, height: mainPickerView.frame.height)
                mainToolBar.frame = CGRect(x:0, y:controller.view.frame.size.height/6, width:controller.view.frame.size.width, height:40.0)
                //mainToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)
                mainToolBar.layer.position = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height-5.0)
                label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                
            }
            else
            {
                
                mainPickerView.frame = CGRect(x: mainPickerView.frame.origin.x, y: mainPickerView.frame.origin.y, width: mainPickerView.frame.width, height: mainPickerView.frame.height+50)
                mainToolBar.frame = CGRect(x:0, y:controller.view.frame.size.height/6, width:controller.view.frame.size.width, height:40.0)
                //mainToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
                mainToolBar.layer.position = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height-20.0)
                label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            }
            
        }
        
        mainToolBar.backgroundColor = UIColor().colorsFromAsset(name: .red)
        let defaultButton = UIBarButtonItem(primaryAction: UIAction(title: "Cancel",handler: { action in
            self.delegate?.didCancel()
            
        })) //UIBarButtonItem(title: "Cancel" , style: .plain, target: self, action: #selector(self.tappedCancelBarBtn))
        defaultButton.tintColor = .black
        let doneButton = UIBarButtonItem(primaryAction: UIAction(title: "Done",handler: { action in
            self.delegate?.didFinish(pickerView: self.mainPickerView)
        }))//UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePressed))
        doneButton.tintColor = .black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.black
        label.text = textfield.placeholder
        label.textAlignment = .center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        mainToolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        textfield.inputAccessoryView = mainToolBar
        textfield.inputView = mainPickerView
        
    }
    
    @objc public func tappedCancelBarBtn()
    {
        mainPickerView = nil
        mainToolBar = nil
        delegate?.didCancel()
          
    }
    @objc func donePressed()
    {
        delegate?.didFinish(pickerView: self.mainPickerView)
        mainPickerView = nil
        mainToolBar = nil
        
    }
}
protocol SimplePickerViewDelegate: AnyObject
{
    func didFinish(pickerView:UIPickerView)
    func didCancel()
//    func webServiceDataParsingOnResponseReceivedArr(
//    viewControllerObj: UIViewController,
//    dataDict: NSArray)
    
}
class SimplePickerView {

    var mainPickerView: UIPickerView!
    var mainToolBar: UIToolbar!
    weak var delegate: SimplePickerViewDelegate?
    
    init(_ textfield: UITextField,controller:UIViewController)
    
    {
        mainPickerView = UIPickerView()
        mainToolBar = UIToolbar()
        
        mainPickerView.tag = textfield.tag
        mainPickerView.accessibilityHint = textfield.accessibilityHint
        
        //mainPickerView.delegate?.pickerView!(mainPickerView, didSelectRow: 0, inComponent: 0)
        mainToolBar.barStyle = .default
        mainToolBar.tintColor = UIColor().colorsFromAsset(name: .red)
       mainToolBar.isTranslucent = false
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: controller.view.frame.size.width / 3, height: controller.view.frame.size.height))
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            mainPickerView.frame = CGRect(x: mainPickerView.frame.origin.x, y: mainPickerView.frame.origin.y, width: mainPickerView.frame.width, height: mainPickerView.frame.height+80)
            mainToolBar.frame = CGRect(x:0, y:controller.view.frame.size.height/6, width:controller.view.frame.size.width, height:70.0)
            //mainToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70)
            mainToolBar.layer.position = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height-50.0)
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            
        }
        else
        {
            if UIScreen.main.bounds.height <= 1136
            {
                mainPickerView.frame = CGRect(x: mainPickerView.frame.origin.x, y: mainPickerView.frame.origin.y, width: mainPickerView.frame.width, height: mainPickerView.frame.height)
                mainToolBar.frame = CGRect(x:0, y:controller.view.frame.size.height/6, width:controller.view.frame.size.width, height:40.0)
                //mainToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)
                mainToolBar.layer.position = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height-5.0)
                label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                
            }
            else
            {
                
                mainPickerView.frame = CGRect(x: mainPickerView.frame.origin.x, y: mainPickerView.frame.origin.y, width: mainPickerView.frame.width, height: mainPickerView.frame.height+50)
                mainToolBar.frame = CGRect(x:0, y:controller.view.frame.size.height/6, width:controller.view.frame.size.width, height:40.0)
                //mainToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
                mainToolBar.layer.position = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height-20.0)
                label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            }
            
        }
        
        mainToolBar.backgroundColor = UIColor().colorsFromAsset(name: .red)
        let defaultButton = UIBarButtonItem(primaryAction: UIAction(title: "Cancel",handler: { action in
            self.delegate?.didCancel()
            
        })) //UIBarButtonItem(title: "Cancel" , style: .plain, target: self, action: #selector(self.tappedCancelBarBtn))
        defaultButton.tintColor = .black
        let doneButton = UIBarButtonItem(primaryAction: UIAction(title: "Done",handler: { action in
            self.delegate?.didFinish(pickerView: self.mainPickerView)
        }))//UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePressed))
        doneButton.tintColor = .black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.black
        label.text = textfield.placeholder
        label.textAlignment = .center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        mainToolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        textfield.inputAccessoryView = mainToolBar
        textfield.inputView = mainPickerView
        
    }
    
    @objc public func tappedCancelBarBtn()
    {
        mainPickerView = nil
        mainToolBar = nil
        delegate?.didCancel()
          
    }
    @objc func donePressed()
    {
        delegate?.didFinish(pickerView: self.mainPickerView)
        mainPickerView = nil
        mainToolBar = nil
        
    }
}
