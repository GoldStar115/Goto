//
//  User.swift
//  Goto
//
//  Created by Admin on 14/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var id: Int
    var email: String
    var phoneNumber: String
    var firstName: String?
    var lastName: String?
    var postCode: String?
    var profilePhoto: String?
    var balance: Float
    var safeChargeEnrolled: Bool
    var driverEnrolled: Bool
    var driverDispatchID: Int?
    var driverProfileID: Int?
    var lastRideStatus: String?
    var lastRideActive: String?
    var driverProfile: DriverProfile?
    var created: Date?
    var updated: Date?

    required override convenience init() {
        self.init(id: 0)
    }
    init(id: Int) {
        self.id = id
        email = ""
        phoneNumber = ""
        balance = 0
        safeChargeEnrolled = false
        driverEnrolled = false
        super.init()
    }
    init(data: [String: AnyObject]) {
        id = data["id"] as! Int
        email = data["email"] as! String
        phoneNumber = data["phone_number"] as! String
        firstName = data["first_name"] as? String
        lastName = data["last_name"] as? String
        postCode = data["post_code"] as? String
        profilePhoto = data["photo"] as? String
        if let strBalance = data["balance"] as? String {
            balance = Float(strBalance)!
        } else {
            balance = 0
        }
        safeChargeEnrolled = data["safecharge_enrolled"] as! Bool
        driverEnrolled = data["driver_enrolled"] as! Bool
        driverDispatchID = data["driver_dispatch_id"] as? Int
        driverProfileID = data["driver_profile_id"] as? Int
        if let dicDriver = data["driver_profile"] as? [String: AnyObject] {
            driverProfile = DriverProfile(data: dicDriver)
        }
        if let created = data["created_at"]  as? String { self.created = Helper.convertStringToDate(date: created)}
        if let updated = data["updated_at"]  as? String { self.updated = Helper.convertStringToDate(date: updated)}
        lastRideStatus = data["last_ride_status"] as? String
        lastRideActive = data["last_ride_active"] as? String

    }
    static func SaveToDevice(user: User) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: "CurrentUser")
        UserDefaults.standard.synchronize()
    }
    static func LoadFromDevice() -> User? {
        let data  = UserDefaults.standard.object(forKey: "CurrentUser") as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? User
    }
    static func removeFromDevice() {
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
    }

    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        if let firstName = firstName { aCoder.encode(firstName, forKey: "firstName")}
        if let lastName = lastName { aCoder.encode(lastName, forKey: "lastName")}
        if let postCode = postCode { aCoder.encode(postCode, forKey: "postCode")}
        if let profilePhoto = profilePhoto { aCoder.encode(profilePhoto, forKey: "profilePhoto")}
        aCoder.encode(balance, forKey: "balance")
        aCoder.encode(safeChargeEnrolled, forKey: "safeChargeEnrolled")
        aCoder.encode(driverEnrolled, forKey: "driverEnrolled")
        if let driverDispatchID = driverDispatchID { aCoder.encode(driverDispatchID, forKey: "driverDispatchID")}
        if let driverProfileID = driverProfileID { aCoder.encode(driverProfileID, forKey: "driverProfileID")}
        if let lastRideStatus = lastRideStatus { aCoder.encode(lastRideStatus, forKey: "lastRideStatus")}
        if let lastRideActive = lastRideActive { aCoder.encode(lastRideActive, forKey: "lastRideActive")}
        if let driverProfile = driverProfile { aCoder.encode(driverProfile, forKey: "driverProfile")}
        if let created = created { aCoder.encode(created, forKey: "created")}
        if let updated = updated { aCoder.encode(updated, forKey: "updated")
        }}
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        id = aDecoder.decodeInteger(forKey: "id")
        email = aDecoder.decodeObject(forKey: "email") as! String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        postCode = aDecoder.decodeObject(forKey: "postCode") as? String
        profilePhoto = aDecoder.decodeObject(forKey: "profilePhoto") as? String
        balance = aDecoder.decodeFloat(forKey: "balance")
        safeChargeEnrolled = aDecoder.decodeBool(forKey: "safeChargeEnrolled")
        driverEnrolled = aDecoder.decodeBool(forKey: "driverEnrolled")
        driverDispatchID = aDecoder.decodeInteger(forKey: "driverDispatchID")
        driverProfileID = aDecoder.decodeInteger(forKey: "driverProfileID")
        lastRideStatus = aDecoder.decodeObject(forKey: "lastRideStatus") as? String
        lastRideActive = aDecoder.decodeObject(forKey: "lastRideActive") as? String
        driverProfile = aDecoder.decodeObject(forKey: "driverProfile") as? DriverProfile
        created = aDecoder.decodeObject(forKey: "created") as? Date
        updated = aDecoder.decodeObject(forKey: "updated") as? Date
    }
    // MARK: - Methods
    func getFullName() -> String {
        var strName = ""
        if firstName != nil {
            strName = firstName!
        }
        if lastName != nil, (lastName?.count)! > 0 {
            if firstName != nil, (firstName?.count)! > 0 {
                strName += " " + lastName!
            } else {
                strName = lastName!
            }
        }
        return strName
    }


}
