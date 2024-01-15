//
//  FirebaseData.swift
//  MyReferral
//
//  Created by vision on 14/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseMessaging
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import LGSideMenuController
class FirebaseData{
    class func signinGoogle(controller: UIViewController, completion:@escaping (_ error:Error?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.prepareForInterfaceBuilder()
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: controller){ user, error in
            
            if error != nil {
                completion(error)
                return
              }

              guard
                let users = user
              else {
                completion(NSError(domain:"Not Exist", code:0, userInfo:nil))
                return
              }
            let user = users.user
            let idToken = user.idToken?.tokenString
            let accessToken = user.accessToken.tokenString
            let dataDic = UserModel()
            dataDic.userName = user.profile?.name
            dataDic.email = user.profile?.email
            dataDic.image = user.profile?.imageURL(withDimension: 200)?.absoluteString
            dataDic.token = Messaging.messaging().fcmToken
            dataDic.authToken = idToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                             accessToken: accessToken)
            self.loginAuthUserData(token: credential){result,error in
                if let error = error{
                    completion(error)
                }
                else{
                    guard let user = result else {return}
                    self.getUserData(uid: user.user.uid) { error, userData in
                        if error != nil{
                            
                            dataDic.userRole = UserRole.user.rawValue
                            dataDic.userDate = Date().milisecondInt64
                            dataDic.deviceType = "IOS"
                            dataDic.isActive = true
                            dataDic.isAdminVerify = true
                            dataDic.isNotify = true
                            dataDic.isRestaurantNotify = true
                            dataDic.isReviewNotify = true
                            dataDic.isBio = true
                            dataDic.isStay = false
                            //dataDic.isAnonymus = false
//                            if let control = controller as? LoginViewController{
//                                dataDic.address = control.location.address
//                                dataDic.lat = control.location.addressLat
//                                dataDic.lng = control.location.addressLng
//                            }
                            self.saveUserData(uid: user.user.uid, userData: dataDic, completion: completion)
                        }
                        else{
                            self.checkUserData() { error,users in
                                if let error = error{
                                    completion(error)
                                }
                                else{
                                    guard let userss = users else {return}
                                    if let userName = userss.userName,!userName.isEmpty{
                                        dataDic.userName = userName
                                    }
                                    if let image = userss.image,!image.isEmpty{
                                        dataDic.image = image
                                    }
                                    self.updateUserData(user.user.uid, dic: dataDic, completion: completion)
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
    class func reAuthGoogle(controller: UIViewController, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.prepareForInterfaceBuilder()
        GIDSignIn.sharedInstance.configuration = config
        if GIDSignIn.sharedInstance.hasPreviousSignIn(){
            if let user = GIDSignIn.sharedInstance.currentUser{
                //let user = users.user
                let idToken = user.idToken?.tokenString
                let accessToken = user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                                 accessToken: accessToken)
                self.reAuthUserData(token: credential, completion: completion)
            }
        }
        else{
            GIDSignIn.sharedInstance.signIn(withPresenting: controller){ user, error in
                if let error = error{
                    completion(nil,error)
                }
                else{
                    guard let users = user
                    else {
                      completion(nil,NSError(domain:"Not Exist", code:0, userInfo:nil))
                      return
                    }
                    let user = users.user
                    let idToken = user.idToken?.tokenString
                    let accessToken = user.accessToken.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                                     accessToken: accessToken)
                    self.reAuthUserData(token: credential, completion: completion)
                    
                }
            }
        }
    }
    class func reAuthFacebook(controller:UIViewController,completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()){
        
        if let tokenString = AccessToken.current?.tokenString{
            let credential = FacebookAuthProvider
                .credential(withAccessToken: tokenString)
            self.reAuthUserData(token: credential,completion: completion)
        }
        else{
            if Utility.sharedInstance.isInternetAvailable(){
                let loginManager = LoginManager()
                if AccessToken.isCurrentAccessTokenActive{
                    loginManager.logOut()
                }

                loginManager.logIn(permissions: ["public_profile", "email"/*,"birthday","hometown","profile_pic"*/], from: controller) { (loginResult, error) in
                    if let erro = error{
                        print(erro)
                        completion(nil,erro)
                    }
                    else{
                        if let tokenString = AccessToken.current?.tokenString{
                            let credential = FacebookAuthProvider
                                .credential(withAccessToken: tokenString)
                            self.reAuthUserData(token: credential,completion: completion)
                        }
                    }
                }
            }
            else{
                completion(nil,NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("You are not connected to the internet. Please check your connection", comment: "")]))
            }
        }
        
    }
    class func signinFacebook(controller:UIViewController,completion:@escaping (_ error:Error?) -> ()){
        if Utility.sharedInstance.isInternetAvailable(){
            let loginManager = LoginManager()
            if AccessToken.isCurrentAccessTokenActive{
                loginManager.logOut()
            }

            loginManager.logIn(permissions: ["public_profile", "email"/*,"birthday","hometown","profile_pic"*/], from: controller) { (loginResult, error) in
                if let erro = error{
                    print(erro)
                    completion(erro)
                }
                else{
                    self.getFBUserData(controller: controller,completion: completion)
                }
            }
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("You are not connected to the internet. Please check your connection", comment: "")]))
        }
    }
    class func getFBUserData(controller:UIViewController,completion:@escaping (_ error:Error?) -> ()){


