//
//  UserModel.swift
//  MyReferral
//
//  Created by vision on 15/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

enum UserKeys:String {
    case id = "id"
    case firstName = "firstName"
    case lastName = "lastName"
    case userName = "userName"
    case email = "email"
    case phoneNumber = "phoneNumber"
    case category = "category"
    case interest = "interest"
    case image = "image"
    case video = "video"
    case wallImage = "wallImage"
    case galleryImage = "galleryImage"
    case aboutMe = "aboutMe"
    case address = "address"
    case websites = "websites"
    case facebookUrl = "facebookUrl"
    case twitterUrl = "twitterUrl"
    case instagramUrl = "instagramUrl"
    case messengerUrl = "messengerUrl"
    case pintrestUrl = "pintrestUrl"
    case linkedinUrl = "linkedinUrl"
    case city = "city"
    case state = "state"
    case zipcode = "zipcode"
    case password = "password"
    case token = "token"
    case authToken = "authToken"
    case userRole = "userRole"
    case lat = "lat"
    case lng = "lng"
    case isActive = "isActive"
    case isOnline = "isOnline"
    case blockContent = "blockContent"
    case reportContent = "reportContent"
    case ratings = "ratings"
    case isBlock = "isBlock"
    case isAdminVerify = "isAdminVerify"
    case stripeclient_secret = "stripeclient_secret"
    case reviews = "reviews"
    case specialist = "specialist"
    case userDate = "userDate"
    case deviceType = "deviceType"
    case timing = "timing"
    case isActiveAccount = "isActiveAccount"
    case pins = "pins"
    case follow = "follow"
    case myPins = "myPins"
    case eventUsers = "eventUsers"
    case myFollows = "myFollows"
    case distance = "distance"
    case isDeleted = "isDeleted"
    case isAnonymus = "isAnonymus"
    case socialLink = "socialLink"
    case stripeCustid = "stripeCustid"

    case userId = "userId"
    case subscriptionId = "subscriptionId"
    case isSubcribe = "isSubcribe"
    case sessionTime = "sessionTime"
    case isNotify = "isNotify"
    case isRestaurantNotify = "isRestaurantNotify"
    case isReviewNotify = "isReviewNotify"
    case isBio = "isBio"
    case isStay = "isStay"
    case defStar = "defStar"
    case defDist = "defDist"
    case defCity = "defCity"
    
}
class UserModel: GenericDictionary,Codable {

    var id:String!
    {
        get{ return stringForKey(key: UserKeys.id.rawValue)}
        set{setValue(newValue, forKey: UserKeys.id.rawValue)}
    }
    var userName:String!
    {
        get{ return stringForKey(key: UserKeys.userName.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userName.rawValue)}
    }
    var firstName:String!
    {
        get{ return stringForKey(key: UserKeys.firstName.rawValue)}
        set{setValue(newValue, forKey: UserKeys.firstName.rawValue)}
    }
    var lastName:String!
    {
        get{ return stringForKey(key: UserKeys.lastName.rawValue)}
        set{setValue(newValue, forKey: UserKeys.lastName.rawValue)}
    }
    
    var email:String!
    {
        get{ return stringForKey(key: UserKeys.email.rawValue)}
        set{setValue(newValue, forKey: UserKeys.email.rawValue)}
    }
    
