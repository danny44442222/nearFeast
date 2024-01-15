//
//  WebServicesHelper.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD

enum httpMethod:String{
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}


enum webserviceUrl: String {
    
    //Login Storyboard
    case app_login = "/app_login",
         socialLogIn = "/app_register/social",
         
         
         directions = "/directions/json",
         homepage = "/homepage",
         forgetPassword = "/forgetPassword",
         add_fuel = "/add_fuel",
         filterfuel = "/filterfuel",
         getAvailbleRewardlist = "/getAvailbleRewardlist",
         update_profile_photo = "/update_profile_photo",
         edit_profile = "/edit_profile",
         retrivereward = "/retrivereward",
         fuellocation = "/fuellocation",
         myrewardlist = "/myrewardlist",
         getnotification = "/getnotification",
         lastdate = "/lastdate",
         viewallfuel = "/viewallfuel",
         normal = "/app_register/normal",
         delete_notofication = "/delete_notofication",
         readformwithdata = "/readformwithdata/",
         delete_form = "/delete_form/",
         getmyfilledform = "/getmyfilledform/",
         rejectform = "/rejectform",
         sendtoadmin = "/sendtoadmin",
         update_signature_photo = "/update_signature_photo",
         add_token = "/add_token",
         paymentEND = "/paymentEND",
         thirdsterp = "/thirdsterp",
         chatGpt = "/chat/completions",
         createNotesDates = "/userCrated",

         
         explorefirststep = "/explorefirststep",
         explorelistofcard = "/explorelistofcard",
         exploreaccountpayment = "/exploreaccountpayment",
         exploredetachcard = "/exploredetachcard",
         sendemailgeneric = "/sendemailgeneric",
         explorenotification = "/explorenotification",
         
         
         
         accoutpaymentnew = "/widgets/accoutpaymentnew",
         firststep = "/widgets/firststep",
         checkcustidexistornot = "/widgets/checkcustidexistornot",
         paymentMethods = "/widgets/paymentMethods",
         detatch = "/widgets/detatch",
         createsubscription = "/widgets/createsubscription",
         updatepaymentmethod = "/widgets/updatepaymentmethod",
         businesses_search = "/businesses/search"

    func url() -> String {
        switch self {
        case .businesses_search:
            return Constant.mainYelpUrl + self.rawValue
        case .directions:
            return Constant.mainGoogleUrl + self.rawValue
        case .accoutpaymentnew,.firststep,.checkcustidexistornot,.paymentMethods,.detatch,.updatepaymentmethod,.createsubscription:
            return Constant.mainCloudFunctionUrl + self.rawValue
        default:
            return Constant.mainUrl + self.rawValue
        }
        
    }

}

class WebServicesHelper
{
    
    var serviceName:webserviceUrl!
    var httpMethodName:HTTPMethod!
    var parameters:[String:Any]?
    var relatedViewController:UIViewController?
    var hud:JGProgressHUD?
    
    // MARK: - Web Service Base Url
    
    
    init(serviceToCall serviceName:webserviceUrl,
         withMethod httpMethodName:HTTPMethod,
         havingParameters parameters:[String:Any]? = nil,
         relatedViewController:UIViewController?,hud: JGProgressHUD? = nil)
    {
        self.serviceName = serviceName
        self.httpMethodName = httpMethodName
        self.parameters = parameters
        self.relatedViewController = relatedViewController
        self.hud = hud
    }

    
    class func callWebService(Parameters params : [String : Any]? = nil,suburl:String? = nil ,action : webserviceUrl!,httpMethodName: httpMethod!,_ index:Int? = nil, completion: @escaping (Int?,webserviceUrl,Bool,String?,Any?) -> Void){
        
