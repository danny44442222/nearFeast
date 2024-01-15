//
//  ClaimedModel.swift
//  MyReferral
//
//  Created by Adeel on 12/09/2020.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

class ClaimedModel: GenericDictionary {

    
    var claimedPoints:Int
    {
        get{ return intForKey(key: "claimedPoints")}
        set{setValue(newValue, forKey: "claimedPoints")}
    }
    
    
    var time:Int64
    {
        get{ return int64ForKey(key: "time")}
        set{setValue(newValue, forKey: "time")}
    }
}
