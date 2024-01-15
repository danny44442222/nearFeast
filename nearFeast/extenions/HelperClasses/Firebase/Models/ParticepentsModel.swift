//
//  ParticepentsModel.swift
//  iRideDriver
//
//  Created by Buzzware Tech on 27/12/2021.
//

import UIKit

class ParticepentsModel: GenericDictionary {

    var participants:[String:Any]
    {
        get{ return dictForKey(key: "participants")}
        set{setValue(newValue, forKey: "participants")}
    }
}
