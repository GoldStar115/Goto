//
//  PaymentCardModel.swift
//  Goto
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PaymentCardModel: NSObject {
    var id: Int
    var userId: Int
    var cardBrandIcon: String?
    var cardBrandStyled: String?
    var methodName: String?
    var scUpoId: String?
    var scUpoStatus: String?
    var scUpoExpire: Date?
    var cardName: String?
    var cardLastString: String?
    var cardBrand: String?
    var cardType: String?
    var cardExpireMonth: String?
    var cardExpireYear: String?
    var created: Date?
    var updated: Date?
    
    init(data: [String: AnyObject]) {
        id = data["id"] as! Int
        userId = data["user_id"] as! Int
        cardBrandIcon = data["card_brand_icon"] as? String
        cardBrandStyled = data["card_brand_styled"] as? String
        methodName = data["method_name"] as? String
        scUpoId = data["sc_upo_id"] as? String
        scUpoStatus = data["sc_upo_status"] as? String
        scUpoExpire = Helper.convertStringToDate(date: data["sc_upo_expire"]  as! String, formatedString: "yyyy-MM-dd")
        cardName = data["card_name"] as? String
        cardLastString = data["card_last4"] as? String
        cardBrand = data["card_brand"] as? String
        cardType = data["card_type"] as? String
        cardExpireMonth = data["card_exp_month"] as? String
        cardExpireYear = data["card_exp_year"] as? String
        created = Helper.convertStringToDate(date: data["created_at"]  as! String)
        updated = Helper.convertStringToDate(date: data["updated_at"]  as! String)
    }

}
