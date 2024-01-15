//
//  ProductModel.swift
//  BetThatecomerce
//
//  Created by Buzzware Tech on 10/01/2023.
//

import UIKit


enum SongKeys:String {
    
    //Must variable
    case userId = "userId"
    case createdDate = "createdDate"
    case modifiedDate = "modifiedDate"
    case SongTitle = "SongTitle"
    case BPM = "BPM"
    case songContributers = "songContributers"
    case songUserColors = "songUserColors"
    case SongKey = "SongKey"
    case songNotes = "songNotes"
    case chatId = "chatId"
    case songLyrics = "songLyrics"
    case songnotifications = "songnotifications"
    case songBrainStrom = "songBrainStrom"
    case songNotifications2 = "songNotifications2"
    case isTyping = "isTyping"


}

class SongModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: SongKeys.userId.rawValue)}
        set{setValue(newValue, forKey: SongKeys.userId.rawValue)}
    }
    var songLyrics:String!
    {
        get{ return stringForKey(key: SongKeys.songLyrics.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songLyrics.rawValue)}
    }
    
    var createdDate:Int64!
    {
        get{ return int64ForKey(key: SongKeys.createdDate.rawValue)}
        set{setValue(newValue, forKey: SongKeys.createdDate.rawValue)}
    }
    var modifiedDate:Int64!
    {
        get{ return int64ForKey(key: SongKeys.modifiedDate.rawValue)}
        set{setValue(newValue, forKey: SongKeys.modifiedDate.rawValue)}
    }
    
    var SongTitle:String!
    {
        get{ return stringForKey(key: SongKeys.SongTitle.rawValue)}
        set{setValue(newValue, forKey: SongKeys.SongTitle.rawValue)}
    }
    var BPM:String!
    {
        get{ return stringForKey(key: SongKeys.BPM.rawValue)}
        set{setValue(newValue, forKey: SongKeys.BPM.rawValue)}
    }
    
    var songnotifications:[String:Bool]!
    {
        get{ return dictBoolForKey(key: SongKeys.songnotifications.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songnotifications.rawValue)}
    }
    var songNotifications2:[String:Bool]!
    {
        get{ return dictBoolForKey(key: SongKeys.songNotifications2.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songNotifications2.rawValue)}
    }

    var songContributers:[String:String]!
    {
        get{ return dictStringForKey(key: SongKeys.songContributers.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songContributers.rawValue)}
    }
    
    var songBrainStrom:[String:String]!
    {
        get{ return dictStringForKey(key: SongKeys.songBrainStrom.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songBrainStrom.rawValue)}
    }
    var songUserColors:[String:String]!
    {
        get{ return dictStringForKey(key: SongKeys.songUserColors.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songUserColors.rawValue)}
    }
    var songKey:String!
    {
        get{ return stringForKey(key: SongKeys.SongKey.rawValue)}
        set{setValue(newValue, forKey: SongKeys.SongKey.rawValue)}
    }
    var songNotes:String!
    {
        get{ return stringForKey(key: SongKeys.songNotes.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songNotes.rawValue)}
    }
    var chatId:String!
    {
        get{ return stringForKey(key: SongKeys.chatId.rawValue)}
        set{setValue(newValue, forKey: SongKeys.chatId.rawValue)}
    }
    var isTyping:Bool!
    {
        get{ return boolForKey(key: SongKeys.isTyping.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: SongKeys.isTyping.rawValue)}
    }
 
}

enum songNotificationKeys:String {
    
    //Must variable
    
    case userId = "userId"
    case titleNotification = "titleNotification"
    case status = "status"
    case timestamp = "timestamp"
    
}
class songNotifcationModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: songNotificationKeys.userId.rawValue)}
        set{setValue(newValue, forKey: songNotificationKeys.userId.rawValue)}
    }
    var titleNotification:String!
    {
        get{ return stringForKey(key: songNotificationKeys.titleNotification.rawValue)}
        set{setValue(newValue, forKey: songNotificationKeys.titleNotification.rawValue)}
    }
    var status:Bool!
    {
        get{ return boolForKey(key: songNotificationKeys.status.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: songNotificationKeys.status.rawValue)}
    }
    
    var timestamp:Int64!
    {
        get{ return int64ForKey(key: songNotificationKeys.timestamp.rawValue)}
        set{setValue(newValue, forKey: songNotificationKeys.timestamp.rawValue)}
    }
}

enum ReportModelKeys:String {
    
