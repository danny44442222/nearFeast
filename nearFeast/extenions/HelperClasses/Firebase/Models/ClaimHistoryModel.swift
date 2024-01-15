//
//  ClaimHistoryModel.swift
//  MyReferral
//
//  Created by Adeel on 12/09/2020.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

class ClaimHistoryModel: GenericDictionary {

    var userName:String
    {
        get{ return stringForKey(key: "userName")}
        set{setValue(newValue, forKey: "userName")}
    }
    
    var phoneNumber:String
    {
        get{ return stringForKey(key: "phoneNumber")}
        set{setValue(newValue, forKey: "phoneNumber")}
    }
    
    var userEmail:String
    {
        get{ return stringForKey(key: "userEmail")}
        set{setValue(newValue, forKey: "userEmail")}
    }
    var points:String
    {
        get{ return stringForKey(key: "points")}
        set{setValue(newValue, forKey: "points")}
    }
    var claimedPoints:Int
    {
        get{ return intForKey(key: "claimedPoints")}
        set{setValue(newValue, forKey: "claimedPoints")}
    }
    var balancePoints:Int
    {
        get{ return intForKey(key: "balancePoints")}
        set{setValue(newValue, forKey: "balancePoints")}
    }
    
    var date:Int64
    {
        get{ return int64ForKey(key: "date")}
        set{setValue(newValue, forKey: "date")}
    }

}
