//
//  PhoneNumberViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import PhoneNumberKit

@objc protocol PhoneNumberViewControllerDelegate {
    @objc optional func changeContentView(isExtend: Bool)
}

class PhoneNumberViewController: BaseAuthenticationViewController {
    var delegate: PhoneNumberViewControllerDelegate?

    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var txtPhoneNumber: VSTextField!
    @IBOutlet weak var lblPhoneCode: UILabel!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var constraintFlagTop: NSLayoutConstraint!
    @IBOutlet weak var viewHowItWorks: UIView!
    @IBOutlet weak var viewTextSeparator: UIView!
    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var countryPickerView: GTCountryPickerView!
    @IBOutlet weak var constraintHeightCountryPicker: NSLayoutConstraint!
    @IBOutlet weak var lblCountryFlag: UILabel!
    
    
    private var isPhoneNumberEdition = false
    private var isCountryTapped = false
    private var isCountryPickerShown = false
    private let phoneNumberKit = PhoneNumberKit()
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countryPickerView.delegate = self
        if let country = countryPickerView.configureCountryPickerView() {
            updatePhoneFormat(country: country)
            lblCountryFlag.text = country.emojiFlag

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPhoneNumberEdition {
            txtPhoneNumber.becomeFirstResponder()
        }
        isCountryPickerShown = false
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.phoneView.rawValue])
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didClickedNext() {
        let (isValid, strPhone) = validatePhoneNumber()
        if !isValid {
            return
        }
        toolBarGO.showCircularProgress(isShow: true)
        APIRequests.sendRequest(type: .EnrollCheckAccount(strPhone), successHandler: { (data) in
            DispatchQueue.main.async {
                self.toolBarGO.showCircularProgress(isShow: false)
                if let exists = data!["exists"] as? Bool {
                    if exists {
                        if let first_name = data!["first_name"] as? String {
                            self.performSegue(withIdentifier: SegueIDs.PasswordViewController.rawValue, sender: ["phone": strPhone.digits, "first_name": first_name])
                        } else {
                            self.performSegue(withIdentifier: SegueIDs.PasswordViewController.rawValue, sender: ["phone": strPhone.digits, "first_name": ""])
                        }
                        
                    } else {
                        self.performSegue(withIdentifier: SegueIDs.SMSCodeViewController.rawValue, sender: ["phone": strPhone.digits])
                    }
                } else {
                }
            }
        }, failureHandler: { (error) in
            DispatchQueue.main.async {
                self.toolBarGO.showCircularProgress(isShow: false)
                Helper.showSingleAlert(fromVC: self, title: nil, message: error)
            }
        })
    }
    override func clickedBackButton() {
        if isCountryPickerShown {
            showCountryPickerView(show: false)
        } else {
            hidePhoneNumberInput()
            delegate?.changeContentView!(isExtend: false)
        }
    }
    override func checkForGO() {
        if countryPickerView.selectedCountry?.code == "GB", txtPhoneNumber.text.count == 1 {
            if (txtPhoneNumber.text?.hasPrefix("0"))! {
                txtPhoneNumber.tempFormattingPattern = (countryPickerView.selectedCountry?.placeholderFormat)!
                txtPhoneNumber.setFormatting((countryPickerView.selectedCountry?.placeholderFormat)!, replacementChar: "X")
            } else {
                txtPhoneNumber.tempFormattingPattern = "XXXX XXXXXX"
                txtPhoneNumber.setFormatting("XXXX XXXXXX", replacementChar: "X")
            }
        }
        let (isValid, _) = validatePhoneNumber()
        changeNextButtonStatus(enabled: isValid)
    }
    func validatePhoneNumber() -> (Bool, String) {
        do {
            let strPhone = lblPhoneCode.text! + txtPhoneNumber.text!
            let phoneNumber = try phoneNumberKit.parse(strPhone, withRegion: (countryPickerView.selectedCountry?.code)!, ignoreType: true)
            print(String(phoneNumber.countryCode) + String(phoneNumber.nationalNumber))
            return (true, String(phoneNumber.countryCode) + String(phoneNumber.nationalNumber))
        }
        catch {
            return (false, "")
        }
    }
    func updatePhoneFormat(country: GTCountry) {
        txtPhoneNumber.placeholder = country.placeholderTextField
        txtPhoneNumber.tempFormattingPattern = country.placeholderFormat
        txtPhoneNumber.setFormatting(country.placeholderFormat, replacementChar: "X")
        txtPhoneNumber.allowMaxLength = 100
        
        lblPhoneCode.text = country.phoneCode
        txtPhoneNumber.text = ""
        changeNextButtonStatus(enabled: false)
    }
    func showPhoneNumberInput() {
        if isPhoneNumberEdition {return}
        isPhoneNumberEdition = true
        constraintFlagTop.constant = 80
        UIView.animate(withDuration: 0.3, animations: {
            self.viewHowItWorks.alpha = 0
            self.viewTextSeparator.alpha = 1
            self.toolBarGO.alpha = 1
            self.view.layoutIfNeeded()
        }) { (isDone) in
            self.btnPhoneNumber.isHidden = true
            self.lblHint.isHidden = true
            self.txtPhoneNumber.isHidden = false
            if self.isCountryTapped {
                self.onTapCountryFlag(UIButton())
            } else {
                self.txtPhoneNumber.becomeFirstResponder()
            }
        }
    }
    func hidePhoneNumberInput() {
        if !isPhoneNumberEdition {return}
        isPhoneNumberEdition = false
        constraintFlagTop.constant = 25
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewHowItWorks.alpha = 1
            self.viewTextSeparator.alpha = 0
            self.toolBarGO.alpha = 0
            self.view.layoutIfNeeded()
        }) { (isDone) in
            self.btnPhoneNumber.isHidden = false
            self.lblHint.isHidden = false
            self.txtPhoneNumber.isHidden = true
        }
    }
    func showCountryPickerView(show: Bool) {
        toolBarGO.isHidden = show
        constraintHeightCountryPicker.constant = show ? view.frame.size.height : 0
        if show {
            countryPickerView.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            countryPickerView.clearSearchText()
            NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.phoneView.rawValue])
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (isDone) in
            if !show {
                if self.isPhoneNumberEdition {
                    self.txtPhoneNumber.becomeFirstResponder()
                }
                self.isCountryPickerShown = false
            }
        }
    }
    @IBAction func onTapCountryFlag(_ sender: Any) {
        if !isPhoneNumberEdition {
            isCountryTapped = true
            showPhoneNumberInput()
            self.delegate?.changeContentView!(isExtend: true)
            return
        }
        view.endEditing(true)
        showCountryPickerView(show: true)
        isCountryPickerShown = true
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.countryView.rawValue])
    }
    @IBAction func onPhoneNumber(_ sender: Any) {
        isCountryTapped = false
        showPhoneNumberInput()
        self.delegate?.changeContentView!(isExtend: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueIDs.PasswordViewController.rawValue {
            if let vc = segue.destination as? PasswordViewController, let dicData = sender as? [String: String], let phoneNumber = dicData["phone"], let first_name = dicData["first_name"] {
                vc.statusView = .fromPhone
                vc.phoneNumber = phoneNumber
                vc.firstName = first_name
            }
        }
        if segue.identifier == SegueIDs.SMSCodeViewController.rawValue {
            if let vc = segue.destination as? SMSCodeViewController, let dicData = sender as? [String: String], let phoneNumber = dicData["phone"] {
                vc.phoneNumber = phoneNumber
            }
        }
    }


}
extension PhoneNumberViewController : GTCountryPickerViewDelegate {
    func didSelectedCountry(pickerView: GTCountryPickerView, selectedCountry: GTCountry) {
        DispatchQueue.main.async {
            self.updatePhoneFormat(country: selectedCountry)
            self.lblCountryFlag.text = selectedCountry.emojiFlag
            self.showCountryPickerView(show: false)
        }
    }
}