    //Must variable
    case userId = "userId"
    case reportDetail = "reportDetail"
    case reportType = "reportType"
    case reportTime = "reportTime"
    case reportedUserID = "reportedUserID"


}
class ReportModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: ReportModelKeys.userId.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.userId.rawValue)}
    }
    var reportedUserID:String!
    {
        get{ return stringForKey(key: ReportModelKeys.reportedUserID.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportedUserID.rawValue)}
    }
    var reportDetail:String!
    {
        get{ return stringForKey(key: ReportModelKeys.reportDetail.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportDetail.rawValue)}
    }
    var reportType:String!
    {
        get{ return stringForKey(key: ReportModelKeys.reportType.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportType.rawValue)}
    }
    
    var reportTime:Int64!
    {
        get{ return int64ForKey(key: ReportModelKeys.reportTime.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportTime.rawValue)}
    }
}


enum NotifcationKeys:String {
    
    //Must variable
    case UserID = "UserID"
    case content = "content"
    case extradata = "extradata"
    case type = "type"
    case modledata = "modledata"


}
class NotifcationModelData: GenericDictionary {

    var UserID:String!
    {
        get{ return stringForKey(key: NotifcationKeys.UserID.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.UserID.rawValue)}
    }
    var content:String!
    {
        get{ return stringForKey(key: NotifcationKeys.content.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.content.rawValue)}
    }
    var extradata:[String:Any]!
    {
        get{ return dictForKey(key: NotifcationKeys.extradata.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.extradata.rawValue)}
    }
    var type:String!
    {
        get{ return stringForKey(key: NotifcationKeys.type.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.type.rawValue)}
    }

}


class NotificationDataModel2{
    
    var MainData:NotifcationModelData!
    var extraData:extraModel!
    var userData:UserModel!

    init(MainData:NotifcationModelData? = nil , extraData:extraModel? = nil,userData:UserModel? = nil) {
        self.MainData = MainData
        self.extraData = extraData
        self.userData = userData
    }
    
}

class DatesImages: GenericDictionary {

    var imageUrl:String!
    {
        get{ return stringForKey(key: "imageUrl")}
        set{setValue(newValue, forKey: "imageUrl")}
    }

}
class NotesImages: GenericDictionary {

    var imageUrl:String!
    {
        get{ return stringForKey(key: "imageUrl")}
        set{setValue(newValue, forKey: "imageUrl")}
    }

}



enum extraModelKey:String {
    
    //Must variable
    case isread = "isread"
    case notificationAddedBy = "notificationAddedBy"
    case notificationTime = "notificationTime"
    case songId = "songId"
    case songTitle = "songTitle"
    case status = "status"
    case titleNotification = "titleNotification"

}

class extraModel: GenericDictionary {

    var isread:Bool!
    {
        get{ return boolForKey(key: extraModelKey.isread.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: extraModelKey.isread.rawValue)}
    }
    var status:Bool!
    {
        get{ return boolForKey(key: extraModelKey.status.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: extraModelKey.status.rawValue)}
    }
    var notificationAddedBy:String!
    {
        get{ return stringForKey(key: extraModelKey.notificationAddedBy.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.notificationAddedBy.rawValue)}
    }
    var notificationTime:Int64!
    {
        get{ return int64ForKey(key: extraModelKey.notificationTime.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.notificationTime.rawValue)}
    }
    
    var titleNotification:String!
    {
        get{ return stringForKey(key: extraModelKey.titleNotification.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.titleNotification.rawValue)}
    }
    
    var songTitle:String!
    {
        get{ return stringForKey(key: extraModelKey.songTitle.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.songTitle.rawValue)}
    }
    var songId:String!
    {
        get{ return stringForKey(key: extraModelKey.songId.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.songId.rawValue)}
    }

}


enum WritersSongKeys:String {
    
    //Must variable
    case userId = "userId"
    case verseText = "verseText"
    case isBrainStrom = "isBrainStrom"
    case verseTitle = "verseTitle"
    case verseIndex = "verseIndex"
    case verseTime = "verseTime"


}
class WritersSongModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: WritersSongKeys.userId.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.userId.rawValue)}
    }
    var verseText:String!
    {
        get{ return stringForKey(key: WritersSongKeys.verseText.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseText.rawValue)}
    }
    var verseTitle:String!
    {
        get{ return stringForKey(key: WritersSongKeys.verseTitle.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseTitle.rawValue)}
    }
    
    var verseTime:Int64!
    {
        get{ return int64ForKey(key: WritersSongKeys.verseTime.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseTime.rawValue)}
    }
    var verseIndex:Int64!
    {
        get{ return int64ForKey(key: WritersSongKeys.verseIndex.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseIndex.rawValue)}
    }
    var isBrainStrom:Bool!
    {
        get{ return boolForKey(key: WritersSongKeys.isBrainStrom.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: WritersSongKeys.isBrainStrom.rawValue)}
    }
}



