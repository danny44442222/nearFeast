//
//  ReferralModel.swift
//  MyReferral
//
//  Created by vision on 15/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

class ReferralModel: GenericDictionary {
    
    var referId:String
    {
        get{ return stringForKey(key: "referId")}
        set{setValue(newValue, forKey: "referId")}
    }
    
    var currentUserUID:String
    {
        get{ return stringForKey(key: "currentUserUID")}
        set{setValue(newValue, forKey: "currentUserUID")}
    }
    
    var userName:String
    {
        get{ return stringForKey(key: "userName")}
        set{setValue(newValue, forKey: "userName")}
    }
    
    var date:Int64
    {
        get{ return int64ForKey(key: "date")}
        set{setValue(newValue, forKey: "date")}
    }
    
    var email:String
    {
        get{ return stringForKey(key: "email")}
        set{setValue(newValue, forKey: "email")}
    }
    
    var mobileNo:String
    {
        get{ return stringForKey(key: "mobileNo")}
        set{setValue(newValue, forKey: "mobileNo")}
    }
    
    var countryId:String
    {
        get{ return stringForKey(key: "countryId")}
        set{setValue(newValue, forKey: "countryId")}
    }
    
    var branchId:String
    {
        get{ return stringForKey(key: "branchId")}
        set{setValue(newValue, forKey: "branchId")}
    }
    
    var purposeId:String
    {
        get{ return stringForKey(key: "purposeId")}
        set{setValue(newValue, forKey: "purposeId")}
    }
    
    var status:String
    {
        get{ return stringForKey(key: "status")}
        set{setValue(newValue, forKey: "status")}
    }
    
    var points:String
    {
        get{ return stringForKey(key: "points")}
        set{setValue(newValue, forKey: "points")}
    }
    
    var countryName:String
    {
        get{ return stringForKey(key: "countryName")}
        set{setValue(newValue, forKey: "countryName")}
    }
    
    var branchName:String
    {
        get{ return stringForKey(key: "branchName")}
        set{setValue(newValue, forKey: "branchName")}
    }
    
}
