//
//  SessionManager.swift
//  Goto
//
//  Created by Admin on 14/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SessionManager: NSObject {
    static let shared = SessionManager()
    var token: AuthModel?
    var user: User?
    /// Returns the current state of the session
    var loggedIn:Bool {
        return token != nil && token?.expired != nil && Date() < (token?.expired)!
    }
    //------------------------------------------------------------------------------
    // MARK: - Initialization
    //------------------------------------------------------------------------------
    private override init() {
        super.init()
        token = AuthModel.loadFromDevice()
        if loggedIn {
            user = User.LoadFromDevice()
        }
    }
    func logout() {
        user = nil
        token = nil
        User.removeFromDevice()
        AuthModel.removeFromDevice()
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "OriginNavigation")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = initialViewController

    }
    
}
