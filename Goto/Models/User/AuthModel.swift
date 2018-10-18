//
//  AuthModel.swift
//  Goto
//
//  Created by Admin on 14/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AuthModel {
//    "token": "e166b62d4dba27a2127b10333e65139377120e2b20f98ae93e4ca57a9b523c85",
//    "exp": "2019-01-12T10:07:21.136Z",
//    "created_at": "2018-01-12T10:07:21.138Z"
    var token: String
    var expired: Date?
    var created: Date?
    init(token: String) {
        self.token = token
    }
    init(data: [String: AnyObject]) {
        token = data["token"] as! String
        if let created = data["created_at"]  as? String { self.created = Helper.convertStringToDate(date: created)}
        if let expired = data["exp"]  as? String { self.expired = Helper.convertStringToDate(date: expired)}
    }
    static func saveToDevice(auth: AuthModel) {
        UserDefaults.standard.set(auth.token, forKey: "tokenGOTO")
        if let created = auth.created {
            UserDefaults.standard.set(Helper.convertStringFromDate(date: created), forKey: "createdGOTO")
        }
        if let expired = auth.expired {
            UserDefaults.standard.set(Helper.convertStringFromDate(date: expired), forKey: "expiredGOTO")
        }
        UserDefaults.standard.synchronize()
    }
    static func loadFromDevice() -> AuthModel? {
        if let token = UserDefaults.standard.string(forKey: "tokenGOTO") {
            let auth = AuthModel(token: token)
            if let strCreated = UserDefaults.standard.string(forKey: "createdGOTO"), let created = Helper.convertStringToDate(date: strCreated) {
                auth.created = created
            }
            if let strExpired = UserDefaults.standard.string(forKey: "expiredGOTO"), let expired = Helper.convertStringToDate(date: strExpired) {
                auth.expired = expired
            }
            return auth
        }
        return nil
    }
    static func removeFromDevice() {
        UserDefaults.standard.removeObject(forKey: "tokenGOTO")
        UserDefaults.standard.removeObject(forKey: "createdGOTO")
        UserDefaults.standard.removeObject(forKey: "expiredGOTO")
    }
}