    var phoneNumber:String!
    {
        get{ return stringForKey(key: UserKeys.phoneNumber.rawValue)}
        set{setValue(newValue, forKey: UserKeys.phoneNumber.rawValue)}
    }
    var category:String!
    {
        get{ return stringForKey(key: UserKeys.category.rawValue)}
        set{setValue(newValue, forKey: UserKeys.category.rawValue)}
    }
    var interest:[String]!
    {
        get{ return stringArrayForKey(key: UserKeys.interest.rawValue)}
        set{setValue(newValue, forKey: UserKeys.interest.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: UserKeys.image.rawValue)}
        set{setValue(newValue, forKey: UserKeys.image.rawValue)}
    }
    var wallImage:String!
    {
        get{ return stringForKey(key: UserKeys.wallImage.rawValue)}
        set{setValue(newValue, forKey: UserKeys.wallImage.rawValue)}
    }
    var galleryImage:[[String:Any]]!
    {
        get{ return dictArrayForKey(key: UserKeys.galleryImage.rawValue)}
        set{setValue(newValue, forKey: UserKeys.galleryImage.rawValue)}
    }
    var video:String!
    {
        get{ return stringForKey(key: UserKeys.video.rawValue)}
        set{setValue(newValue, forKey: UserKeys.video.rawValue)}
    }
    var aboutMe:String!
    {
        get{ return stringForKey(key: UserKeys.aboutMe.rawValue)}
        set{setValue(newValue, forKey: UserKeys.aboutMe.rawValue)}
    }
    var address:String!
    {
        get{ return stringForKey(key: UserKeys.address.rawValue)}
        set{setValue(newValue, forKey: UserKeys.address.rawValue)}
    }
    var websites:String!
    {
        get{ return stringForKey(key: UserKeys.websites.rawValue)}
        set{setValue(newValue, forKey: UserKeys.websites.rawValue)}
    }
    var facebookUrl:String!
    {
        get{ return stringForKey(key: UserKeys.facebookUrl.rawValue)}
        set{setValue(newValue, forKey: UserKeys.facebookUrl.rawValue)}
    }
    var twitterUrl:String!
    {
        get{ return stringForKey(key: UserKeys.twitterUrl.rawValue)}
        set{setValue(newValue, forKey: UserKeys.twitterUrl.rawValue)}
    }
    var instagramUrl:String!
    {
        get{ return stringForKey(key: UserKeys.instagramUrl.rawValue)}
        set{setValue(newValue, forKey: UserKeys.instagramUrl.rawValue)}
    }
    var messengerUrl:String!
    {
        get{ return stringForKey(key: UserKeys.messengerUrl.rawValue)}
        set{setValue(newValue, forKey: UserKeys.messengerUrl.rawValue)}
    }
    var pintrestUrl:String!
    {
        get{ return stringForKey(key: UserKeys.pintrestUrl.rawValue)}
        set{setValue(newValue, forKey: UserKeys.pintrestUrl.rawValue)}
    }
    var linkedinUrl:String!
    {
        get{ return stringForKey(key: UserKeys.linkedinUrl.rawValue)}
        set{setValue(newValue, forKey: UserKeys.linkedinUrl.rawValue)}
    }
    var city:String!
    {
        get{ return stringForKey(key: UserKeys.city.rawValue)}
        set{setValue(newValue, forKey: UserKeys.city.rawValue)}
    }
    var state:String!
    {
        get{ return stringForKey(key: UserKeys.state.rawValue)}
        set{setValue(newValue, forKey: UserKeys.state.rawValue)}
    }
    var zipcode:String!
    {
        get{ return stringForKey(key: UserKeys.zipcode.rawValue)}
        set{setValue(newValue, forKey: UserKeys.zipcode.rawValue)}
    }
    
