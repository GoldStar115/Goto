//
//  Helper.swift
//  Goto
//
//  Created by Admin on 14/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CCValidator


class Helper: NSObject {
    static var keyboardHeight: CGFloat?
    //verify the validity of email
    static func validateEmail(candidate: String?) -> Bool {
        if candidate == nil {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    //convert string time to date  "2018-01-12T10:16:02.726Z"
    static func convertStringToDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: date)
    }
    static func convertStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: date)
    }
    //convert string time to date  with formated string
    static func convertStringToDate(date: String, formatedString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatedString
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: date)
    }

    static func showSingleAlert(fromVC: UIViewController, title: String?, message: String?, btnTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default, handler: { action in
        }))
        fromVC.present(alert, animated: true, completion: nil)

    }
    
    static func getCardImageFromType(type: CreditCardType) -> UIImage {
        switch type {
        case .AmericanExpress:
            return #imageLiteral(resourceName: "amex")
        case .Dankort:
            return #imageLiteral(resourceName: "default")
        case .DinersClub:
            return #imageLiteral(resourceName: "diners")
        case .Discover:
            return #imageLiteral(resourceName: "discover")
        case .JCB:
            return #imageLiteral(resourceName: "jcb")
        case .Maestro:
            return #imageLiteral(resourceName: "maestro")
        case .MasterCard:
            return #imageLiteral(resourceName: "mastercard")
        case .UnionPay:
            return #imageLiteral(resourceName: "unionpay")
        case .VisaElectron:
            return #imageLiteral(resourceName: "visa")
        case .Visa:
            return #imageLiteral(resourceName: "visa")
        case .NotRecognized:
            return #imageLiteral(resourceName: "default")
        }
    }
}
