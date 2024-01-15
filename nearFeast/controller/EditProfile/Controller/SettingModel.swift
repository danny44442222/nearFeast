//
//  SettingModel.swift
//  iRide
//
//  Created by Buzzware Tech on 19/05/2021.
//
enum CellType:String {
    case btn
    case tf
    case tv
    case tfimage
    case image
    case check
    case drop
    case slider
    case collection


}
import UIKit

class SettingModel {

    var name:String!
    var nameplace:String!
    var key:UserKeys!
    var cellType:CellType!
    var nameDetail: String!
    var nameDetail1: String!
    var nameDetailInt: Int64!
    var keyboardType:UIKeyboardType!
    var isEnable:Bool!
    var isSecure:Bool!
    var isError:Bool!
    var optionDrop:[String]!
    var isValid:Bool!
    var isBtnHide:Bool!
    var isComplete:Bool!
    var borderColor:UIColor!
    var imageName:String!
    
    
    
    init(name:String? = nil,nameplace:String? = nil,cellType:CellType? = nil,key:UserKeys? = nil,detailInt:Int64? = nil,detail:String? = nil,detail1:String? = nil,keyboardType:UIKeyboardType = .default ,isEnable:Bool = true,isSecure:Bool = false,isError:Bool = false,isValid:Bool = false,isComplete:Bool = false,isBtnHide:Bool = false,borderColor:UIColor = .lightGray,imageName:String? = nil,optionDrop:[String]? = nil) {
        self.name = name
        self.key = key
        self.cellType = cellType
        self.nameDetail = detail
        self.nameDetail1 = detail1
        self.keyboardType = keyboardType
        self.isEnable = isEnable
        self.isSecure = isSecure
        self.isError = isError
        self.nameDetailInt = detailInt
        self.isValid = isValid
        self.isBtnHide = isBtnHide
        self.isComplete = isComplete
        self.borderColor = borderColor
        self.imageName = imageName
        self.optionDrop = optionDrop
        self.nameplace = nameplace
    }
}