        var base_url:String
        if let sub = suburl {
            base_url = action.url()  + sub.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        else{
            base_url = action.url()
        }
        print(base_url)
        var myheaders:HTTPHeaders! = ["Content-Type":"application/x-www-form-urlencoded","Accept":"application/json"]
        var encoding:ParameterEncoding!
        switch action {
        case .businesses_search:
            myheaders = ["Content-Type":"application/json"]
            myheaders["Authorization"] = "Bearer " + Constant.yelp_token_key
                encoding = URLEncoding.default
        case .directions:
        myheaders = ["Content-Type":"application/x-www-form-urlencoded","Accept":"application/json"]
            encoding = URLEncoding.default
        case .accoutpaymentnew,.firststep,.checkcustidexistornot,.paymentMethods,.detatch,.updatepaymentmethod,.createsubscription:
        myheaders = ["Content-Type":"application/json"]
            encoding = JSONEncoding.default
        default:
            break
        }
        let methodName:HTTPMethod = HTTPMethod(rawValue: httpMethodName.rawValue)

        if (Alamofire.NetworkReachabilityManager()?.isReachable)! {
            AF.request(base_url, method: methodName, parameters: params, encoding: encoding, headers: myheaders).responseJSON { (response) in
                
                
                var statusCode:NSInteger? = nil
                if let responseObj: HTTPURLResponse = response.response
                {
                    statusCode = responseObj.statusCode
                }
                
                if let error = response.error
                {
                    statusCode = error._code // statusCode private
                    switch error
                    {
                    case .invalidURL(let url):
                        let string = "Invalid URL: \(url) - \(error.localizedDescription)"
                         print(string)
                        completion(index,action,true,string,nil)
                        
                        
                    case .parameterEncodingFailed(let reason):
                        let string = "Parameter encoding failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        print(string)
                        completion(index,action,true,string,nil)
                        
                    case .multipartEncodingFailed(let reason):
                        let string = "Multipart encoding failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        print(string)
                        completion(index,action,true,string,nil)
                        
                    case .responseValidationFailed(let reason):
                        let string = "Response validation failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        print(string)
                        completion(index,action,true,string,nil)
                        switch reason
                        {
                            
                        case .dataFileNil, .dataFileReadFailed:
                            let string = "Downloaded file could not be read"
                            print(string)
                            completion(index,action,true,string,nil)
                            
                        case .missingContentType(let acceptableContentTypes):
                            let string = "Content Type Missing: \(acceptableContentTypes)"
                            print(string)
                            completion(index,action,true,string,nil)
                            
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            let string = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                            print(string)
                            completion(index,action,true,string,nil)
                            
                        case .unacceptableStatusCode(let code):
                            let string = "Response status code was unacceptable: \(code)"
                            print(string)
                            statusCode = code
                            completion(index,action,true,string,nil)
                        default:
                            completion(index,action,true,error.localizedDescription,nil)
                        }
                        
                    case .responseSerializationFailed(let reason):
                        let string = "Response serialization failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        completion(index,action,true,string,nil)
                        // statusCode = 3840 ???? maybe..
                    default:
                        completion(index,action,true,error.localizedDescription,nil)
                    }
                    
                    
                    print("Underlying error: \(String(describing: error.underlyingError))")
                }
                else if let error = response.error
                {
                    let string = "URLError occurred: \(error)"
                    print(string)
                    completion(index,action,true,string,nil)
                }
                else
                {
                    let string = "Unknown error: \(String(describing: response.error))"
                    print(string)
                    //completion(true,string,nil)
                    
                }
                
                if statusCode == nil{
                    completion(index,action,true,response.error?.localizedDescription,nil)
                    return
                }
                if((response.value) != nil)
                {
                    let swiftyJsonVar = JSON(response.value!)
                    
                    if let jsonDict:Dictionary<String, Any> = swiftyJsonVar.dictionaryObject
                    {
                        let responseStatus:Int? = jsonDict[Constant.sucess] as? Int
                        let responseStatus1:Int? = jsonDict[Constant.success] as? Int
                        if(responseStatus == 0 || responseStatus1 == 0)
                        {
                            completion(index,action,true,"error",nil)
                            
                        }
                        else{
                            if let responseDic = jsonDict[Constant.return_data]{
                                completion(index,action,true,nil,responseDic)
                            }
                            else{
                                completion(index,action,true,nil,jsonDict)
                            }
                        }
                    }
                    else{
                        completion(index,action,true,swiftyJsonVar.error?.localizedDescription,nil)
                    }
                }
                else{
                    completion(index,action,true,response.error?.localizedDescription,nil)
                }
            }
            
        }
        else{
            completion(index,action,false,nil,nil)
        }
    }