enum QuestionsKey:String {
    
    //Must variableCategory    case Category = "userId"
    case Category = "Category"
    case Question = "Question"
    case Answer = "Answer"


}
class QuestionsModel: GenericDictionary {

    var Category:String!
    {
        get{ return stringForKey(key: QuestionsKey.Category.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.Category.rawValue)}
    }
    var Question:String!
    {
        get{ return stringForKey(key: QuestionsKey.Question.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.Question.rawValue)}
    }
    var Answer:String
    {
        get{ return stringForKey(key: QuestionsKey.Answer.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.Answer.rawValue)}
    }
}

enum NotesKeys:String {
    
    //Must variable
    
    case userId = "userId"
    case type = "type"
    case title = "title"
    case description = "description"
    case imageThumnail = "imageThumnail"
    case rating = "rating"
    case recommendation = "recommendation"
    case timestamp = "timestamp"
}


class NotesModel: GenericDictionary {
    
    
    var userId:String!
    {
        get{ return stringForKey(key: NotesKeys.userId.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.userId.rawValue)}
    }
    
    var title:String!
    {
        get{ return stringForKey(key: NotesKeys.title.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.title.rawValue)}
    }
    
    var descriptionDate:String!
    {
        get{ return stringForKey(key: NotesKeys.description.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.description.rawValue)}
    }
    
    var imageThumnail:String!
    {
        get{ return stringForKey(key: NotesKeys.imageThumnail.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.imageThumnail.rawValue)}
    }
    var timestamp:Int64!
    {
        get{ return int64ForKey(key: NotesKeys.timestamp.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.timestamp.rawValue)}
    }

    var type:String!
    {
        get{ return stringForKey(key: NotesKeys.type.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.type.rawValue)}
    }
    
    var rating:Double!
    {
        get{ return doubleForKey(key: NotesKeys.rating.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.rating.rawValue)}
    }

    var recommendation:String!
    {
        get{ return stringForKey(key: NotesKeys.recommendation.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.recommendation.rawValue)}
    }

    
}

enum DateKeys:String {
    
    //Must variable
    
    case userId = "userId"
    case type = "type"
    case title = "title"
    case description = "description"
    case imageThumnail = "imageThumnail"
    case rating = "rating"
    case cost = "cost"
    case location = "location"
    case recommendation = "recommendation"
    case scheduleDate = "scheduleDate"
    case scheldueTime = "scheldueTime"
    case dateLat = "dateLat"
    case timeStamp = "timeStamp"
    case dateLng = "dateLng"

}

class DateModel: GenericDictionary {
    
    
    var userId:String!
    {
        get{ return stringForKey(key: DateKeys.userId.rawValue)}
        set{setValue(newValue, forKey: DateKeys.userId.rawValue)}
    }
    
    var title:String!
    {
        get{ return stringForKey(key: DateKeys.title.rawValue)}
        set{setValue(newValue, forKey: DateKeys.title.rawValue)}
    }
    
    var descriptionDate:String!
    {
        get{ return stringForKey(key: DateKeys.description.rawValue)}
        set{setValue(newValue, forKey: DateKeys.description.rawValue)}
    }
    var imageThumnail:String!
    {
        get{ return stringForKey(key: DateKeys.imageThumnail.rawValue)}
        set{setValue(newValue, forKey: DateKeys.imageThumnail.rawValue)}
    }
    var cost:String!
    {
        get{ return stringForKey(key: DateKeys.cost.rawValue)}
        set{setValue(newValue, forKey: DateKeys.cost.rawValue)}
    }
    var timeStamp:Int64!
    {
        get{ return int64ForKey(key: DateKeys.timeStamp.rawValue)}
        set{setValue(newValue, forKey: DateKeys.timeStamp.rawValue)}
    }
    var type:String!
    {
        get{ return stringForKey(key: DateKeys.type.rawValue)}
        set{setValue(newValue, forKey: DateKeys.type.rawValue)}
    }
    
    var rating:Double!
    {
        get{ return doubleForKey(key: DateKeys.rating.rawValue)}
        set{setValue(newValue, forKey: DateKeys.rating.rawValue)}
    }
    var location:String!
    {
        get{ return stringForKey(key: DateKeys.location.rawValue)}
        set{setValue(newValue, forKey: DateKeys.location.rawValue)}
    }
    var recommendation:String!
    {
        get{ return stringForKey(key: DateKeys.recommendation.rawValue)}
        set{setValue(newValue, forKey: DateKeys.recommendation.rawValue)}
    }
    
    var scheldueTime:Int64!
    {
        get{ return int64ForKey(key: DateKeys.scheldueTime.rawValue)}
        set{setValue(newValue, forKey: DateKeys.scheldueTime.rawValue)}
    }
    
