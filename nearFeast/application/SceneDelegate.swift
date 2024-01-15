//
//  SceneDelegate.swift
//  nearFeast
//
//  Created by Mac on 16/11/2023.
//

import UIKit
import LGSideMenuController
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        checkUserAlreadyLogin()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
//        if FirebaseData.checkLogin(){
//            if FirebaseData.getCurrentUserId().1{
//                let cdate = Date()
//                let calendar = Calendar.current
//                FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { errorr, model in
//                    if let errorr = errorr {
//                        
//                    }
//                    else{
//                        guard let model = model else{return}
//                        if model.isBio{
//                            if let time = model.sessionTime {
//                                
//                                let timeStamp2 = Int64(time)
//                                let dbDate = time.getInt64toTime()
//                                let minuteDiff = calendar.dateComponents([.minute], from: dbDate, to: cdate)
//                                let mindiff = minuteDiff.minute ?? 0
//                                
//                                if mindiff >= 1{
//                                    let controller = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController)
//                                    self.window?.rootViewController = controller
//                                    return
//                                }
//                            }
//                        }
//                        else{
//                            FirebaseData.logout()
//                        }
//                    }
//                }
//            }
//            else{
//                let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
//                self.window?.rootViewController = controller
//            }
//        }
        print("Enter")
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {

        print("exit")
//        if FirebaseData.checkLogin(){
//            if FirebaseData.getCurrentUserId().1{
//                let ctime = Date().milisecondInt64
//                let usermodel = UserModel()
//                usermodel.sessionTime = ctime
//                FirebaseData.updateUserData(FirebaseData.getCurrentUserId().0, dic: usermodel.dictionary) { error in
//                    print("exit Done")
//                }
//            }
//            else{
//                
//            }
//        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate{
    func checkUserAlreadyLogin(_ controllers: UINavigationController? = nil) {
        
        //try? Auth.auth().signOut()
        if FirebaseData.checkLogin(){
            let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
            self.window?.rootViewController = controller
        }else{
            FirebaseData.loginAnonymusUserData { error in
                if let error = error{
                    let controller = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController)
                    self.window?.rootViewController = controller
                    return
                }
                let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
                self.window?.rootViewController = controller
                if let controll = controllers{
                    controller.present(controll, animated: true, completion: nil)
                }
            }
            
        }
        self.window?.makeKeyAndVisible()
    }
}
//if FirebaseData.getCurrentUserId().1{
//    PopupHelper.showAnimating(self.window!.rootViewController!)
//    FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId().0) { error, userData in
//        if let error = error{
//            FirebaseData.loginAnonymusUserData { error in
//                if let error = error{
//                    let controller = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController)
//                    self.window?.rootViewController = controller
//                    return
//                }
//                let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
//                self.window?.rootViewController = controller
//                if let controll = controllers{
//                    controller.present(controll, animated: true, completion: nil)
//                }
//            }
//            return
//        }
//        guard let user = userData else {return}
//        if user.isBio{
//            let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
//            self.window?.rootViewController = controller
//        }
//        else{
//            let controller = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController)
//            self.window?.rootViewController = controller
//        }
//    }
//}
//else{
//    let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
//    self.window?.rootViewController = controller
//}
