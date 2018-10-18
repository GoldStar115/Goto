//
//  CardInfo.swift
//  Goto
//
//  Created by Adrian Rusin on 1/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CardInfo: NSObject {
    var cardNumber: String?
    var cardHolderName: String?
    var expirationMonth: String?
    var expirationYear: String?
    var CVV: String?
    
    func getJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        if let cardNumber = cardNumber {json["cardNumber"] = cardNumber as AnyObject}
        if let cardHolderName = cardHolderName {json["cardHolderName"] = cardHolderName as AnyObject}
        if let expirationMonth = expirationMonth {json["expirationMonth"] = expirationMonth as AnyObject}
        if let expirationYear = expirationYear {json["expirationYear"] = expirationYear as AnyObject}
        if let CVV = CVV {json["CVV"] = CVV as AnyObject}
        return json
    }
}