    var scheduleDate:Int64!
    {
        get{ return int64ForKey(key: DateKeys.scheduleDate.rawValue)}
        set{setValue(newValue, forKey: DateKeys.scheduleDate.rawValue)}
    }
    
    
    var dateLat:Double!
    {
        get{ return doubleForKey(key: DateKeys.dateLat.rawValue)}
        set{setValue(newValue, forKey: DateKeys.dateLat.rawValue)}
    }
    
    var dateLng:Double!
    {
        get{ return doubleForKey(key: DateKeys.dateLng.rawValue)}
        set{setValue(newValue, forKey: DateKeys.dateLng.rawValue)}
    }
    
    
}


enum TraditionDishKeys:String {
    
    //Must variable
    case country_id = "country_id"
    case date = "date"
    case image = "image"
    case name = "name"
    case rating = "rating"
    case visit = "visit"
    case isFav = "isFav"
    case ingredients = "ingredients"
    case descriptions = "descriptions"
    case notify = "notify"
    case type = "type"
    case price = "price"
}
class TraditionDishModel: GenericDictionary {

    var rest:RestaurantModel!
    var country_id:String!
    {
        get{ return stringForKey(key: TraditionDishKeys.country_id.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.country_id.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: TraditionDishKeys.image.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.image.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: TraditionDishKeys.name.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.name.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: TraditionDishKeys.date.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.date.rawValue)}
    }
    var isFav:[String:Bool]!
    {
        get{ return dictBoolForKey(key: TraditionDishKeys.isFav.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.isFav.rawValue)}
    }
    var rating:[Double]!
    {
        get{ return arrayDoubleForKey(key: TraditionDishKeys.rating.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.rating.rawValue)}
    }
    var visit:[String:Int64]!
    {
        get{ return dictInt64ForKey(key: TraditionDishKeys.visit.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.visit.rawValue)}
    }
    var notify:[String:Bool]!
    {
        get{ return dictBoolForKey(key: TraditionDishKeys.notify.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.notify.rawValue)}
    }
    var price:String!
    {
        get{ return stringForKey(key: TraditionDishKeys.price.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.price.rawValue)}
    }
    var descriptions:String!
    {
        get{ return stringForKey(key: TraditionDishKeys.descriptions.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.descriptions.rawValue)}
    }
    var ingredients:[String]!
    {
        get{ return stringArrayForKey(key: TraditionDishKeys.ingredients.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.ingredients.rawValue)}
    }
    var type:String!
    {
        get{ return stringForKey(key: TraditionDishKeys.type.rawValue)}
        set{setValue(newValue, forKey: TraditionDishKeys.type.rawValue)}
    }
}

enum DishKeys:String {
    
    //Must variable
    case userId = "userId"
    case date = "date"
    case image = "image"
    case name = "name"
    case country = "country"
    case res_id = "res_id"
    case rating = "rating"
    case visit = "visit"
    case isFav = "isFav"
    case diettype = "diettype"
    case foodtype = "foodtype"
    case city = "city"
    case ingredients = "ingredients"
    case descriptions = "descriptions"
    case notify = "notify"
    case Seasonal = "Seasonal"
    case Special = "Special"
    case Limited = "Limited"
    case category = "category"
    case price = "price"
}
class DishModel: GenericDictionary {

