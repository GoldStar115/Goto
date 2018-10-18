//
//  BillingAddress.swift
//  Goto
//
//  Created by Adrian Rusin on 1/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class BillingAddress: NSObject {
    var firstName: String?
    var lastName: String?
    var zip: String?
    var country: String?
    var email: String?

    func getJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        if let firstName = firstName {json["firstName"] = firstName as AnyObject}
        if let lastName = lastName {json["lastName"] = lastName as AnyObject}
        if let zip = zip {json["zip"] = zip as AnyObject}
        if let country = country {json["country"] = country as AnyObject}
        if let email = email {json["email"] = email as AnyObject}
        return json
    }

}
