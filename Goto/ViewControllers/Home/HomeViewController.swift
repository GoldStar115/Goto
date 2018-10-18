//
//  HomeViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SideMenuController
import Mapbox

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sideMenuController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        UserLocation.sharedInstance.delegate = self
        updateMapToCurrentLocation()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onMenu(_ sender: Any) {
        sideMenuController?.toggle()
    }
    @IBAction func onWhereTo(_ sender: Any) {
    }
    
    func updateMapToCurrentLocation() {
        if let currentLocation = UserLocation.sharedInstance.currentLocation {
            mapView.setCenter(currentLocation.coordinate, zoomLevel: 12, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeViewController: SideMenuControllerDelegate {
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        
    }
    
    
}
extension HomeViewController: UserLocationDelegate {
    func firstGotLocation() {
        updateMapToCurrentLocation()
    }
}
