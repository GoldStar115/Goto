//
//  UserLocation.swift
//  Goto
//
//  Created by Adrian Rusin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapboxGeocoder

@objc protocol UserLocationDelegate {
    @objc optional func firstGotLocation()
    @objc optional func locationChange()
}

class UserLocation: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = UserLocation()
    var currentLocation: CLLocation?
    var delegate: UserLocationDelegate?
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    static func getAddress(fromLocation:CLLocation, successHandler: @escaping (String?) -> Void, failureHandler: @escaping (Error?) -> Void) {
        let geocoder = Geocoder.shared
        let options = ReverseGeocodeOptions(location: fromLocation)
        
        options.allowedScopes = [.address, .pointOfInterest]
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                failureHandler(nil)
                return
            }
            if placemark.name.count > 0 {
                successHandler(placemark.name)
            } else {
                failureHandler(nil)
            }
         }
    }

    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.last
            self.delegate?.firstGotLocation?()
        } else {
            currentLocation = locations.last
        }
        
        delegate?.locationChange?()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