        if AccessToken.current != nil{
            let credential = FacebookAuthProvider
                .credential(withAccessToken: AccessToken.current!.tokenString)
            self.loginAuthUserData(token: credential){result,error in
                if let error = error{
                    completion(error)
                }
                else{
                    guard let user = result else {return}
                    GraphRequest(graphPath: "me",parameters: ["fields": "id,email,name,first_name,last_name,friends, birthday, cover, devices,picture.type(large)"]).start{connection,result,error in
                        if (error == nil){
                            
                            let dict = result as! [String : AnyObject]
                            print(result!)
                            var dataDic = UserModel()
                            if let u_id = dict["id"] as? String{
                                dataDic.authToken = u_id
                                
                            }
                            if let u_fname = dict["name"] as? String{
                                
                                dataDic.userName = u_fname
                            }
                            if let u_email = dict["email"] as? String{
                                
                                dataDic.email = u_email
                            }
                            if let pic_dic = dict["picture"] as? [String:Any]{
                                if let data = pic_dic["data"] as? [String:Any]{
                                    if let url = data["url"] as? String{
                                        
                                        dataDic.image = url
                                    }
                                }
                                
                            }
                            dataDic.token = Messaging.messaging().fcmToken
                            
                            
                            //dataDic.category = UserCategory.TattooArtist.rawValue
                            self.getUserData(uid: user.user.uid) { error, userData in
                                if error != nil{
                                    dataDic.deviceType = "IOS"
                                    dataDic.userRole = UserRole.user.rawValue
                                    dataDic.userDate = Date().milisecondInt64
                                    dataDic.isActive = true
                                    dataDic.isAdminVerify = true
                                    dataDic.isNotify = true
                                    dataDic.isRestaurantNotify = true
                                    dataDic.isReviewNotify = true
                                    dataDic.isBio = true
                                    dataDic.isStay = false
                                    //dataDic.isAnonymus = false
//                                    if let control = controller as? LoginViewController{
//                                        dataDic.address = control.location.address
//                                        dataDic.lat = control.location.addressLat
//                                        dataDic.lng = control.location.addressLng
//                                    }
                                    self.saveUserData(uid: user.user.uid, userData: dataDic, completion: completion)
                                }
                                else{
                                    self.checkUserData() { error,users in
                                        if let error = error{
                                            completion(error)
                                        }
                                        else{
                                            guard let userss = users else {return}
                                            if let userName = userss.userName,!userName.isEmpty{
                                                dataDic.userName = userName
                                            }
                                            if let image = userss.image,!image.isEmpty{
                                                dataDic.image = image
                                            }
                                            self.updateUserData(user.user.uid, dic: dataDic, completion: completion)
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        else{
                            
                            completion(error)
                        }
                    }
                    
                    
                }
            }
            
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("user cancelled", comment: "")]))
        }
    }
    class func reAuthApple(controller:UIViewController,completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()){
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                    
                    break
                case "google.com":
                    print("user is signed in with google")
                    
                    break
                case "password":
                    print("user is signed in with email")
                    
                    break
                case "phone":
                    print("user is signed in with phone")
                    
                    break
                case "apple.com":
                    print("user is signed in with appple")
                    
                    break
                default:
                    print("user is signed in with \(userInfo.providerID)")
                    break
                }
            }
        }
        
    }
    class func createPhoneUser(phone: String? = nil, credential: String? = nil,codes:String? = nil, completion:@escaping (_ user:UserModel? ,_ code:String?,_ error:Error?) -> ()) {
        if let pho = phone{
            PhoneAuthProvider.provider().verifyPhoneNumber(pho, uiDelegate: nil) { code, error in
                if error != nil{
                    completion(nil,nil,error)
                    return
                }
                completion(nil,code,nil)
            }
        }
        else if let cred = credential,let code = codes{
            let credential = PhoneAuthProvider.provider().credential(
              withVerificationID: cred,
              verificationCode: code
            )
            Auth.auth().signIn(with: credential) { user, error in
                if error != nil{
                    completion(nil,nil,error)
                    return
                }
                self.getUserData(uid: (user?.user.uid)!) { error, users in
                    if error != nil{
                        completion(nil,nil,error)
                        return
                    }
                    if users?.userName == nil{
                        self.saveUserData(uid: (user?.user.uid)!, userData: UserModel()) { error in
                            if error != nil{
                                completion(nil,nil,error)
                                return
                            }
                            completion(nil,nil,nil)
                        }
                    }
                    else{
                        completion(users,nil,nil)
                    }
                }
            }
        }
    }
    class func createEmailUser(email: String, password: String,usermodel:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth()
        
        db.createUser(withEmail: email, password: password){ user, error in
            if error != nil{
                completion(error)
            }
            else{
                if let user = user{
                    self.saveUserData(uid: user.user.uid, userData: usermodel) { error in
                        if error != nil{
                            completion(error)
                        }
                        else{
                            completion(nil)
                        }
                        
                    }
                }
                else{
                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
                }
                
            }
            
        }
        
    }
    class func deleteAccount(uid:String,completion:@escaping (_ error:Error?) -> ()){
        var mAuth = Auth.auth()
        mAuth.currentUser?.delete(completion: { error in
          if let error = error{
            completion(error)
          }
          else{
            completion(nil)
          }
        })
      }
    class func deleteUserData(uid:String,completion:@escaping (_ error:Error?) -> ()){

        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).document(uid).delete { error in
          if let error = error{
            completion(error)
          }
          else{
            completion(nil)
          }
        }
      }
    
    class func logoutUserData(_ completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth()
        do {
            try db.signOut()
        completion(nil)
        }
        catch let error{
        completion(error)
        }
    }
    class func loginUserData(email: String, password: String, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        
        db.signIn(withEmail: email, password: password, completion: completion)
        
    }
    class func loginUserData(email: String, password: String, completion:@escaping (_ error:Error?,_ user:UserModel?) -> ()) {
        let db = Auth.auth()
        
        db.signIn(withEmail: email, password: password){result,error in
            if let error =  error{
                completion(error,nil)
            }
            else{
                if let user = result{
                    self.checkUserData(completion: completion)
                }
                else{
                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]),nil)
                }
            }
        }
        
    }
    class func loginAnonymusUserData(_ completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth()
        db.signInAnonymously{result,error in
            if let error =  error{
                completion(error)
            }
            else{
                completion(nil)
//                if let user = result{
//                    var dataDic = [String:Any]()
//                    dataDic[UserKeys.token.rawValue] = Messaging.messaging().fcmToken
//                    dataDic[UserKeys.userRole.rawValue] = UserRole.user.rawValue
//                    dataDic[UserKeys.userDate.rawValue] = Date().milisecondInt64
//                    dataDic[UserKeys.deviceType.rawValue] = "IOS"
//                    dataDic[UserKeys.isActive.rawValue] = true
//                    dataDic[UserKeys.isAdminVerify.rawValue] = false
//                    dataDic[UserKeys.isAnonymus.rawValue] = true
//                    self.saveUserData(uid: user.user.uid, userData: dataDic, completion: completion)
//                }
//                else{
//                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
//                }
            }
        }
        
    }
    class func loginAuthUserData(token: AuthCredential, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        
        db.signIn(with: token,completion: completion)
        
    }
    class func reAuthUserData(token: AuthCredential, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        if let user = db.currentUser{
            user.reauthenticate(with: token,completion: completion)
        }
        else{
            db.signIn(with: token,completion: completion)
        }
        
        
    }
    class func linkAuthUserData(email: String, password: String,controller:UIViewController, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        if let user = db.currentUser{
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user.link(with: credential) { users, error in
                if let error = error as? NSError{
                    switch error.code{
                    case AuthErrorCode.requiresRecentLogin.rawValue:
                        var peovid = user.providerData
                        peovid.sort { UserInfo1, UserInfo2 in
                            return UserInfo1.providerID < UserInfo2.providerID
                        }
                        for provider in peovid{
                            switch provider.providerID{
                            case "apple.com":
                                completion(nil,NSError(domain: "No Data", code: 100, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("You are not connected to the internet. Please check your connection", comment: "")]))
                                
                            case "google.com":
                                self.reAuthGoogle(controller: controller) { user,error in
                                    if let error = error{
                                        completion(nil,error)
                                    }
                                    else{
                                        self.linkAuthUserData(email: email, password: password, controller: controller, completion: completion)
                                    }
                                }
                            case "facebook.com":
                                self.reAuthFacebook(controller: controller) { user,error in
                                    if let error = error{
                                        completion(nil,error)
                                    }
                                    else{
                                        self.linkAuthUserData(email: email, password: password, controller: controller, completion: completion)
                                    }
                                }
                            default:
                                completion(nil,error)
                            }
                        }
                    default:
                        completion(nil,error)
                    }
                }
            }
        }
        else{
            db.createUser(withEmail: email, password: password,completion: completion)
        }
    }
    class func loginAnonymusUser( completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        db.signInAnonymously(completion: completion)
        
    }
    class func deleteAnonymusUserData( completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth().currentUser
        db?.delete(completion: completion)
        
    }
    
    class func forgotUserPassword(email: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth()
        db.sendPasswordReset(withEmail: email, completion: completion)
        
    }
    class func updateUserPassword(password: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth().currentUser
        db?.updatePassword(to: password, completion: completion)
        
    }
    class func getAuthCredential(provider: AuthCredential,controller:UIViewController, completion:@escaping (_ error:Error?) -> ()) {
        let provider = OAuthProvider(providerID: provider.provider)
        provider.getCredentialWith(nil) { credential, error in
            if let error = error{
                completion(error)
            } else {
                guard let credential = credential else{return}
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    class func checkUserData(completion:@escaping (_ error:Error?,_ user:UserModel?) -> ()){
        self.getUserData(uid: self.getCurrentUserId().0) { error1, user in
            
            if let err = error1{
                completion(err,nil)
                
            }
            else{
                if let userData = user{
                    if let role = userData.userRole{
                        if role != UserRole.admin.rawValue {
                            self.checkCategoryUserData(completion: completion)
                        }
                        else{
                            self.logoutUserData { error in
                                if let err = error{
                                    completion(err,nil)
                                }
                                else{
                                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("This email not used for user. Please sign in an other account", comment: "")]),nil)
                                }
                            }
                            
                        }
                    }
                    else{
                        self.logoutUserData { error in
                            if let err = error{
                                completion(err,nil)
                            }
                            else{
                                completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("This email not used for user. Please sign in an other account", comment: "")]),nil)
                            }
                        }
                        
                    }
                } else{
                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]),nil)
                }
                
            }
            
            
        }
    }
    class func checkCategoryUserData(completion:@escaping (_ error:Error?,_ user:UserModel?) -> ()){
        self.getUserData(uid: self.getCurrentUserId().0) { error1, user in
            
            if let err = error1{
                completion(err,nil)
                
            }
            else{
                if let userData = user{
                    completion(nil,user)
                } else{
                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]),nil)
                }
                
            }
            
            
        }
    }
    class func deleteChatData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CHATS).document(uid).collection(Constant.NODE_CONVERSATIONS).getDocuments() { (querySnapShot,error) in
            if let err = error {
                completion(err)
            }else {
                let dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        db.collection(Constant.NODE_CHATS).document(uid).collection(Constant.NODE_CONVERSATIONS).document(queryDocument.documentID).delete { (err) in
                            dispatch.leave()
                        }
                        dispatch.notify(queue: .main){
                            db.collection(Constant.NODE_CHATS).document(uid).delete { (err) in
                                if let err = err {
                                    completion(err)
                                } else {
                                    completion(nil)
                                }
                            }
                        }
                    })
                }
                else{
                    db.collection(Constant.NODE_CHATS).document(uid).delete { (err) in
                        if let err = err {
                            completion(err)
                        } else {
                            completion(nil)
                        }
                    }
                }
                
            }
        }
    }
    class func deleteReviewData(dishid: String,reviewid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).collection(Constant.NODE_COMMENTS).getDocuments() { (querySnapShot,error) in
            if let err = error {
                completion(err)
            }else {
                let dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).collection(Constant.NODE_COMMENTS).document(queryDocument.documentID).delete { (err) in
                            dispatch.leave()
                        }
                        dispatch.notify(queue: .main){
                            db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).delete { (err) in
                                if let err = err {
                                    completion(err)
                                } else {
                                    completion(nil)
                                }
                            }
                        }
                    })
                }
                else{
                    db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).delete { (err) in
                        if let err = err {
                            completion(err)
                        } else {
                            completion(nil)
                        }
                    }
                }
                
            }
        }
    }
    class func saveUserData(uid: String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? UserModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_USERS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveOderData(uid: String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? OrderModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_ORDERS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveSubcribeUserData(uid: String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? SubcribModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_SUBUSERS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveProdReviewData(uid: String,prodId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? ReviewModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_DISHES).document(prodId).collection(Constant.NODE_REVIEWS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveTraditionalDishReviewData(uid: String,prodId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? ReviewModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_TRADITIONDISH).document(prodId).collection(Constant.NODE_REVIEWS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveProdVisitData(uid: String,prodId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? VisitModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_DISHES).document(prodId).collection(Constant.NODE_VISITS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveTraditionalDishVisitData(uid: String,prodId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? VisitModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_TRADITIONDISH).document(prodId).collection(Constant.NODE_VISITS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveRestVisitData(uid: String,resId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? VisitModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_RESTAURANT).document(resId).collection(Constant.NODE_VISITS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveProdReviewCommData(dishid: String,reviewid:String,uid:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? ChatModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).collection(Constant.NODE_COMMENTS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveRestReviewCommData(restid: String,reviewid:String,uid:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? ChatModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_RESTAURANT).document(restid).collection(Constant.NODE_REVIEWS).document(reviewid).collection(Constant.NODE_COMMENTS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveRedReviewData(uid: String,resId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dic: [String:Any]!
        if let user = userData as? ReviewModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        dic[UserKeys.id.rawValue] = uid
        db.collection(Constant.NODE_RESTAURANT).document(resId).collection(Constant.NODE_REVIEWS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateUserData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? UserModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
            return
        }
        db.collection(Constant.NODE_USERS).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateReviewData(_ dishid: String,reviewid:String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? ReviewModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
            return
        }
        db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateProdData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? DishModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
            return
        }
        db.collection(Constant.NODE_DISHES).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateTraditionalDishData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? TraditionDishModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
            return
        }
        db.collection(Constant.NODE_TRADITIONDISH).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateResData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? RestaurantModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
            return
        }
        db.collection(Constant.NODE_RESTAURANT).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateCountriesData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? CountryModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
            return
        }
        db.collection(Constant.NODE_COUNTRY).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func getUserData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if snap!.exists{
                    completion(nil, UserModel(snap: snap!))
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getCountryData(uid: String, completion:@escaping (_ error:Error?, _ userData: CountryModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COUNTRY).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if snap!.exists{
                    completion(nil, CountryModel(snap: snap!))
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getRestaurentData(uid: String, completion:@escaping (_ error:Error?, _ userData: RestaurantModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if snap!.exists{
                    completion(nil, RestaurantModel(snap: snap!))
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getDietTypeData(uid: String, completion:@escaping (_ error:Error?, _ userData: DietTypeModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DIETTYPE).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if snap!.exists{
                    completion(nil, DietTypeModel(snap: snap!))
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getFoodTypeData(uid: String, completion:@escaping (_ error:Error?, _ userData: FoodTypeModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_FOODTYPE).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if snap!.exists{
                    completion(nil, FoodTypeModel(snap: snap!))
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getUserbyPhoneData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.phoneNumber.rawValue, isEqualTo: uid).getDocuments { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        completion(nil,UserModel(snap: queryDocument ))
                    })
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getAdminUserData(_ completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.userRole.rawValue, isEqualTo: UserRole.admin.rawValue).getDocuments { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        completion(nil,UserModel(snap: queryDocument ))
                    })
                }
                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
            }
        }
        
    }
    class func getUserList(_ string:String,uid:String, completion:@escaping (_ error:Error?, _ userData: [UserModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.category.rawValue, in: [string]).whereField(UserKeys.id.rawValue, isNotEqualTo: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[UserModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(UserModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    class func getProductList( completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DishModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getSimilerProductList(type:[String], completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).whereField(DishKeys.foodtype.rawValue, in: [type]).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                let dispatch = DispatchGroup()
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let dish = DishModel(snap: queryDocument )!
                        self.getRestaurentData(uid: dish.res_id) { error, userData in
                            dispatch.leave()
                            dish.rest = userData
                            referralList.append(dish)
                        }
                        
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
            }
        }
    }
    class func getDishWithRestList( completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                let dispatch = DispatchGroup()
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let dish = DishModel(snap: queryDocument )!
                        self.getRestaurentData(uid: dish.res_id) { error, userData in
                            dispatch.leave()
                            dish.rest = userData
                            referralList.append(dish)
                        }
                        
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
            }
        }
    }
    class func getFoodtypeList( completion:@escaping (_ error:Error?, _ userData: [FoodTypeModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_FOODTYPE).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[FoodTypeModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(FoodTypeModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getDiettypeList( completion:@escaping (_ error:Error?, _ userData: [DietTypeModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DIETTYPE).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DietTypeModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DietTypeModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getProductbyRestList(_ restid:String, completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).whereField(DishKeys.res_id.rawValue, in: [restid]).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DishModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getProductbyRestandCategoryList(_ restid:String,category:[String] ,completion:@escaping (_ error:Error?, _ userData: [CategorDish]?) -> ()) {
        let db = Firestore.firestore()
        
        var referralList:[CategorDish] = []
        let dispatch = DispatchGroup()
        for cate in category{
            dispatch.enter()
            db.collection(Constant.NODE_DISHES).whereField(DishKeys.res_id.rawValue, isEqualTo: restid).whereField(DishKeys.category.rawValue, isEqualTo: cate).getDocuments() { (querySnapShot, error) in
                var referralList1:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList1.append(DishModel(snap: queryDocument )!)
                    })
                    db.collection(Constant.NODE_CATEGORY).document(cate).getDocument { docSnapShot, error in
                        referralList.append(CategorDish(cateogry: DishCategorModel(snap: docSnapShot!), dishes: referralList1))
                        dispatch.leave()
                    }
                }
                else{
                    dispatch.leave()
                }
            }
        }
        dispatch.notify(queue: .main){
            completion(nil,referralList)
        }
        
    }
    class func getRestReviewList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ResReviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).document(uid).collection(Constant.NODE_REVIEWS).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ResReviewModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(ResReviewModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getRestReview1List(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ResReviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).document(uid).collection(Constant.NODE_REVIEWS).addSnapshotListener() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ResReviewModel] = []
                var dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let review = ResReviewModel(snap: queryDocument )!
                        self.getUserData(uid: review.userId) { error, userData in
                            dispatch.leave()
                            review.user = userData
                            referralList.append(review)
                        }
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getRestList( completion:@escaping (_ error:Error?, _ userData: [RestaurantModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[RestaurantModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(RestaurantModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getRestWithDishList( completion:@escaping (_ error:Error?, _ userData: [RestaurantModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                let group = DispatchGroup()
                var referralList:[RestaurantModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        group.enter()
                        let rest = RestaurantModel(snap: queryDocument )!
                        self.getDishByRestList(rest.docId) { error, userData in
                            group.leave()
                            rest.dishes = userData
                            referralList.append(rest)
                        }
                    })
                    group.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
            }
        }
    }
    class func getRestByUserList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [RestaurantModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).whereField(RestaurantKeys.userId.rawValue, isEqualTo: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[RestaurantModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(RestaurantModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getProductByCountryList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).whereField(DishKeys.country.rawValue, isEqualTo: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DishModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getTraditionalDishByCountryList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [TraditionDishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_TRADITIONDISH).whereField(TraditionDishKeys.country_id.rawValue, isEqualTo: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[TraditionDishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(TraditionDishModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getCountryList( completion:@escaping (_ error:Error?, _ userData: [CountryModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COUNTRY).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[CountryModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(CountryModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getFavProductList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).whereField("\(DishKeys.isFav.rawValue).\(uid)", isEqualTo: true).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DishModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getFavDishWithRestList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).whereField("\(DishKeys.isFav.rawValue).\(uid)", isEqualTo: true).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var dispatch = DispatchGroup()
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let dish = DishModel(snap: queryDocument )!
                        self.getRestaurentData(uid: dish.res_id) { error, userData in
                            dispatch.leave()
                            dish.rest = userData
                            referralList.append(dish)
                        }
                        
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
            }
        }
    }
    class func getRecentDishWithRestList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DishModel] = []
                let dishdispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dishdispatch.enter()
                        db.collection(Constant.NODE_DISHES).document(queryDocument.documentID).collection(Constant.NODE_VISITS).whereField(ReviewKeys.userId.rawValue, isEqualTo: uid).getDocuments(){ (querySnapShot1, error1) in
                            var referralList1:[VisitModel] = []
                            if querySnapShot1?.documents.count ?? 0 > 0 {
                                querySnapShot1?.documents.forEach({ (queryDocument1) in
                                    let review = VisitModel(snap: queryDocument1)!
                                    review.dish = DishModel(snap: queryDocument)
                                    referralList1.append(review)
                                    
                                })
                            }
                            let dish = DishModel(snap: queryDocument)!
                            dish.visits = referralList1
                            referralList.append(dish)
                            dishdispatch.leave()
                        }
                    })
                    dishdispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getRecentRestWithList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [RestaurantModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[RestaurantModel] = []
                let dishdispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dishdispatch.enter()
                        db.collection(Constant.NODE_RESTAURANT).document(queryDocument.documentID).collection(Constant.NODE_VISITS).whereField(ReviewKeys.userId.rawValue, isEqualTo: uid).getDocuments(){ (querySnapShot1, error1) in
                            var referralList1:[VisitModel] = []
                            if querySnapShot1?.documents.count ?? 0 > 0 {
                                querySnapShot1?.documents.forEach({ (queryDocument1) in
                                    let review = VisitModel(snap: queryDocument1)!
                                    review.rest = RestaurantModel(snap: queryDocument)
                                    referralList1.append(review)
                                    
                                })
                            }
                            let dish = RestaurantModel(snap: queryDocument)!
                            dish.visits = referralList1
                            referralList.append(dish)
                            dishdispatch.leave()
                        }
                    })
                    dishdispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getFavRestList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [RestaurantModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).whereField("\(RestaurantKeys.isFav.rawValue).\(uid)", isEqualTo: true).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[RestaurantModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(RestaurantModel(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getFavRestWithDishList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [RestaurantModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).whereField("\(RestaurantKeys.isFav.rawValue).\(uid)", isEqualTo: true).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                let group = DispatchGroup()
                var referralList:[RestaurantModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        group.enter()
                        let rest = RestaurantModel(snap: queryDocument )!
                        self.getDishByRestList(rest.docId) { error, userData in
                            group.leave()
                            rest.dishes = userData
                            referralList.append(rest)
                        }
                    })
                    group.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
            }
        }
    }
    class func getDishReviewList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ReviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).document(uid).collection(Constant.NODE_REVIEWS).addSnapshotListener() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ReviewModel] = []
                var dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let review = ReviewModel(snap: queryDocument )!
                        self.getUserData(uid: review.userId) { error, userData in
                            dispatch.leave()
                            review.user = userData
                            referralList.append(review)
                        }
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getTraditionalDishReviewList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ReviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_TRADITIONDISH).document(uid).collection(Constant.NODE_REVIEWS).addSnapshotListener() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ReviewModel] = []
                var dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let review = ReviewModel(snap: queryDocument )!
                        self.getUserData(uid: review.userId) { error, userData in
                            dispatch.leave()
                            review.user = userData
                            referralList.append(review)
                        }
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getDishByRestList(_ restid:String, completion:@escaping (_ error:Error?, _ userData: [DishModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).whereField(DishKeys.res_id.rawValue, isEqualTo: restid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DishModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DishModel(snap: queryDocument )!)
                    })
                    completion(nil,referralList)
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getDishReviewWithCommentList(_ dishid:String,reviewid:String, completion:@escaping (_ error:Error?, _ userData: [CommentModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).document(dishid).collection(Constant.NODE_REVIEWS).document(reviewid).collection(Constant.NODE_COMMENTS).addSnapshotListener() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[CommentModel] = []
                var dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let review = ChatModel(snap: queryDocument )!
                        self.getUserData(uid: review.fromID) { error, userData in
                            dispatch.leave()
                            referralList.append(CommentModel(user: userData,comment: review))
                        }
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getRestReviewWithCommentList(_ restid:String,reviewid:String, completion:@escaping (_ error:Error?, _ userData: [CommentModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RESTAURANT).document(restid).collection(Constant.NODE_REVIEWS).document(reviewid).collection(Constant.NODE_COMMENTS).addSnapshotListener() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[CommentModel] = []
                var dispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let review = ChatModel(snap: queryDocument )!
                        self.getUserData(uid: review.fromID) { error, userData in
                            dispatch.leave()
                            referralList.append(CommentModel(user: userData,comment: review))
                        }
                    })
                    dispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getNotificationList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [NotificationModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_NOTIFICATION).whereField(NotificationKeys.userlist.rawValue, arrayContains: uid).getDocuments { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[NotificationModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(NotificationModel(snap: queryDocument)!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getMyReviewWithCommentList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ReviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ReviewModel] = []
                let dishdispatch = DispatchGroup()
                let reviewdispatch = DispatchGroup()
                let userdispatch = DispatchGroup()
                let commentdispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dishdispatch.enter()
                        db.collection(Constant.NODE_DISHES).document(queryDocument.documentID).collection(Constant.NODE_REVIEWS).whereField(ReviewKeys.userId.rawValue, isEqualTo: uid).getDocuments(){ (querySnapShot1, error1) in
                            
                            if querySnapShot1?.documents.count ?? 0 > 0 {
                                querySnapShot1?.documents.forEach({ (queryDocument1) in
                                    reviewdispatch.enter()
                                    let review = ReviewModel(snap: queryDocument1)!
                                    review.dish = DishModel(snap: queryDocument)
                                    self.getUserData(uid: uid) { error, userData in
                                        review.user = userData
                                        db.collection(Constant.NODE_DISHES).document(queryDocument.documentID).collection(Constant.NODE_REVIEWS).document(queryDocument1.documentID).collection(Constant.NODE_COMMENTS).getDocuments(){ (querySnapShot2, error2) in
                                            var referralList2:[CommentModel] = []
                                            if querySnapShot2?.documents.count ?? 0 > 0 {
                                                querySnapShot2?.documents.forEach({ (queryDocument2) in
                                                    commentdispatch.enter()
                                                    let comment = CommentModel(comment: ChatModel(snap: queryDocument2)!)
                                                    self.getUserData(uid: comment.comment.fromID) { error, userData in
                                                        
                                                        comment.user = userData
                                                        referralList2.append(comment)
                                                        commentdispatch.leave()
                                                    }
                                                })
                                                commentdispatch.notify(queue: .main){
                                                    review.comment = referralList2
                                                    referralList.append(review)
                                                    reviewdispatch.leave()
                                                }
                                            }
                                            else{
                                                referralList.append(review)
                                                reviewdispatch.leave()
                                            }
                                        }
                                    }
                                    
                                })
                                reviewdispatch.notify(queue: .main){
                                    dishdispatch.leave()
                                }
                            }
                            else{
                                dishdispatch.leave()
                            }
                        }
                        
                    })
                    dishdispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getRespondReviewWithCommentList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ReviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DISHES).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ReviewModel] = []
                let dishdispatch = DispatchGroup()
                let reviewdispatch = DispatchGroup()
                let userdispatch = DispatchGroup()
                let commentdispatch = DispatchGroup()
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dishdispatch.enter()
                        db.collection(Constant.NODE_DISHES).document(queryDocument.documentID).collection(Constant.NODE_REVIEWS).getDocuments(){ (querySnapShot1, error1) in
                            
                            if querySnapShot1?.documents.count ?? 0 > 0 {
                                querySnapShot1?.documents.forEach({ (queryDocument1) in
                                    reviewdispatch.enter()
                                    let review = ReviewModel(snap: queryDocument1)!
                                    review.dish = DishModel(snap: queryDocument)
                                    self.getUserData(uid: review.userId) { error, userData in
                                        review.user = userData
                                        db.collection(Constant.NODE_DISHES).document(queryDocument.documentID).collection(Constant.NODE_REVIEWS).document(queryDocument1.documentID).collection(Constant.NODE_COMMENTS).whereField(ChatKeys.fromID.rawValue, isEqualTo: uid).getDocuments(){ (querySnapShot2, error2) in
                                            var referralList2:[CommentModel] = []
                                            if querySnapShot2?.documents.count ?? 0 > 0 {
                                                querySnapShot2?.documents.forEach({ (queryDocument2) in
                                                    commentdispatch.enter()
                                                    let comment = CommentModel(comment: ChatModel(snap: queryDocument2)!)
                                                    self.getUserData(uid: comment.comment.fromID) { error, userData in
                                                        
                                                        comment.user = userData
                                                        referralList2.append(comment)
                                                        commentdispatch.leave()
                                                    }
                                                })
                                                commentdispatch.notify(queue: .main){
                                                    review.comment = referralList2
                                                    referralList.append(review)
                                                    reviewdispatch.leave()
                                                }
                                            }
                                            else{
                                                //referralList.append(review)
                                                reviewdispatch.leave()
                                            }
                                        }
                                    }
                                    
                                })
                                reviewdispatch.notify(queue: .main){
                                    dishdispatch.leave()
                                }
                            }
                            else{
                                dishdispatch.leave()
                            }
                        }
                        
                    })
                    dishdispatch.notify(queue: .main){
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func removeListener(_ completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.terminate(completion: completion)
        
    }
    
    class func updatetokenData(_ isTokn:Bool = false, completion:@escaping (_ error:Error?) -> ()) {
        let user = UserModel()
        if isTokn{
            user.token = Messaging.messaging().fcmToken
            user.isOnline = true
        }
        else{
            user.token = ""
            user.isOnline = false
        }
        
        updateUserData(getCurrentUserId().0, dic: user, completion: completion)
        
    }
   
    

  
    

    class func logout(dlete:Bool = false){
        if dlete{
            self.logoutUserData { error in
                self.logoutUser()
            }
        }
        else{
            let user = UserModel()
            user.token = ""
            user.isOnline = false
            self.updateUserData(self.getCurrentUserId().0, dic: user) { error in
                self.logoutUserData { error in
                    //CommonHelper.removeCachedUserData()
                    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //            let scene = UIApplication.shared.connectedScenes.first
        //            guard let windowScene = (scene as? UIWindowScene) else { return }
        //            let window = UIWindow(windowScene: windowScene)
        //            window.windowScene = windowScene
                    self.logoutUser()
                    //window.rootViewController = viewController
                    //window.makeKeyAndVisible()
                    //appDelegate.window = window
                }
            }
        }
        
        
    }
    class func logoutUser(){
        FirebaseData.loginAnonymusUserData { error in
            if let error = error{
                let controller = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController)
                UIApplication.shared.windows.first?.rootViewController = controller
                return
            }
            let controller = UIStoryboard.storyBoard(withName: .home).loadViewController(withIdentifier: .LGSideMenuController) as! LGSideMenuController
            UIApplication.shared.windows.first?.rootViewController = controller
            
        }
    }
    class func checkLogin() -> Bool{
        return Auth.auth().currentUser != nil
    }
//    class func getCurrentUserId() -> String {
//        let id = Auth.auth().currentUser?.uid
//        print("uid: \(id ?? "")")
//        if let di = id{
//            return di
//        }
//        else{
//            self.logout()
//            return "0"
//        }
//
//    }
    class func getCurrentUserId() -> (String,Bool) {
        
        let id = Auth.auth().currentUser?.uid
        print("uid: \(id ?? "")")
        if let di = id{
            if let providerData = Auth.auth().currentUser {
                print(!providerData.isAnonymous)
                return (di,!providerData.isAnonymous)
            }
            return (di,false)
        }
        else{
            //self.logout()
            return ("",false)
        }
    }
    class func getCurrentUser() -> User? {
        
        let id = Auth.auth().currentUser
        if let di = id{
            
            return di
        }
        else{
            //self.logout()
            return nil
        }
    }
    class func addMessageToConversation(documentId: String, chatModel:ChatModel,isSendAdmin:Bool = false,completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var node = Constant.NODE_CHATS
        if isSendAdmin{
            node = Constant.NODE_ADMINCHAT
        }
        db.collection(node).document(documentId).collection(Constant.NODE_CONVERSATIONS).document(chatModel.messageId).setData(chatModel.dictionary, completion: { error in
            if let err = error {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
    class func updateConversationData(_ referId: String, dic:Any,isSendAdmin:Bool = false, completion:@escaping (_ error:Error?) -> ()) {
        var node = Constant.NODE_CHATS
        if isSendAdmin{
            node = Constant.NODE_ADMINCHAT
        }
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? MessageListModel1{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        db.collection(node).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func addGroupToConversation(documentId: String, chatModel:MessageListModel1,isSendAdmin:Bool = false,completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var node = Constant.NODE_CHATS
        if isSendAdmin{
            node = Constant.NODE_ADMINCHAT
        }
        db.collection(node).document(documentId).setData(chatModel.dictionary, completion: { error in
            if let err = error {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
    class func getConverstationIdOfTwoUsers(senderId:String, receiverId:String, completion:@escaping (_ conversationId:String?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CHATS).whereField("participants.\(senderId)", isEqualTo: true).whereField("participants.\(receiverId)", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                if querySnapshot?.documents.count ?? 0 > 0 {
                    for queryDocument in querySnapshot?.documents ?? [] {
                        completion(queryDocument.documentID, nil)
                        return
                    }
                }
                completion(nil,nil)
            }
        }
    }
    class func getConverstationOfUsers(_ conversationId:String,node:String = Constant.NODE_CHATS, completion:@escaping (_ user:ParticepentsModel?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let chat = ParticepentsModel(snap: querySnapshot!)
                completion(chat,nil)
                
            }
        }
    }
    class func getConverstationData(_ conversationId:String,node:String = Constant.NODE_CHATS, completion:@escaping (_ user:MessageListModel1?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let chat = MessageListModel1(snap: querySnapshot!)
                completion(chat,nil)
                
            }
        }
    }
    class func getConverstationOfUsersList(_ conversationId:String,node:String = Constant.NODE_CHATS, completion:@escaping (_ user:[UserModel]?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let chat = ParticepentsModel(snap: querySnapshot!)
                if let userid = chat?.participants.keys{
                    var array: [UserModel] =  []
                    let dispatch = DispatchGroup()
                    for ids in userid{
                        dispatch.enter()
                        self.getUserData(uid: ids) { error, userData in
                            dispatch.leave()
                            if let err = error {
                                return
                            }else {
                                array.append(userData!)
                            }
                        }
                    }
                    dispatch.notify(queue: .main){
                        completion(array,nil)
                    }
                }
                else{
                    completion(nil,NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
                }
                
                
            }
        }
    }
    class func getChatList( completion:@escaping (_ error:Error?, _ userData: [MessageListModel1]?) -> ()) {
        let db = Firestore.firestore()
        var query:Query! = db.collection(Constant.NODE_CHATS)
        query.getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[MessageListModel1] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(MessageListModel1(snap: queryDocument )!)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getConverstationOfTwoUsersSerivce(_ uid:String,conversationId:String,node:String = Constant.NODE_CHATS, completion:@escaping (_ user:UserModel?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let chat = ParticepentsModel(snap: querySnapshot!)
                chat?.participants.removeValue(forKey: uid)
                if let recivrid = chat?.participants.keys.first{
                    self.getUserData(uid: recivrid) { error, userData in
                        if let err = error {
                            completion(nil,err)
                        }else {
                            completion(userData,nil)
                        }
                    }
                }
                else{
                    completion(nil,nil)
                }
            }
        }
    }
    class func getConverstationOfManyUsersSerivce(_ uid:String,conversationId:String,node:String = Constant.NODE_ADMINCHAT, completion:@escaping (_ user:[UserModel]?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let dispatchgroup = DispatchGroup()
                var users:[UserModel] = []
                if let chat = ParticepentsModel(snap: querySnapshot!){
                chat.participants.removeValue(forKey: uid)
                for recivrid in chat.participants.keys{
                    dispatchgroup.enter()
                        self.getUserData(uid: recivrid) { error, userData in
                            dispatchgroup.leave()
                            guard let userData = userData else {
                                return
                            }
                            users.append(userData)
                        }
                }
                    dispatchgroup.notify(queue: .main) {
                        completion(users,nil)
                    }
                }
                else{
                    completion(users,nil)
                }
            }
        }
    }
    class func addMessageToAdminConversation(documentId: String,request:RequestModel, chatModel:ChatModel,completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_ADMINCHAT).document(documentId).collection(Constant.NODE_CONVERSATIONS).document(chatModel.messageId).setData(chatModel.dictionary, completion: { error in
            if let err = error {
                completion(err)
            } else {
                db.collection(Constant.NODE_ADMINCHAT).document(documentId).setData(["lastMessage" : chatModel.dictionary,"participants":[chatModel.fromID:true,chatModel.toID:true]]) { error in
                    if let err = error {
                        completion(err)
                    } else {
                        db.collection(Constant.NODE_MY_REQUESTS).addDocument(data: request.dictionary) { error in
                            if let err = error {
                                completion(err)
                            } else {
                                completion(nil)
                            }
                        }
                    }
                }
                
            }
        })
    }
    class func addFeedbackToAdminConversation(request:RequestModel,completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_FEEDBACKS).addDocument(data: request.dictionary) { error in
            if let err = error {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    class func uploadProfileImage(image:UIImage,name:String ,folder:String,index:Int = 0,completion: @escaping (_ url: String?,_ error: Error?,_ index:Int) -> Void) {
        let storageRef = Storage.storage().reference().child("\(folder)/\(name).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    completion(nil, error,index)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if error != nil {
                            completion(nil, error,index)
                        }else {
                            completion(url?.absoluteString ?? "", nil,index)
                        }
                    }
                }
            }
        }
    }
    class func uploadFile(url:URL,name:String ,folder:String,content:String,index:Int = 0,completion: @escaping (_ url: String?,_ error: Error?,_ index:Int) -> Void) {
        let path = "\(folder)/\(name).\(url.pathExtension)"
        print(path)
        let storageRef = Storage.storage().reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = content //"audio/mp3"
        storageRef.putFile(from:url, metadata: metadata) { (metadata, error) in
            if error != nil {
                completion(nil, error,index)
            } else {
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        completion(nil, error,index)
                    }else {
                        completion(url?.absoluteString ?? "", nil,index)
                    }
                }
            }
        }
    }
    class func deleteFile(_ url:String, completion:@escaping (_ error:Error?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.delete(completion: completion)
        
    }
    class func deleteFilePath(_ path:String, completion:@escaping (_ error:Error?) -> ()) {
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: path)
        storageRef.listAll { result, error in
            if let error = error{
                completion(error)
            }
            else{
                guard let result = result else{ completion(nil)
                return}
                let dispatch = DispatchGroup()
                var errorr:Error?
                result.items.forEach { ref in
                    dispatch.enter()
                    ref.delete { error in
                        dispatch.leave()
                        if let error = error{
                            errorr = error
                        }
                    }
                }
                dispatch.notify(queue: .main){
                    completion(errorr)
                }
            }
        }
    }
    
}
