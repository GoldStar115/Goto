//
//  Extentions.swift
//  Goto
//
//  Created by Admin on 13/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    var removeSpecial: String {
        return components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
    }
    public var emojiFlag: String {
        let country = self.uppercased()
        let emoji = country.unicodeScalars.flatMap { UnicodeScalar(127397 + $0.value) }.map { String($0) }.joined()
        return emoji
    }
}
extension Notification.Name {
    public struct CustomKeys {
        public static let authenticationViewChanged = Notification.Name(rawValue: "authenticationViewChanged")
        public static let clickedBackButton = Notification.Name(rawValue: "clickedBackButton")
        public static let asignForToolBar = Notification.Name(rawValue: "asignForToolBar")
        public static let clickedGoButton = Notification.Name(rawValue: "clickedGoButton")
    }
}
extension UIColor {
    static var invalidColor : UIColor {
        return  UIColor(red: 165.0 / 255.0, green: 165.0 / 255.0, blue: 173.0 / 255.0, alpha: 1)
    }
    static var validColor : UIColor {
        return  UIColor(red: 87.0 / 255.0, green: 227.0 / 255.0, blue: 195.0 / 255.0, alpha: 1)
    }
}