    var rest:RestaurantModel!
    var visits:[VisitModel]!
    var userId:String!
    {
        get{ return stringForKey(key: DishKeys.userId.rawValue)}
        set{setValue(newValue, forKey: DishKeys.userId.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: DishKeys.image.rawValue)}
        set{setValue(newValue, forKey: DishKeys.image.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: DishKeys.name.rawValue)}
        set{setValue(newValue, forKey: DishKeys.name.rawValue)}
    }
    var country:String!
    {
        get{ return stringForKey(key: DishKeys.country.rawValue)}
        set{setValue(newValue, forKey: DishKeys.country.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: DishKeys.date.rawValue)}
        set{setValue(newValue, forKey: DishKeys.date.rawValue)}
    }
    var res_id:String!
    {
        get{ return stringForKey(key: DishKeys.res_id.rawValue)}
        set{setValue(newValue, forKey: DishKeys.res_id.rawValue)}
    }
    var isFav:[String:Bool]!
    {
        get{ return dictBoolForKey(key: DishKeys.isFav.rawValue)}
        set{setValue(newValue, forKey: DishKeys.isFav.rawValue)}
    }
    var rating:[Double]!
    {
        get{ return arrayDoubleForKey(key: DishKeys.rating.rawValue)}
        set{setValue(newValue, forKey: DishKeys.rating.rawValue)}
    }
    var visit:[String:Int64]!
    {
        get{ return dictInt64ForKey(key: DishKeys.visit.rawValue)}
        set{setValue(newValue, forKey: DishKeys.visit.rawValue)}
    }
    var notify:[String:Bool]!
    {
        get{ return dictBoolForKey(key: DishKeys.notify.rawValue)}
        set{setValue(newValue, forKey: DishKeys.notify.rawValue)}
    }
    var diettype:[String]!
    {
        get{ return arrayStringForKey(key: DishKeys.diettype.rawValue)}
        set{setValue(newValue, forKey: DishKeys.diettype.rawValue)}
    }
    var foodtype:[String]!
    {
        get{ return arrayStringForKey(key: DishKeys.foodtype.rawValue)}
        set{setValue(newValue, forKey: DishKeys.foodtype.rawValue)}
    }
    var city:String!
    {
        get{ return stringForKey(key: DishKeys.city.rawValue)}
        set{setValue(newValue, forKey: DishKeys.city.rawValue)}
    }
    var price:String!
    {
        get{ return stringForKey(key: DishKeys.price.rawValue)}
        set{setValue(newValue, forKey: DishKeys.price.rawValue)}
    }
    var descriptions:String!
    {
        get{ return stringForKey(key: DishKeys.descriptions.rawValue)}
        set{setValue(newValue, forKey: DishKeys.descriptions.rawValue)}
    }
    var ingredients:[String]!
    {
        get{ return stringArrayForKey(key: DishKeys.ingredients.rawValue)}
        set{setValue(newValue, forKey: DishKeys.ingredients.rawValue)}
    }
    var Seasonal:Bool!
    {
        get{ return boolForKey(key: DishKeys.Seasonal.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: DishKeys.Seasonal.rawValue)}
    }
    var Limited:Bool!
    {
        get{ return boolForKey(key: DishKeys.Limited.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: DishKeys.Limited.rawValue)}
    }
    var Special:Bool!
    {
        get{ return boolForKey(key: DishKeys.Special.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: DishKeys.Special.rawValue)}
    }
    var category:String!
    {
        get{ return stringForKey(key: DishKeys.category.rawValue)}
        set{setValue(newValue, forKey: DishKeys.category.rawValue)}
    }
}
class CategorDish{
    var cateogry:DishCategorModel!
    var dishes:[DishModel]!
    init(cateogry: DishCategorModel? = nil, dishes: [DishModel]? = nil) {
        self.cateogry = cateogry
        self.dishes = dishes
    }
}
enum RestaurantKeys:String {
    
    //Must variable
    case userId = "userId"
    case address = "address"
    case lat = "lat"
    case lng = "lng"
    case image = "image"
    case details = "details"
    case name = "name"
    case phoneNumber = "phoneNumber"
    case pwd = "pwd"
    case uniqueid = "uniqueid"
    case website = "website"
    case date = "date"
    case rating = "rating"
    case visit = "visit"
    case expire_at = "expire_at"
    case association = "association"
    case isNotify = "isNotify"
    case isFav = "isFav"
    case city = "city"
    case notify = "notify"
    case plan = "plan"
    case planId = "planId"
    case category = "category"
}
class RestaurantModel: GenericDictionary {

    var dishes:[DishModel]!
    var visits:[VisitModel]!
    var userId:String!
    {
        get{ return stringForKey(key: RestaurantKeys.userId.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.userId.rawValue)}
    }
    var address:String!
    {
        get{ return stringForKey(key: RestaurantKeys.address.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.address.rawValue)}
    }
    var city:String!
    {
        get{ return stringForKey(key: RestaurantKeys.city.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.city.rawValue)}
    }
    
