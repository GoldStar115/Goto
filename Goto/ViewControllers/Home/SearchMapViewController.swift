//
//  SearchMapViewController.swift
//  Goto
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Mapbox

class SearchMapViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var constraintHeightTopView: NSLayoutConstraint!
    @IBOutlet weak var constraintTop_TopView: NSLayoutConstraint!
    @IBOutlet weak var constraintTraillingTopView: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingTopView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var topView: TopViewInSearch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MGLMapView!
    
    private let arrayInitialTitles = ["Add Home", "Add Work", "Set location on map", "Enter destination later"]
    private let arrayTempLocations = ["San Francisco", "San Francisco Country", "San Francisco International Airport", "San Francisco Zoo"]
    private let arrayTempLocationsSub = ["CA", "CA", "San Francisco, CA", "Sloat Boulevard, San Francisco, CA"]
    private var isSearching = false
    private var isSelectedCurrentLocationButton = false
    private var isNeedUpdateTitleFromMap = false
    private var isInitialLoading = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changeViewElements(isExpand: false, animate: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: nil)
        UserLocation.sharedInstance.delegate = self
        updateMapToCurrentLocation()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        changeViewElements(isExpand: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        view.endEditing(true)
        changeViewElements(isExpand: false)
    }
    @IBAction func onCurrentLocation(_ sender: Any) {
        view.endEditing(true)
        isSelectedCurrentLocationButton = true
        changeSelectedUI()
    }
    func updateMapToCurrentLocation() {
        if let currentLocation = UserLocation.sharedInstance.currentLocation {
            mapView.setCenter(currentLocation.coordinate, zoomLevel: 12, animated: true)
        }
    }
    func changeViewElements(isExpand:Bool, animate: Bool = true) {
        constraintTop_TopView.constant = isExpand ? -20 : 60
        constraintLeadingTopView.constant = isExpand ? -16 : 4
        constraintTraillingTopView.constant = isExpand ? -16 : 4
        constraintHeightTopView.constant = isExpand ? 50 + 80 : 50
        constraintHeightTableView.constant = isExpand ? view.frame.size.height - 130 : 0
        btnBack.alpha = 0
        
        topView.changeViewElements(isExpand: isExpand, widthScreen: view.frame.size.width, animate: animate)
        if !animate {
            return
        }
        if isExpand {
            perform(#selector(changeCancelButton), with: nil, afterDelay: 0.15)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (isDone) in
            if !isExpand {
                self.topView.isHidden = true
                self.dismiss(animated: false, completion: {
                    
                })
            } else {
                self.topView.txtSearch.becomeFirstResponder()
            }
        }

    }
    @objc func changeCancelButton() {
        UIView.animate(withDuration: 0.15) {
            self.btnBack.alpha = 1
        }
    }
    func changeSelectedUI() {
        topView.viewSearchBar.backgroundColor = isSelectedCurrentLocationButton ? UIColor(white: 200.0 / 255.0, alpha: 0.6) : UIColor(white: 200.0 / 255.0, alpha: 0.4)
        topView.btnCurrentLocation.backgroundColor = isSelectedCurrentLocationButton ? UIColor(white: 200.0 / 255.0, alpha: 0.6) : UIColor(white: 200.0 / 255.0, alpha: 0.4)
        
        showHiddenTableView(isShow: !isSelectedCurrentLocationButton)
    }
    func showHiddenTableView(isShow: Bool) {
        updateMapToCurrentLocation()
        isNeedUpdateTitleFromMap = !isShow
        constraintHeightTableView.constant = isShow ? view.frame.size.height - 130 : 0
        if !isShow {
            view.endEditing(true)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (isDone) in
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
extension SearchMapViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isInitialLoading {
            isInitialLoading = false
            return
        }
        isSelectedCurrentLocationButton = false
        changeSelectedUI()

    }
    @objc func textFieldDidChange(notification: NSNotification) {
        isSearching = (topView.txtSearch.text?.count)! > 0
        tableView.reloadData()
    }
}
extension SearchMapViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return arrayTempLocations.count + 1
        }
        return arrayInitialTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching, indexPath.row < arrayTempLocations.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_location") as! SearchLocationTableViewCell
            cell.imgLocation.image = #imageLiteral(resourceName: "location_pin")
            cell.lblTitle.text = arrayTempLocations[indexPath.row]
            cell.lblSubTitle.text = arrayTempLocationsSub[indexPath.row]
            return cell

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchCategoryTableViewCell
        if isSearching {
            cell.imgCategory.image = #imageLiteral(resourceName: "location_pin")
            cell.lblName.text = "Set location on map"
        } else {
            cell.imgCategory.image = indexPath.row == 2 ? #imageLiteral(resourceName: "location_pin") : #imageLiteral(resourceName: "work_icon")
            cell.lblName.text = arrayInitialTitles[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearching {
            if indexPath.row == arrayTempLocations.count {
                showHiddenTableView(isShow: false)
            }
        } else {
            if indexPath.row == 2 {
                showHiddenTableView(isShow: false)
            }
        }
    }
}
extension SearchMapViewController: UserLocationDelegate {
    func firstGotLocation() {
        updateMapToCurrentLocation()
        
    }
}
extension SearchMapViewController: MGLMapViewDelegate {
    func updateTitleFromMap(strTitle: String) {
        if !isNeedUpdateTitleFromMap {
            return
        }
        DispatchQueue.main.async {
            if self.isSelectedCurrentLocationButton {
                self.topView.btnCurrentLocation.setTitle(strTitle, for: .normal)
            } else {
                self.topView.txtSearch.text = strTitle
            }
        }
    }
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        updateTitleFromMap(strTitle: "Loading...")
        UserLocation.getAddress(fromLocation: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude), successHandler: { (address) in
            self.updateTitleFromMap(strTitle: address!)
        }) { (error) in
            self.updateTitleFromMap(strTitle: "Unnamed Road")
        }
    }
}
