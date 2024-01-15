//
//  AppDelegate.swift
//  nearFeast
//
//  Created by Mac on 16/11/2023.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseMessaging
import FirebaseInstallations
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Stripe
import LGSideMenuController
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Thread.sleep(forTimeInterval: 2.0)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        //IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage(named: "downkey1")!
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        Settings.shared.appID = "1299727658089645"
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        GMSPlacesClient.provideAPIKey("AIzaSyCbcCXfwETkPdwlwN_7XsAWSbg9qwM1Esk")
        GMSServices.provideAPIKey("AIzaSyCbcCXfwETkPdwlwN_7XsAWSbg9qwM1Esk")
        StripeAPI.defaultPublishableKey = "pk_test_51J0sDpAipe2se0swWiidN25GFd2KYshpvLRRo0I0uRqGdEwdPRn75HNu7Cdz4RcJZTmuaFVzoTWhprhLMxYzye5W00ryRzQxH5"
        return true
    }
    func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handled
      }
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
        
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken
        print ("ashdgjasjda" ,  deviceToken )
        print("Device Token: \(token)")
    }
    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        if FirebaseData.getCurrentUserId().1{
            FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
                guard let user = userData else{return}
                if !user.isStay{
                    FirebaseData.logout()
                }
            }
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        if FirebaseData.getCurrentUserId().1{
            FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
                guard let user = userData else{return}
                if !user.isStay{
                    FirebaseData.logout()
                }
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        if FirebaseData.getCurrentUserId().1{
            FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
                guard let user = userData else{return}
                if !user.isStay{
                    FirebaseData.logout()
                }
            }
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        if FirebaseData.getCurrentUserId().1{
            FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
                guard let user = userData else{return}
                if !user.isStay{
                    FirebaseData.logout()
                }
            }
        }
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "nearFeast")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate{
    
    func setUpAppNotifications() {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        self.registerForPushNotifications()
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                let types:UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: types, categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
                NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)) , name: .MessagingRegistrationTokenRefreshed, object: nil)
            }
        }
    }
    @objc func refreshToken(notification : NSNotification) {
        Installations.installations().installationID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result)")
            }
        }
    }
}
//MARK:- NOTIFICATION DELEGATES METHOD'S
extension AppDelegate:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.identifier == "Local Notification Order" {
            print("Handling notifications with the Local Notification Identifier")
            center.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
            center.removePendingNotificationRequests(withIdentifiers: [notification.request.identifier])
            
            
        }
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        let userInfo = notification.request.content.userInfo
        
        
        
        
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(UNNotificationPresentationOptions([]))
            return
        }
        print ("the user info is " , userInfo )
        if let message_type = userInfo["type"] as? String{
            switch NotificationType(rawValue: message_type) {
            case .visit:
                NotificationCenter.default.post(name: .visit, object: nil, userInfo: userInfo)
            
            default:
                break
            }
        }
        completionHandler(UNNotificationPresentationOptions([.badge,.sound,.banner]))
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
        if UIApplication.shared.applicationIconBadgeNumber > 0{
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
        }
        let userInfo = response.notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler()
            return
        }
        print ("the user info is " , userInfo )
        if let message_type = userInfo["type"] as? String{
            switch NotificationType(rawValue: message_type) {
            case .visit:
                let vc = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
                UIApplication.shared.windows.first?.rootViewController = vc
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    NotificationCenter.default.post(name: .visit, object: nil, userInfo: userInfo)
                }
            default:
                break
            }
        }
        completionHandler()
        
    }

    @objc func userNotify(){
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
                return
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                return
            }
        }
        let content = UNMutableNotificationContent() // Содержимое уведомления
        content.title = "TastyBox"
        content.body = "Your Order Ready please collect it now"
        content.sound = UNNotificationSound.default
        content.badge = 1
        let date = Date(timeIntervalSinceNow: 1800)
        let triggerHourly = Calendar.current.dateComponents([.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerHourly, repeats: true)
        let identifier = "Local Notification Order"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        notificationCenter.delegate = self
    }
}