    var details:String!
    {
        get{ return stringForKey(key: RestaurantKeys.details.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.details.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: RestaurantKeys.date.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.date.rawValue)}
    }
    var planId:Int64!
    {
        get{ return int64ForKey(key: RestaurantKeys.planId.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.planId.rawValue)}
    }
    var name:String!
    {
        get{ return stringForKey(key: RestaurantKeys.name.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.name.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: RestaurantKeys.image.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.image.rawValue)}
    }
    var phoneNumber:String!
    {
        get{ return stringForKey(key: RestaurantKeys.phoneNumber.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.phoneNumber.rawValue)}
    }
    var pwd:String!
    {
        get{ return stringForKey(key: RestaurantKeys.pwd.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.pwd.rawValue)}
    }
    var uniqueid:String!
    {
        get{ return stringForKey(key: RestaurantKeys.uniqueid.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.uniqueid.rawValue)}
    }
    var website:String!
    {
        get{ return stringForKey(key: RestaurantKeys.website.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.website.rawValue)}
    }
    var rating:[Double]!
    {
        get{ return arrayDoubleForKey(key: RestaurantKeys.rating.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.rating.rawValue)}
    }
    var visit:[String:Int64]!
    {
        get{ return dictInt64ForKey(key: RestaurantKeys.visit.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.visit.rawValue)}
    }
    var isFav:[String:Bool]!
    {
        get{ return dictBoolForKey(key: RestaurantKeys.isFav.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.isFav.rawValue)}
    }
    var notify:[String:Bool]!
    {
        get{ return dictBoolForKey(key: RestaurantKeys.notify.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.notify.rawValue)}
    }
    var lat:Double!
    {
        get{ return doubleForKey(key: RestaurantKeys.lat.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.lat.rawValue)}
    }
    var lng:Double!
    {
        get{ return doubleForKey(key: RestaurantKeys.lng.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.lng.rawValue)}
    }
    var expire_at:String!
    {
        get{ return stringForKey(key: RestaurantKeys.expire_at.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.expire_at.rawValue)}
    }
    var association:Bool!
    {
        get{ return boolForKey(key: RestaurantKeys.association.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: RestaurantKeys.association.rawValue)}
    }
    var isNotify:Bool!
    {
        get{ return boolForKey(key: RestaurantKeys.isNotify.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: RestaurantKeys.isNotify.rawValue)}
    }
    var plan:String!
    {
        get{ return stringForKey(key: RestaurantKeys.plan.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.plan.rawValue)}
    }
    var category:[String]!
    {
        get{ return arrayStringForKey(key: RestaurantKeys.category.rawValue)}
        set{setValue(newValue, forKey: RestaurantKeys.category.rawValue)}
    }
}
enum ReviewKeys:String {
    
    case id = "id"
    case date = "date"
    case userId = "userId"
    case review = "review"
    case rating = "rating"
    case dis_id = "dis_id"
    case res_id = "res_id"
    
}

class ReviewModel: GenericDictionary {
    var dish:DishModel!
    var user:UserModel!
    var comment:[CommentModel]!
    var id:String!
    {
        get{ return stringForKey(key: ReviewKeys.id.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.id.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: ReviewKeys.date.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.date.rawValue)}
    }
    
    var userId:String!
    {
        get{ return stringForKey(key: ReviewKeys.userId.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.userId.rawValue)}
    }
    
    var review:String!
    {
        get{ return stringForKey(key: ReviewKeys.review.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.review.rawValue)}
    }
    
    var rating:Double!
    {
        get{ return doubleForKey(key: ReviewKeys.rating.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.rating.rawValue)}
    }
    
    var dis_id:String!
    {
        get{ return stringForKey(key: ReviewKeys.dis_id.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.dis_id.rawValue)}
    }
    var res_id:String!
    {
        get{ return stringForKey(key: ReviewKeys.res_id.rawValue)}
        set{setValue(newValue, forKey: ReviewKeys.res_id.rawValue)}
    }

}


enum ResReviewKeys:String {
    
    case id = "id"
    case date = "date"
    case userId = "userId"
    case rating = "rating"
    case dis_id = "dis_id"
    case res_id = "res_id"
    case review = "review"
    case Service = "Service"
    case FoodQuality = "Food Quality"
    case Ambience = "Ambience"
    case Cleanliness = "Cleanliness"
    case ValueforPrice = "Value for Price"
    case SpeedofService = "Speed of Service"
    case SpecialAccommodations = "Special Accommodations"
    case Location = "Location"
    case BeverageSelection = "Beverage Selection"
    case KidFriendliness = "Kid-Friendliness"
    case NoiseLevel = "Noise Level"
    case WifiQuality = "Wifi Quality"
    case ParkingEase = "Parking Ease"
    case MenuVariety = "Menu Variety"
    
}

class ResReviewModel: GenericDictionary {

    var user:UserModel!
    var id:String!
    {
        get{ return stringForKey(key: ResReviewKeys.id.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.id.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: ResReviewKeys.date.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.date.rawValue)}
    }
    
