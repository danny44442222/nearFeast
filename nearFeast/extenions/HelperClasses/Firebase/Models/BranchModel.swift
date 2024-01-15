//
//  BranchModel.swift
//  MyReferral
//
//  Created by vision on 19/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

class BranchModel: GenericDictionary {
    var branchName:String
    {
        get{ return stringForKey(key: "branchName")}
        set{setValue(newValue, forKey: "branchName")}
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
    
    var address:String
    {
        get{ return stringForKey(key: "address")}
        set{setValue(newValue, forKey: "address")}
    }
    
    var email:String
    {
        get{ return stringForKey(key: "email")}
        set{setValue(newValue, forKey: "email")}
    }
}