    var password:String!
    {
        get{ return stringForKey(key: UserKeys.password.rawValue)}
        set{setValue(newValue, forKey: UserKeys.password.rawValue)}
        
    }
    var token:String!
    {
        get{ return stringForKey(key: UserKeys.token.rawValue)}
        set{setValue(newValue, forKey: UserKeys.token.rawValue)}
    }
    var authToken:String!
    {
        get{ return stringForKey(key: UserKeys.authToken.rawValue)}
        set{setValue(newValue, forKey: UserKeys.authToken.rawValue)}
    }
    var userRole:String!
    {
        get{ return stringForKey(key: UserKeys.userRole.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userRole.rawValue)}
    }
    var lat:Double!
    {
        get{ return douleForKey(key: UserKeys.lat.rawValue)}
        set{setValue(newValue, forKey: UserKeys.lat.rawValue)}
    }
    var lng:Double!
    {
        get{ return douleForKey(key: UserKeys.lng.rawValue)}
        set{setValue(newValue, forKey: UserKeys.lng.rawValue)}
    }
    var isAnonymus:Bool!
    {
        get{ return boolForKey(key: UserKeys.isAnonymus.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: UserKeys.isAnonymus.rawValue)}
    }
    var isAdminVerify:Bool!
    {
        get{ return boolForKey(key: UserKeys.isAdminVerify.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isAdminVerify.rawValue)}
    }
    var isActive:Bool!
    {
        get{ return boolForKey(key: UserKeys.isActive.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isActive.rawValue)}
    }
    var isOnline:Bool!
    {
        get{ return boolForKey(key: UserKeys.isOnline.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isOnline.rawValue)}
    }
    var isActiveAccount:Bool!
    {
        get{ return boolForKey(key: UserKeys.isActiveAccount.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isActiveAccount.rawValue)}
    }
    var ratings:[Double]!
    {
        get{ return doubleArrayForKey(key: UserKeys.ratings.rawValue)}
        set{setValue(newValue, forKey: UserKeys.ratings.rawValue)}
    }
    var blockContent:[String:Bool]!
    {
        get{ return dictBoolForKey(key: UserKeys.blockContent.rawValue)}
        set{setValue(newValue, forKey: UserKeys.blockContent.rawValue)}
    }
    var reportContent:[String:Bool]!
    {
        get{ return dictBoolForKey(key: UserKeys.reportContent.rawValue)}
        set{setValue(newValue, forKey: UserKeys.reportContent.rawValue)}
    }
    var isBlock:Bool!
    {
        get{ return boolForKey(key: UserKeys.isBlock.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: UserKeys.isBlock.rawValue)}
    }
    var isDeleted:Bool!
    {
        get{ return boolForKey(key: UserKeys.isDeleted.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: UserKeys.isDeleted.rawValue)}
    }
    var pins:[String:Bool]!
    {
        get{ return dictBoolForKey(key: UserKeys.pins.rawValue)}
        set{setValue(newValue, forKey: UserKeys.pins.rawValue)}
    }
    var myPins:Int64!
    {
        get{ return int64ForKey(key: UserKeys.myPins.rawValue)}
        set{setValue(newValue, forKey: UserKeys.myPins.rawValue)}
    }
    var myFollows:Int64!
    {
        get{ return int64ForKey(key: UserKeys.myFollows.rawValue)}
        set{setValue(newValue, forKey: UserKeys.myFollows.rawValue)}
    }
    var distance:Double!
    {
        get{ return doubleForKey(key: UserKeys.distance.rawValue)}
        set{setValue(newValue, forKey: UserKeys.distance.rawValue)}
    }
    var follow:[String:Int64]!
    {
        get{ return dictInt64ForKey(key: UserKeys.follow.rawValue)}
        set{setValue(newValue, forKey: UserKeys.follow.rawValue)}
    }
    var stripeclient_secret:String!
    {
        get{ return stringForKey(key: UserKeys.stripeclient_secret.rawValue)}
        set{setValue(newValue, forKey: UserKeys.stripeclient_secret.rawValue)}
    }
    var reviews:[String]!
    {
        get{ return stringArrayForKey(key: UserKeys.reviews.rawValue)}
        set{setValue(newValue, forKey: UserKeys.reviews.rawValue)}
    }
    var timing:[[String:Any]]!
    {
        get{ return dictArrayForKey(key: UserKeys.timing.rawValue)}
        set{setValue(newValue, forKey: UserKeys.timing.rawValue)}
    }
    var eventUsers:[String:Bool]!
    {
        get{ return dictBoolForKey(key: UserKeys.eventUsers.rawValue)}
        set{setValue(newValue, forKey: UserKeys.eventUsers.rawValue)}
    }
    var specialist:[String]!
    {
        get{ return stringArrayForKey(key: UserKeys.specialist.rawValue)}
        set{setValue(newValue, forKey: UserKeys.specialist.rawValue)}
    }
    var userDate:Int64!
    {
        get{ return int64ForKey(key: UserKeys.userDate.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userDate.rawValue)}
    }
    var deviceType:String!
    {
        get{ return stringForKey(key: UserKeys.deviceType.rawValue)}
        set{setValue(newValue, forKey: UserKeys.deviceType.rawValue)}
    }
    var socialLink:[String:String]!
    {
        get{ return dictStringForKey(key: UserKeys.socialLink.rawValue)}
        set{setValue(newValue, forKey: UserKeys.socialLink.rawValue)}
    }
    var isSubcribe:Bool!
    {
        get{ return boolForKey(key: UserKeys.isSubcribe.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: UserKeys.isSubcribe.rawValue)}
    }
    var subscriptionId:String!
    {
        get{ return stringForKey(key: UserKeys.subscriptionId.rawValue)}
        set{setValue(newValue, forKey: UserKeys.subscriptionId.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: UserKeys.userId.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userId.rawValue)}
    }
    var stripeCustid:String!
    {
        get{ return stringForKey(key: UserKeys.stripeCustid.rawValue)}
        set{setValue(newValue, forKey: UserKeys.stripeCustid.rawValue)}
    }
    var sessionTime:Int64!
    {
        get{ return int64ForKey(key: UserKeys.sessionTime.rawValue)}
        set{setValue(newValue, forKey: UserKeys.sessionTime.rawValue)}
    }
    var isNotify:Bool!
    {
        get{ return boolForKey(key: UserKeys.isNotify.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isNotify.rawValue)}
    }
    var isRestaurantNotify:Bool!
    {
        get{ return boolForKey(key: UserKeys.isRestaurantNotify.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isRestaurantNotify.rawValue)}
    }
    var isReviewNotify:Bool!
    {
        get{ return boolForKey(key: UserKeys.isReviewNotify.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isReviewNotify.rawValue)}
    }
    var isBio:Bool!
    {
        get{ return boolForKey(key: UserKeys.isBio.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: UserKeys.isBio.rawValue)}
    }
    var isStay:Bool!
    {
        get{ return boolForKey(key: UserKeys.isStay.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: UserKeys.isStay.rawValue)}
    }
    var defDist:Int64!
    {
        get{ return int64ForKey(key: UserKeys.defDist.rawValue)}
        set{setValue(newValue, forKey: UserKeys.defDist.rawValue)}
    }
    var defStar:Int64!
    {
        get{ return int64ForKey(key: UserKeys.defStar.rawValue)}
        set{setValue(newValue, forKey: UserKeys.defStar.rawValue)}
    }
    var defCity:String!
    {
        get{ return stringForKey(key: UserKeys.defCity.rawValue)}
        set{setValue(newValue, forKey: UserKeys.defCity.rawValue)}
    }
}