    var userId:String!
    {
        get{ return stringForKey(key: ResReviewKeys.userId.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.userId.rawValue)}
    }
    var review:String!
    {
        get{ return stringForKey(key: ResReviewKeys.review.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.review.rawValue)}
    }
    var rating:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.rating.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.rating.rawValue)}
    }
    
    var dis_id:String!
    {
        get{ return stringForKey(key: ResReviewKeys.dis_id.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.dis_id.rawValue)}
    }
    var res_id:String!
    {
        get{ return stringForKey(key: ResReviewKeys.res_id.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.res_id.rawValue)}
    }
    var Service:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.Service.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.Service.rawValue)}
    }
    var FoodQuality:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.FoodQuality.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.FoodQuality.rawValue)}
    }
    var Ambience:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.Ambience.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.Ambience.rawValue)}
    }
    var Cleanliness:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.Cleanliness.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.Cleanliness.rawValue)}
    }
    var ValueforPrice:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.ValueforPrice.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.ValueforPrice.rawValue)}
    }
    var MenuVariety:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.MenuVariety.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.MenuVariety.rawValue)}
    }
    var SpeedofService:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.SpeedofService.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.SpeedofService.rawValue)}
    }
    var Location:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.Location.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.Location.rawValue)}
    }
    var SpecialAccommodations:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.SpecialAccommodations.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.SpecialAccommodations.rawValue)}
    }
    var BeverageSelection:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.BeverageSelection.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.BeverageSelection.rawValue)}
    }
    var KidFriendliness:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.KidFriendliness.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.KidFriendliness.rawValue)}
    }
    var NoiseLevel:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.NoiseLevel.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.NoiseLevel.rawValue)}
    }
    var WifiQuality:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.WifiQuality.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.WifiQuality.rawValue)}
    }
    var ParkingEase:Double!
    {
        get{ return doubleForKey(key: ResReviewKeys.ParkingEase.rawValue)}
        set{setValue(newValue, forKey: ResReviewKeys.ParkingEase.rawValue)}
    }

}

enum FoodTypeKeys:String {
    
    case id = "id"
    case name = "name"
    case image = "image"
    
    
}

class FoodTypeModel: GenericDictionary {

    var id:String!
    {
        get{ return stringForKey(key: FoodTypeKeys.id.rawValue)}
        set{setValue(newValue, forKey: FoodTypeKeys.id.rawValue)}
    }
    var name:String!
    {
        get{ return stringForKey(key: FoodTypeKeys.name.rawValue)}
        set{setValue(newValue, forKey: FoodTypeKeys.name.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: FoodTypeKeys.image.rawValue)}
        set{setValue(newValue, forKey: FoodTypeKeys.image.rawValue)}
    }
    var isSelected:Bool! = false
}
enum DietTypeKeys:String {
    
    case id = "id"
    case name = "name"
    case image = "image"
}

class DietTypeModel: GenericDictionary {

    var id:String!
    {
        get{ return stringForKey(key: DietTypeKeys.id.rawValue)}
        set{setValue(newValue, forKey: DietTypeKeys.id.rawValue)}
    }
    var name:String!
    {
        get{ return stringForKey(key: DietTypeKeys.name.rawValue)}
        set{setValue(newValue, forKey: DietTypeKeys.name.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: DietTypeKeys.image.rawValue)}
        set{setValue(newValue, forKey: DietTypeKeys.image.rawValue)}
    }
    var isSelected:Bool! = false

}
enum DishCategorKeys:String {
    
    case id = "id"
    case name = "name"
}

class DishCategorModel: GenericDictionary {

    var id:String!
    {
        get{ return stringForKey(key: DishCategorKeys.id.rawValue)}
        set{setValue(newValue, forKey: DishCategorKeys.id.rawValue)}
    }
    var name:String!
    {
        get{ return stringForKey(key: DishCategorKeys.name.rawValue)}
        set{setValue(newValue, forKey: DishCategorKeys.name.rawValue)}
    }
    var isSelected:Bool! = false
}
enum VisitKeys:String {
    
    case id = "id"
    case date = "date"
    case userId = "userId"
    case visit = "visit"
    case dis_id = "dis_id"
    case res_id = "res_id"
    
}

class VisitModel: GenericDictionary {
    var dish:DishModel!
    var rest:RestaurantModel!
    var user:UserModel!
    var comment:[CommentModel]!
    var id:String!
    {
        get{ return stringForKey(key: VisitKeys.id.rawValue)}
        set{setValue(newValue, forKey: VisitKeys.id.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: VisitKeys.date.rawValue)}
        set{setValue(newValue, forKey: VisitKeys.date.rawValue)}
    }
    
    var userId:String!
    {
        get{ return stringForKey(key: VisitKeys.userId.rawValue)}
        set{setValue(newValue, forKey: VisitKeys.userId.rawValue)}
    }
    var visit:Int64!
    {
        get{ return int64ForKey(key: VisitKeys.visit.rawValue)}
        set{setValue(newValue, forKey: VisitKeys.visit.rawValue)}
    }
    