    class func callWebServiceWithFileUpload(Parameters params : [String : Any]? ,suburl:String? = nil,imageData:Data? = nil,action : webserviceUrl!,httpMethodName: HTTPMethod!,_ index:Int? = nil, completion: @escaping (Int?,webserviceUrl,Bool,String?,Any?) -> Void){
        
        let base_url:String
        if let urll = suburl{
            base_url = action.url() + urll
        }
        else{
            base_url = action.url()
        }
        print(base_url)
        
        let myheaders: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        if (Alamofire.NetworkReachabilityManager()?.isReachable)! {
            AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params!
                {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData
                {
                    multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
                }
            }, to: base_url, usingThreshold: UInt64.init(), method: httpMethodName, headers: myheaders).responseJSON { (response) in
                
                var statusCode:NSInteger? = nil
                if let responseObj: HTTPURLResponse = response.response
                {
                    statusCode = responseObj.statusCode
                }
                
                if let error = response.error
                {
                    statusCode = error._code // statusCode private
                    switch error
                    {
                    case .invalidURL(let url):
                        let string = "Invalid URL: \(url) - \(error.localizedDescription)"
                         print(string)
                        completion(index,action,true,string,nil)
                        
                        
                    case .parameterEncodingFailed(let reason):
                        let string = "Parameter encoding failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        print(string)
                        completion(index,action,true,string,nil)
                        
                    case .multipartEncodingFailed(let reason):
                        let string = "Multipart encoding failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        print(string)
                        completion(index,action,true,string,nil)
                        
                    case .responseValidationFailed(let reason):
                        let string = "Response validation failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        print(string)
                        completion(index,action,true,string,nil)
                        switch reason
                        {
                            
                        case .dataFileNil, .dataFileReadFailed:
                            let string = "Downloaded file could not be read"
                            print(string)
                            completion(index,action,true,string,nil)
                            
                        case .missingContentType(let acceptableContentTypes):
                            let string = "Content Type Missing: \(acceptableContentTypes)"
                            print(string)
                            completion(index,action,true,string,nil)
                            
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            let string = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                            print(string)
                            completion(index,action,true,string,nil)
                            
                        case .unacceptableStatusCode(let code):
                            let string = "Response status code was unacceptable: \(code)"
                            print(string)
                            statusCode = code
                            completion(index,action,true,string,nil)
                        default:
                            completion(index,action,true,error.localizedDescription,nil)
                        }
                        
                    case .responseSerializationFailed(let reason):
                        let string = "Response serialization failed: \(error.localizedDescription) - Failure Reason: \(reason)"
                        completion(index,action,true,string,nil)
                        // statusCode = 3840 ???? maybe..
                    default:
                        completion(index,action,true,error.localizedDescription,nil)
                    }
                    
                    
                    print("Underlying error: \(String(describing: error.underlyingError))")
                }
                else if let error = response.error
                {
                    let string = "URLError occurred: \(error)"
                    print(string)
                    completion(index,action,true,string,nil)
                }
                else
                {
                    let string = "Unknown error: \(String(describing: response.error))"
                    print(string)
                    //completion(true,string,nil)
                    
                }
                
                if statusCode == nil{
                    completion(index,action,true,response.error?.localizedDescription,nil)
                    return
                }
                if((response.value) != nil)
                {
                    let swiftyJsonVar = JSON(response.value!)
                    
                    if let jsonDict:Dictionary<String, Any> = swiftyJsonVar.dictionaryObject
                    {
                        let responseStatus:Int? = jsonDict[Constant.sucess] as? Int
                        let responseStatus1:Int? = jsonDict[Constant.success] as? Int
                        if(responseStatus == 0 || responseStatus1 == 0)
                        {
                            completion(index,action,true,"error",nil)
                            
                        }
                        else{
                            if let responseDic = jsonDict[Constant.return_data]{
                                completion(index,action,true,nil,responseDic)
                            }
                            else{
                                completion(index,action,true,nil,jsonDict)
                            }
                        }
                    }
                    else{
                        completion(index,action,true,swiftyJsonVar.error?.localizedDescription,nil)
                    }
                }
                else{
                    completion(index,action,true,response.error?.localizedDescription,nil)
                }
            }
        }
        else{
            completion(index,action,false,nil,nil)
        }
    }
    
}

