//
//  Enums.swift
//  yahlove
//
//  Created by Buzzware Tech on 22/11/2022.
//

import UIKit

class Enums {

    
}
enum UserRole:String{
    case user,admin
}
enum NotificationType:String{
    case visit
}
enum SubscriptionPlan:String{
    case BasicPlan = "Basic Plan",PremiumPlan = "Premium Plan",ProPlan = "Pro Plan"
}
enum Gender:String{
    case male,female
}
enum InviteStatus:String{
    case requested,accepted,rejected
}
enum editprofileType:String{
    case image,tf,switched
}
enum ChatType:String{
    case one,many
}
enum MessageType:String{
    case text,image,voice
}
enum FilterType:String{
    case Location, Distance, TypeofFood = "Type of Food" , SortDishesBy = "Sort Dishes By", DietaryPreference = "Dietary Preference", SortRestaurantsBy = "Sort Restaurants By", Ratings
}

enum ProfileMenu:String,CaseIterable{
    case EditAcccount = "Edit Profile",MyReviews = "My Reviews",FavoriteRestaurants = "Favorite Restaurants",FavoriteDishes = "Favorite Dishes",RecentSearches = "Recent Searches",DeleteAcccount = "Delete Acccount",ChangePassword = "Change Password",BiometricAuth = "Biometric Authentication Settings",ListARestaurant = "List A Restaurant",ManageRestaurantListings = "Manage Restaurant Listings",ViewandRespondtoReviews = "View and Respond to Reviews",NotificatonPreferences = "Notificaton Preferences", PrivacySettings = "Privacy Settings",AccountSettings = "Account Settings",HelpCenter = "Help Center",ContactSupport = "Contact Support",SubmitFeedback = "Submit Feedback",FAQs = "FAQs",TermsofService = "Terms of Service", PrivacyPolicy = "Privacy Policy"
}
enum ProfileMenuSection:String,CaseIterable{
    case MyProfile = "My Profile",MyActivity = "My Activity",MyRestaurants = "My Restaurants",Settings = "Settings",SupportFeedback = "Support & Feedback",Legal = "Legal"
}
enum MediaType:String{
    case image = "public.image",video = "public.movie"
}
enum Weekdays:String,CaseIterable{
    case Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
}
enum ReviewGrade:String,CaseIterable{
    case Poor,Fair,Good,Verygood = "Very good",Excellent
}
enum Dishby:String{
    case Popularity,Rating,Distance,Price,Newest
}

enum EditProfileTxtIndex: Int,CaseIterable {
    case name = 0
    case email = 1
    case dateOfBirth = 2
    case location = 3
    case password = 4
}
enum EditProfileSwtchIndex: Int,CaseIterable {
    case hideFollowing = 0
    case hideFollowers = 1
}
