//
//  ChatModel.swift
//  MyReferral
//
//  Created by vision on 09/06/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit
enum ChatKeys:String{
    case content = "content"
    case fromID = "fromID"
    case toID = "toID"
    case timestamp = "timestamp"
    case type = "type"
    case isRead = "isRead"
    case messageId = "messageId"
    case isLike = "isLike"
    case replyCount = "replyCount"
    case style = "style"

    
}
class ChatModel: GenericDictionary {
    var content:String!
    {
        get{ return stringForKey(key: ChatKeys.content.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.content.rawValue)}
    }
    
    var fromID:String!
    {
        get{ return stringForKey(key: ChatKeys.fromID.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.fromID.rawValue)}
    }
    
    var toID:String!
    {
        get{ return stringForKey(key: ChatKeys.toID.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.toID.rawValue)}
    }
    
    var timestamp:Int64!
    {
        get{ return int64ForKey(key: ChatKeys.timestamp.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.timestamp.rawValue)}
    }
    
    var type:String!
    {
        get{ return stringForKey(key: ChatKeys.type.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.type.rawValue)}
    }
    
    var isRead:[String:Bool]!
    {
        get{ return dictBoolForKey(key: ChatKeys.isRead.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.isRead.rawValue)}
    }
    
    var messageId:String!
    {
        get{ return stringForKey(key: ChatKeys.messageId.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.messageId.rawValue)}
    }
    var replyCount:String!
    {
        get{ return stringForKey(key: ChatKeys.replyCount.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.replyCount.rawValue)}
    }
    var isLike:[String]!
    {
        get{ return stringArrayForKey(key: ChatKeys.isLike.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.isLike.rawValue)}
    }
}
//class chatmodel1{
//    
//    var chatmodel:ChatModel!
//    var style:RevealStyle!
//    init(chat:ChatModel? = nil,style:RevealStyle? = nil) {
//        self.chatmodel = chat
//        self.style = style
//    }
//    
//}


enum NotificationKeys:String{
    case details = "details"
    case grouptype = "grouptype"
    case id = "id"
    case name = "name"
    case sender_type = "sender_type"
    case time = "time"
    case userlist = "userlist"

    
}
class NotificationModel: GenericDictionary {
    var details:String!
    {
        get{ return stringForKey(key: NotificationKeys.details.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.details.rawValue)}
    }
    
    var grouptype:String!
    {
        get{ return stringForKey(key: NotificationKeys.grouptype.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.grouptype.rawValue)}
    }
    
    var id:String!
    {
        get{ return stringForKey(key: NotificationKeys.id.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.id.rawValue)}
    }
    
    var time:Int64!
    {
        get{ return int64ForKey(key: NotificationKeys.time.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.time.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: NotificationKeys.name.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.name.rawValue)}
    }

    var sender_type:String!
    {
        get{ return stringForKey(key: NotificationKeys.sender_type.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.sender_type.rawValue)}
    }
    var userlist:[String]!
    {
        get{ return stringArrayForKey(key: NotificationKeys.userlist.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.userlist.rawValue)}
    }
}

class CommentModel{
    var user:UserModel!
    var comment:ChatModel!
    init(user: UserModel? = nil, comment: ChatModel? = nil) {
        self.user = user
        self.comment = comment
    }
}
