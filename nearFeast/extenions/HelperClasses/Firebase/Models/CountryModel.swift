//
//  CountryModel.swift
//  MyReferral
//
//  Created by vision on 19/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

enum CountryKeys:String {
    
    case id = "id"
    case date = "date"
    case details = "details"
    case image = "image"
    case lat = "lat"
    case lng = "lng"
    case name = "name"
    case icon = "icon"
    case discover = "discover"
    
}

class CountryModel: GenericDictionary {

    
    var id:String!
    {
        get{ return stringForKey(key: CountryKeys.id.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.id.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: CountryKeys.date.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.date.rawValue)}
    }
    
    var details:String!
    {
        get{ return stringForKey(key: CountryKeys.details.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.details.rawValue)}
    }
    
    var image:String!
    {
        get{ return stringForKey(key: CountryKeys.image.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.image.rawValue)}
    }
    
    var lat:Double!
    {
        get{ return doubleForKey(key: CountryKeys.lat.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.lat.rawValue)}
    }
    
    var lng:Double!
    {
        get{ return doubleForKey(key: CountryKeys.lng.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.lng.rawValue)}
    }
    var name:String!
    {
        get{ return stringForKey(key: CountryKeys.name.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.name.rawValue)}
    }
    var icon:String!
    {
        get{ return stringForKey(key: CountryKeys.icon.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.icon.rawValue)}
    }
    var discover:[String:Bool]!
    {
        get{ return dictBoolForKey(key: CountryKeys.discover.rawValue)}
        set{setValue(newValue, forKey: CountryKeys.discover.rawValue)}
    }
}
