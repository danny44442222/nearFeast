//
//  CardModel.swift
//  iRide
//
//  Created by Buzzware Tech on 04/01/2022.
//

import UIKit

enum CardKeys:String {
    case id = "id"
    case brand = "brand"
    case exp_month = "exp_month"
    case exp_year = "exp_year"
    case fingerprint = "fingerprint"
    case last4 = "last4"
    
}
class CardModel: GenericDictionary {

    
    var id:String!
    {
        get{ return stringForKey(key: CardKeys.id.rawValue)}
        set{setValue(newValue, forKey: CardKeys.id.rawValue)}
    }
    var brand:String!
    {
        get{ return stringForKey(key: CardKeys.brand.rawValue)}
        set{setValue(newValue, forKey: CardKeys.brand.rawValue)}
    }
    
    var exp_month:Int64!
    {
        get{ return int64ForKey(key: CardKeys.exp_month.rawValue)}
        set{setValue(newValue, forKey: CardKeys.exp_month.rawValue)}
    }
    
    var exp_year:Int64!
    {
        get{ return int64ForKey(key: CardKeys.exp_year.rawValue)}
        set{setValue(newValue, forKey: CardKeys.exp_year.rawValue)}
    }
    var fingerprint:String!
    {
        get{ return stringForKey(key: CardKeys.fingerprint.rawValue)}
        set{setValue(newValue, forKey: CardKeys.fingerprint.rawValue)}
    }
    var last4:String!
    {
        get{ return stringForKey(key: CardKeys.last4.rawValue)}
        set{setValue(newValue, forKey: CardKeys.last4.rawValue)}
    }
    
}
