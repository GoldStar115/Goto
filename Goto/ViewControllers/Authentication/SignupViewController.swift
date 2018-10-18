//
//  SignupViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SignupViewController: BaseAuthenticationViewController {
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFirstName.becomeFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.signupView.rawValue])

    }
    override func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    override func didClickedNext() {
        if !validationTextFields() {
            return
        }
        toolBarGO.showCircularProgress(isShow: true)
        APIRequests.sendRequest(type: .UpdateMe(txtFirstName.text!, txtLastName.text!, txtPostCode.text!), successHandler: { (data) in
            DispatchQueue.main.async {
                self.toolBarGO.showCircularProgress(isShow: false)
                if let success = data!["success"] as? Bool, success {
                    SessionManager.shared.user?.firstName = self.txtFirstName.text
                    SessionManager.shared.user?.lastName = self.txtLastName.text
                    SessionManager.shared.user?.postCode = self.txtPostCode.text
                    User.SaveToDevice(user: SessionManager.shared.user!)
                    self.performSegue(withIdentifier: SegueIDs.AddCardInfoViewController.rawValue, sender: nil)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.toolBarGO.showCircularProgress(isShow: false)
                Helper.showSingleAlert(fromVC: self, title: nil, message: error)
            }
        }
    }
    override func checkForGO() {
        changeNextButtonStatus(enabled: validationTextFields(isOlnyCheck: true), needForGO: getNeedForGO())

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func validationTextFields(isOlnyCheck: Bool = false) -> Bool {
        if txtFirstName.text?.count == 0 {
            if !isOlnyCheck {
                txtFirstName.becomeFirstResponder()
            }
            return false
        }
        if txtLastName.text?.count == 0 {
            if !isOlnyCheck {
                txtLastName.becomeFirstResponder()
            }
            return false
        }
        if txtPostCode.text?.count == 0 {
            if !isOlnyCheck {
                txtPostCode.becomeFirstResponder()
            }
            return false
        }
        return true
    }
    func getNeedForGO() -> Bool? {
        if txtFirstName.isEditing {
            return (txtFirstName.text?.count)! > 0
        }
        if txtLastName.isEditing {
            return (txtLastName.text?.count)! > 0
        }
        if txtPostCode.isEditing {
            return (txtPostCode.text?.count)! > 0
        }
        return nil
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
extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        toolBarGO.changeForGOButton(isValid: validationTextFields(isOlnyCheck: true), needForGo: (textField.text?.count)! > 0)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didClickedNext()
        return true
    }
}
