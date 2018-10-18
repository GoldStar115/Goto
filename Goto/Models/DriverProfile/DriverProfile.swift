//
//  DriverProfile.swift
//  Goto
//
//  Created by Admin on 14/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DriverProfile: NSObject, NSCoding {
    //    "id": 1,
    //    "car_color": null,
    //    "car_make": null,
    //    "car_plate": null,
    //    "legal_name": "Benedict Lewis",
    //    "licence_no": null,
    //    "online": true,
    //    "lock_by": null,
    //    "lock_quote_id": null,
    //    "lock_exp": null,
    //    "lock_rank": null,
    //    "enroute_to": null,
    //    "enroute_eta": null,
    //    "has_queued_ride": false,
    //    "last_ride_completed": null
    
    var id: Int
    //// Will need to update the correct data
    
    required override convenience init() {
        self.init(id: 0)
    }
    init(id: Int) {
        self.id = id
        
    }
    init(data: [String: AnyObject]) {
        id = data["id"] as! Int
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        id = aDecoder.decodeInteger(forKey: "id")
    }
    

}
