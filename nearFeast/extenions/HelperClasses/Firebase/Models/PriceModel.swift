//
//  PriceModel.swift
//  iRide
//
//  Created by Buzzware Tech on 14/12/2021.
//

import UIKit

enum PriceKeys:String {
    case iRide = "iRide"
    case iPackage = "iPackage"
    case iScooter = "iScooter"
    case iRideLux = "iRideLux"
    case iRidePlus = "iRidePlus"
    
}
class PriceModel: GenericDictionary {

//    var iRide:PricesModel!
//    {
//        get{ return pricesForKey(key: PriceKeys.iRide.rawValue)}
//        set{setValue(newValue, forKey: PriceKeys.iRide.rawValue)}
//    }
//    var iRideLux:PricesModel!
//    {
//        get{ return pricesForKey(key: PriceKeys.iRideLux.rawValue)}
//        set{setValue(newValue, forKey: PriceKeys.iRideLux.rawValue)}
//    }
//
//    var iRidePlus:PricesModel!
//    {
//        get{ return pricesForKey(key: PriceKeys.iRidePlus.rawValue)}
//        set{setValue(newValue, forKey: PriceKeys.iRidePlus.rawValue)}
//    }
    var iRide:[String:Any]!
    {
        get{ return dictForKey(key: PriceKeys.iRide.rawValue)}
        set{setValue(newValue, forKey: PriceKeys.iRide.rawValue)}
    }
    var iRideLux:[String:Any]!
    {
        get{ return dictForKey(key: PriceKeys.iRideLux.rawValue)}
        set{setValue(newValue, forKey: PriceKeys.iRideLux.rawValue)}
    }

    var iRidePlus:[String:Any]!
    {
        get{ return dictForKey(key: PriceKeys.iRidePlus.rawValue)}
        set{setValue(newValue, forKey: PriceKeys.iRidePlus.rawValue)}
    }
}
enum PricesKeys:String {
    case costOfVehicle = "costOfVehicle"
    case initialFee = "initialFee"
    case name = "name"
    case pricePerMile = "pricePerMile"
    case pricePerMin = "pricePerMin"
    case pricePerKm = "pricePerKm"
    case isActive = "isActive"
    case carType = "carType"
    case amount = "amount"
    case time = "time"
    case image = "image"
    case date = "date"
    
}
class PricesModel: GenericDictionary {

    var costOfVehicle:String!
    {
        get{ return stringForKey(key: PricesKeys.costOfVehicle.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.costOfVehicle.rawValue)}
    }
    var initialFee:String!
    {
        get{ return stringForKey(key: PricesKeys.initialFee.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.initialFee.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: PricesKeys.name.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.name.rawValue)}
    }
    var pricePerMile:String!
    {
        get{ return stringForKey(key: PricesKeys.pricePerMile.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.pricePerMile.rawValue)}
    }
    var pricePerKm:String!
    {
        get{ return stringForKey(key: PricesKeys.pricePerKm.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.pricePerKm.rawValue)}
    }
    var pricePerMin:String!
    {
        get{ return stringForKey(key: PricesKeys.pricePerMin.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.pricePerMin.rawValue)}
    }
    var isActive:Bool!
    {
        get{ return boolForKey(key: PricesKeys.isActive.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: PricesKeys.isActive.rawValue)}
    }
    var carType:String!
    {
        get{ return stringForKey(key: PricesKeys.carType.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.carType.rawValue)}
    }
    var amount:String!
    {
        get{ return stringForKey(key: PricesKeys.amount.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.amount.rawValue)}
    }
    var time:String!
    {
        get{ return stringForKey(key: PricesKeys.time.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.time.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: PricesKeys.image.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.image.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: PricesKeys.date.rawValue)}
        set{setValue(newValue, forKey: PricesKeys.date.rawValue)}
    }
}
