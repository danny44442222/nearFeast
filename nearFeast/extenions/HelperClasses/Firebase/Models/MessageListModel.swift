//
//  MessageListModel.swift
//  MyReferral
//
//  Created by vision on 10/06/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

enum MessageListKeys:String{
    case chatType = "chatType"
    case groupName = "groupName"
    case groupImage = "groupImage"
    case groupAdminId = "groupAdminId"
    case participants = "participants"
    case lastMessage = "lastMessage"
    case punishment = "punishment"
}
class MessageListModel1: GenericDictionary {

    
    var chatType:String!
    {
        get{ return stringForKey(key: MessageListKeys.chatType.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.chatType.rawValue)}
    }
    var groupName:String!
    {
        get{ return stringForKey(key: MessageListKeys.groupName.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.groupName.rawValue)}
    }
    
    var groupImage:String!
    {
        get{ return stringForKey(key: MessageListKeys.groupImage.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.groupImage.rawValue)}
    }
    var groupAdminId:String!
    {
        get{ return stringForKey(key: MessageListKeys.groupAdminId.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.groupAdminId.rawValue)}
    }
    
    var participants:[String:Any]!
    {
        get{ return dictForKey(key: MessageListKeys.participants.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.participants.rawValue)}
    }
    var lastMessage:[String:Any]!
    {
        get{ return dictForKey(key: MessageListKeys.lastMessage.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.lastMessage.rawValue)}
    }
    var punishment:[String:Any]!
    {
        get{ return dictForKey(key: MessageListKeys.punishment.rawValue)}
        set{setValue(newValue, forKey: MessageListKeys.punishment.rawValue)}
    }
    
}
struct MessageListModel {
    var receiverUser:UserModel?
    
    //var messagesList:[ChatModel]
    var lastMessage:ChatModel?
    var conversationId:String
    var participants:[String]
    var punishment:[String]?
    var chatType:String?
    var groupName:String?
    var groupImage:String?
    var groupAdminId:String?
    
}

