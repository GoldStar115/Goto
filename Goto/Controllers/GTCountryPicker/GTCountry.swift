//
//  GTCountry.swift
//  Goto
//
//  Created by Adrian Rusin on 1/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class GTCountry: NSObject {
    var name : String!
    var emojiFlag : String!
    var phoneCode : String!
    var code : String!
    var placeholderFormat : String!
    var placeholderTextField : String!

    init(json: [String : String]) {
        name = json["name"]
        phoneCode = json["dial_code"]
        code = json["code"]
        emojiFlag = code.emojiFlag
        if let format = CountryFormat.dicFormats[code] {
            placeholderFormat = format.replacingOccurrences(of: phoneCode + " ", with: "")
            placeholderTextField = CountryFormat.dicPlaceHolder[code]
        } else {
            placeholderFormat = "(XXX) XXX-XXXX"
            phoneCode = "+1"
            placeholderTextField = "(201) 555-0123"
        }
    }
}