    var dis_id:String!
    {
        get{ return stringForKey(key: VisitKeys.dis_id.rawValue)}
        set{setValue(newValue, forKey: VisitKeys.dis_id.rawValue)}
    }
    var res_id:String!
    {
        get{ return stringForKey(key: VisitKeys.res_id.rawValue)}
        set{setValue(newValue, forKey: VisitKeys.res_id.rawValue)}
    }

}
enum SubcribKeys:String {
    
    case id = "id"
    case subName = "subName"
    case startDate = "startDate"
    case endDate = "endDate"
    case subType = "subType"
    case userId = "userId"
    case restId = "restId"
    case price = "price"
}

class SubcribModel: GenericDictionary {

    var id:String!
    {
        get{ return stringForKey(key: SubcribKeys.id.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.id.rawValue)}
    }
    var subName:String!
    {
        get{ return stringForKey(key: SubcribKeys.subName.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.subName.rawValue)}
    }
    var startDate:String!
    {
        get{ return stringForKey(key: SubcribKeys.startDate.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.startDate.rawValue)}
    }
    var endDate:String!
    {
        get{ return stringForKey(key: SubcribKeys.endDate.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.endDate.rawValue)}
    }
    var subType:String!
    {
        get{ return stringForKey(key: SubcribKeys.subType.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.subType.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: SubcribKeys.userId.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.userId.rawValue)}
    }
    var restId:String!
    {
        get{ return stringForKey(key: SubcribKeys.restId.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.restId.rawValue)}
    }

    var price:String!
    {
        get{ return stringForKey(key: SubcribKeys.price.rawValue)}
        set{setValue(newValue, forKey: SubcribKeys.price.rawValue)}
    }
}
enum OrderKeys:String {
    
    case id = "id"
    case userId = "userId"
    case restId = "restId"
    case date = "date"
}

class OrderModel: GenericDictionary {

    var id:String!
    {
        get{ return stringForKey(key: OrderKeys.id.rawValue)}
        set{setValue(newValue, forKey: OrderKeys.id.rawValue)}
    }
    var date:Int64!
    {
        get{ return int64ForKey(key: OrderKeys.date.rawValue)}
        set{setValue(newValue, forKey: OrderKeys.date.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: OrderKeys.userId.rawValue)}
        set{setValue(newValue, forKey: OrderKeys.userId.rawValue)}
    }
    var restId:String!
    {
        get{ return stringForKey(key: OrderKeys.restId.rawValue)}
        set{setValue(newValue, forKey: OrderKeys.restId.rawValue)}
    }
}
class YelpRestModel: Codable {
    
    var name: String!
    var image_url: String!
    var url: String!
    var review_count: Int64!
    var categories: [String]!
    var rating: Double!
    var lat: Double!
    var lng: Double!
    var price: String!
    var location: String!
    var city: String!
    var country: String!
    var display_phone: String!
    
    enum CodingKeys: String, CodingKey {
        
      
        case name = "name"
        case image_url = "image_url"
        case url = "url"
        case review_count = "review_count"
        case categories = "categories"
        case rating = "rating"
        case lat = "lat"
        case lng = "lng"
        case price = "price"
        case location = "location"
        case city = "city"
        case country = "country"
        case display_phone = "display_phone"
    }

    init( Zip: String? = nil,City: String? = nil,profilid: String? = nil,Image:String? = nil,allreadyChattet:Bool? = nil) {
    }
    
    init?(dic:NSDictionary) {
        
        var name = dic[CodingKeys.name.rawValue] as? String
        let image_url = dic[CodingKeys.image_url.rawValue] as? String
        var url = dic[CodingKeys.url.rawValue] as? String
        let review_count = dic[CodingKeys.review_count.rawValue] as? Int64
        var rating = dic[CodingKeys.rating.rawValue] as? Double
        let price = dic[CodingKeys.price.rawValue] as? String
        var display_phone = dic[CodingKeys.display_phone.rawValue] as? String
        
        if let categories = dic[CodingKeys.categories.rawValue] as? NSArray{
            var cats = [String]()
            for cat in categories{
                if let catdic = cat as? NSDictionary{
                    if let title = catdic["title"] as? String{
                        cats.append(title)
                    }
                    
                }
            }
            self.categories = cats
        }
        
        if let coordinates = dic["coordinates"] as? NSDictionary{
            self.lat = coordinates["latitude"] as? Double
            self.lng = coordinates["longitude"] as? Double
        }
        if let location = dic[CodingKeys.location.rawValue] as? NSDictionary{
            self.location = location["address1"] as? String
            self.city = location["city"] as? String
            self.country = location["country"] as? String
        }
        
        self.name = name
        self.image_url = image_url
        self.url = url
        self.review_count = review_count
        self.rating = rating
        self.price = price
        self.display_phone = display_phone
    
    }
    
}
