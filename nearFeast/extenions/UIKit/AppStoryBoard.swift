//
//  AppStoryBoard.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

class AppStoryBoard: NSObject {

}
extension UIStoryboard {
    
    //MARK:- Generic Public/Instance Methods
    
    func loadViewController(withIdentifier identifier: viewControllers) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
    
    //MARK:- Class Methods to load Storyboards
    
    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
    class func storyBoard(withTextName name:String) -> UIStoryboard {
        return UIStoryboard(name: name , bundle: Bundle.main)
    }
    
}

enum storyboards : String {
    case login = "Registration",
    leftMenu = "LeftMenu",
    home = "Home",
    profile = "Profile",
         explore = "Explore",
    partner = "Partner",
    account = "Account",
    dashboard = "Dashboard",
    messages = "Messages",
    sales = "Sales",
    popUps = "PopUps",
    main = "Main"
}



//navLoginVC = "navLoginVC",
//navLeftMenuVC = "navLeftMenuVC",
//leftMenuVC = "LeftMenuVC",
//navHomeVC = "navHomeVC",
//homeVC = "HomeVC",
//swRevealViewController = "SWRevealViewController",
//homeDetailVC = "HomeDetailVC",
enum viewControllers: String {
    
    //Login Storyboard
    case LoginViewController = "LoginViewController",
         LGSideMenuController = "LGSideMenuController",
         SignUpViewController = "SignUpViewController",
         ReviewReplyViewController = "ReviewReplyViewController",
         EditProfileViewController = "EditProfileViewController",
    
         MyReviewViewController = "MyReviewViewController",
    
         ExploreDetailViewController = "ExploreDetailViewController",
    
         ProductDetailViewController = "ProductDetailViewController",
         DishDetailViewController = "DishDetailViewController",
         TraditionalDishViewController = "TraditionalDishViewController",
         CustomerReviewViewController = "CustomerReviewViewController",
         CustomerTraditionalReviewViewController = "CustomerTraditionalReviewViewController",
         CustomerDetailReviewViewController = "CustomerDetailReviewViewController",
         AlertRestaurantViewController = "AlertRestaurantViewController",
         RestaurantViewController = "RestaurantViewController",
    
         RestaurantReviewViewController = "RestaurantReviewViewController",
    
         FilterViewController = "FilterViewController",
         AddCardViewController = "AddCardViewController",
         subscribeViewViewController = "subscribeViewViewController",
         EditReviewViewController = "EditReviewViewController",
         MyRestaurantViewController = "MyRestaurantViewController",
         ResReviewReplyViewController = "ResReviewReplyViewController",
    FavProifleRestViewController = "FavProifleRestViewController",
    FingerPrintViewController = "FingerPrintViewController",
    ChangePasswordViewController = "ChangePasswordViewController",
         ProfileFavDishViewController = "ProfileFavDishViewController",
         RecentSearchViewController = "RecentSearchViewController",
         NotificationViewController = "NotificationViewController",
         AllNotificationViewController = "AllNotificationViewController",
         PrivacyViewController = "PrivacyViewController",
         TermsViewController = "TermsViewController",
         CustomerServiceViewController = "CustomerServiceViewController",
         MyRespondViewController = "MyRespondViewController",
         FeedbackViewController = "FeedbackViewController",
         AccountSettingViewController = "AccountSettingViewController",
         PrivacySettingViewController = "PrivacySettingViewController",
         AllYelpViewController = "AllYelpViewController"
}
