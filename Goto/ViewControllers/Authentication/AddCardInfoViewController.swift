//
//  AddCardInfoViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CCValidator

class AddCardInfoViewController: BaseAuthenticationViewController {
    var isSignup = true
    
    @IBOutlet weak var txtCardNumber: VSTextField!
    @IBOutlet weak var txtExpireDate: VSTextField!
    @IBOutlet weak var txtCvv: VSTextField!
    @IBOutlet weak var imgCard: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtCardNumber.setFormatting("xxxx xxxx xxxx xxxx", replacementChar: "x")
        txtExpireDate.setFormatting("xx / xx", replacementChar: "x")
        txtCvv.setFormatting("xxx", replacementChar: "x")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtCardNumber.becomeFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.cardView.rawValue])
        
    }
    override func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    override func didClickedNext() {
        if !validationTextFields() {
            return
        }
        if SessionManager.shared.loggedIn {
            let cardData = CardInfo()
            cardData.cardHolderName = SessionManager.shared.user?.getFullName()
            cardData.cardNumber = txtCardNumber.text
            cardData.CVV = txtCvv.text
            cardData.expirationMonth = (txtExpireDate.text as NSString).substring(to: 2)
            cardData.expirationYear = "20" + (txtExpireDate.text as NSString).substring(from: 2)
            
            let blillingAddress = BillingAddress()
            blillingAddress.firstName = SessionManager.shared.user?.firstName
            blillingAddress.lastName = SessionManager.shared.user?.lastName
            blillingAddress.country = "PL"
            blillingAddress.email = SessionManager.shared.user?.email
            blillingAddress.zip = SessionManager.shared.user?.postCode
            
            toolBarGO.showCircularProgress(isShow: true)
            APIRequests.sendRequest(type: .GetPaymentSessionToken(), showProgress: true, successHandler: { (data) in
                if let session_token = data!["session_token"] as? String {
                    APIRequests.sendRequest(type: .CreatePaymentTempToken(session_token, "\((SessionManager.shared.user?.id)!)", cardData, blillingAddress), showProgress: true, successHandler: { (data_) in
                        if let ccTempToken = data_!["ccTempToken"] as? String, let status = data_!["status"] as? String, status == "SUCCESS" { //, let isVerified = data_!["isVerified"] as? Bool, isVerified {
                            APIRequests.sendRequest(type: .UserAddPaymentMethod(ccTempToken), showProgress: true, successHandler: { (data) in
                                DispatchQueue.main.async {
                                    self.toolBarGO.showCircularProgress(isShow: false)
                                    let card = PaymentCardModel(data: data!)
                                    if card.id > 0 {
                                        if self.isSignup {
                                            self.gotoHomePage()
                                        } else {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            }, failureHandler: { (error) in
                                DispatchQueue.main.async {
                                    self.toolBarGO.showCircularProgress(isShow: false)
                                    Helper.showSingleAlert(fromVC: self, title: nil, message: error)
                                }
                            })
                        } else {
                            DispatchQueue.main.async {
                                self.toolBarGO.showCircularProgress(isShow: false)
                            }
                        }
                    }, failureHandler: { (error) in
                        DispatchQueue.main.async {
                            self.toolBarGO.showCircularProgress(isShow: false)
                            Helper.showSingleAlert(fromVC: self, title: nil, message: error)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.toolBarGO.showCircularProgress(isShow: false)
                    }
                }
            }, failureHandler: { (error) in
                DispatchQueue.main.async {
                    self.toolBarGO.showCircularProgress(isShow: false)
                    Helper.showSingleAlert(fromVC: self, title: nil, message: error)
                }
            })
        }
    }
    override func checkForGO() {
        if txtCardNumber.isEditing {
            let recognizedType = CCValidator.typeCheckingPrefixOnly(creditCardNumber: txtCardNumber.text)
            imgCard.image = Helper.getCardImageFromType(type: recognizedType)
            if recognizedType == .AmericanExpress {
                txtCardNumber.setFormatting("xxxx xxxxxx xxxxx", replacementChar: "x")
            } else {
                txtCardNumber.setFormatting("xxxx xxxx xxxx xxxx", replacementChar: "x")
            }
        }
        changeNextButtonStatus(enabled: validationTextFields(isOlnyCheck: true), needForGO: getNeedForGO())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validationTextFields(isOlnyCheck: Bool = false) -> Bool {
        if txtCardNumber.text.count != txtCardNumber.formattingPattern.removeSpecial.count {
            if !isOlnyCheck {
                txtCardNumber.becomeFirstResponder()
            }
            return false
        }
        if txtExpireDate.text.count != txtExpireDate.formattingPattern.removeSpecial.count {
            if !isOlnyCheck {
                txtExpireDate.becomeFirstResponder()
            }
            return false
        }
        if txtCvv.text.count != txtCvv.formattingPattern.count {
            if !isOlnyCheck {
                txtCvv.becomeFirstResponder()
            }
            return false
        }
        return true
    }
    func getNeedForGO() -> Bool? {
        if txtCardNumber.isEditing {
            return txtCardNumber.text.count == txtCardNumber.formattingPattern.removeSpecial.count
        }
        if txtExpireDate.isEditing {
            return txtExpireDate.text.count == txtExpireDate.formattingPattern.removeSpecial.count
        }
        if txtCvv.isEditing {
            return txtCvv.text.count == txtCvv.formattingPattern.count
        }
        return nil
    }

    func gotoHomePage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "OriginNavigation")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = initialViewController

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
extension AddCardInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if txtCardNumber == textField {
            toolBarGO.changeForGOButton(isValid: validationTextFields(isOlnyCheck: true), needForGo: txtCardNumber.text.count == txtCardNumber.formattingPattern.removeSpecial.count)
        }
        if txtExpireDate == textField {
            toolBarGO.changeForGOButton(isValid: validationTextFields(isOlnyCheck: true), needForGo: txtExpireDate.text.count == txtExpireDate.formattingPattern.removeSpecial.count)
        }
        if txtCvv == textField {
            toolBarGO.changeForGOButton(isValid: validationTextFields(isOlnyCheck: true), needForGo: txtCvv.text.count == txtCvv.formattingPattern.removeSpecial.count)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didClickedNext()
        return true
    }
}
