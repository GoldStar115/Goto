//
//  File.swift
//  marker
//
//  Created by Kedan Li on 16/9/22.
//  Copyright © 2016 Marker. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD
enum Host: String {
    case Production = "https://api.withgoto.com/v1"
    case PaymentProduction = "https://secure.safecharge.com/ppp/api/v1"
    case PaymentDevelopment = "https://ppp-test.safecharge.com/ppp/api/v1"
}

class APIRequests {
    static func sendRequest(type: RouterType, showProgress: Bool = false, successHandler: @escaping ([String: AnyObject]?) -> Void, failureHandler: @escaping (String?) -> Void) {
        let request = APIRequests.requestOfType(type: type)
        DispatchQueue.main.async {
            if showProgress {HUD.show(.progress)}
        }
        let header:[String: String]? = ["Content-Type": "application/json"]

        let sendRequest = Alamofire.request(request.0, method: request.1, parameters: request.2, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            debugPrint(response)
            DispatchQueue.main.async {
                if showProgress {HUD.hide(animated: true)}
            }
            switch(response.result) {
            case .success(_):
                if let data = response.result.value as? [String: AnyObject]{
                    if let error = data["error"] as? [String: AnyObject], let errDescription = error["message"] as? String, let _ = error["code"] as? Int  {
                        failureHandler(errDescription)
                    } else if let status = data["status"] as? String, status == "ERROR", let reason = data["reason"] as? String {
                        failureHandler(reason)
                    } else{
                        successHandler(data)
                    }
                } else {
                    failureHandler(nil)
                }
            case .failure(_):
                failureHandler(response.result.error?.localizedDescription)
            }
        }
        debugPrint(sendRequest)
    }

    static func requestOfType(type: RouterType) -> (URL, Alamofire.HTTPMethod, [String: AnyObject]?) {
        var strHost = getEnvironmentURLString()
        var method: Alamofire.HTTPMethod {
            switch type {
            case .EnrollCheckAccount:
                return .post
            case .EnrollValidateCode:
                return .post
            case .EnrollValidateEmail:
                return .post
            case .EnrollCommit:
                return .post
            case .LoginWithPhone:
                return .post
            case .ForgotPassword:
                return .post
            case .UpdateMe:
                return .post
            case .CreatePaymentTempToken:
                return .post
            case .UserAddPaymentMethod:
                return .post
            default:
                return .get
            }
        }
        switch type {
        case .CreatePaymentTempToken:
            strHost = Host.PaymentDevelopment.rawValue
            break
        default:
            if SessionManager.shared.loggedIn {
                strHost += "?access_token=" + (SessionManager.shared.token?.token)!
            }
            break
        }

        let hostURL = NSURL(string: strHost)?.appendingPathComponent(APIRequests.getPath(type: type))
        return (hostURL!, method, APIRequests.getParameter(type: type))
        
    }
    
    static func getEnvironmentURLString() -> String{
        return Host.Production.rawValue
    }
    
    static func getPath(type: RouterType) -> String {
        switch type {
        case .EnrollCheckAccount(_):
            return "/auth/enroll/check_account"
        case .EnrollValidateCode(_, _):
            return "/auth/enroll/validate_code"
        case .EnrollValidateEmail(_):
            return "/auth/enroll/validate_email"
        case .EnrollCommit(_, _, _, _):
            return "/auth/enroll/commit"
        case .LoginWithPhone(_, _):
            return "/auth/login"
        case .ForgotPassword(_):
            return "/auth/forgot"
        case .GetMe(), .UpdateMe(_, _, _):
            return "/users/me"
        case .GetPaymentSessionToken():
            return "/payments/session_token"
        case .CreatePaymentTempToken(_, _, _, _):
            return "/cardTokenization.do"
        case .UserAddPaymentMethod(_):
            return "/users/me/payments/methods"
        case .UserGetPaymentMethods():
            return "/users/me/payments/methods"
        }
    }
    
    static func getParameter(type: RouterType) -> [String: AnyObject]?{
        var params = [String: AnyObject]()
        switch type {
        case .EnrollCheckAccount ( let phone_number):
            params = ["phone_number": phone_number as AnyObject]
        case .EnrollValidateCode( let phone_number, let confirm_code ):
            params = ["phone_number": phone_number as AnyObject, "confirm_code": confirm_code as AnyObject]
        case .EnrollValidateEmail ( let email):
            params = ["email": email as AnyObject]
        case .EnrollCommit( let email, let password, let phone_number, let confirm_code ):
            params = ["email": email as AnyObject, "password": password as AnyObject, "phone_number": phone_number as AnyObject, "confirm_code": confirm_code as AnyObject]
        case .LoginWithPhone( let phone_number, let password ):
            params = ["phone_number": phone_number as AnyObject, "password": password as AnyObject]
        case .ForgotPassword ( let email):
            params = ["email": email as AnyObject]
        case .UpdateMe ( let firstName, let lastName, let postCode ):
            params = ["first_name": firstName as AnyObject, "last_name": lastName as AnyObject, "post_code": postCode as AnyObject]
        case .CreatePaymentTempToken( let token, let userId, let cardInfo, let billingAddress):
            params = ["sessionToken": token as AnyObject, "userTokenId": userId as AnyObject, "cardData": cardInfo.getJSON() as AnyObject,  "billingAddress": billingAddress.getJSON() as AnyObject]
        case .UserAddPaymentMethod ( let token):
            params = ["token": token as AnyObject]
        default:
            break
        }
//        if SessionManager.shared.loggedIn {
//            params["access_token"] = SessionManager.shared.token?.token as AnyObject
//        }
        if params.count == 0 {
            return nil
        }
        return params
    }
    
}

enum RouterType {
    /// Authentication API Methods
    case EnrollCheckAccount(String)
    case EnrollValidateCode(String, String)
    case EnrollValidateEmail(String)
    case EnrollCommit(String, String, String, String)
    case LoginWithPhone(String, String)
    case ForgotPassword(String)
    /// Profile API Methods
    case GetMe()
    case UpdateMe(String, String, String)
    /// Payment API Methods
    case GetPaymentSessionToken()
    case CreatePaymentTempToken(String, String, CardInfo, BillingAddress)
    /// Profile Related API Methods
    case UserAddPaymentMethod(String)
    case UserGetPaymentMethods()
}
