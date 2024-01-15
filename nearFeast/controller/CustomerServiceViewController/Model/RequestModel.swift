//
//  RequestModel.swift
//  iRideDriver
//
//  Created by Buzzware Tech on 27/12/2021.
//

import UIKit


enum RequestKeys:String {
    case conversationId = "conversationId"
    case email = "email"
    case message = "message"
    case name = "name"
    case subject = "subject"
    case timeStamp = "timeStamp"
    case userId = "userId"
    case isSolved = "isSolved"
    
}
class RequestModel:GenericDictionary {

    var conversationId:String!
    {
        get{ return stringForKey(key: RequestKeys.conversationId.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.conversationId.rawValue)}
    }
    var email:String!
    {
        get{ return stringForKey(key: RequestKeys.email.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.email.rawValue)}
    }
    
    var message:String!
    {
        get{ return stringForKey(key: RequestKeys.message.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.message.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: RequestKeys.name.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.name.rawValue)}
    }
    var subject:String!
    {
        get{ return stringForKey(key: RequestKeys.subject.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.subject.rawValue)}
    }
    var timeStamp:Int64!
    {
        get{ return int64ForKey(key: RequestKeys.timeStamp.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.timeStamp.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: RequestKeys.userId.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.userId.rawValue)}
    }
    var isSolved:Bool!
    {
        get{ return boolForKey(key: RequestKeys.isSolved.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: RequestKeys.isSolved.rawValue)}
    }
    
}
