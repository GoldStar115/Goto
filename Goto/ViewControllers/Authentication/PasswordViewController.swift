//
//  PasswordViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import PKHUD
class PasswordViewController: BaseAuthenticationViewController {
    enum TypePassword: Int {
        case fromEmail = 0, fromPhone, fromSignup
    }
    var statusView = TypePassword.fromEmail
    var phoneNumber = ""
    var firstName = ""
    var smsCode = ""
    var email = ""

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var constraintTopText: NSLayoutConstraint!
    @IBOutlet weak var lblWarning: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUIBasedOnStatus()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtPassword.becomeFirstResponder()
        switch statusView {
        case .fromPhone, .fromEmail:
            NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.passwordView.rawValue, "name" : firstName])
            txtPassword.placeholder = "Enter your password"
            break
        case .fromSignup:
            NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.passwordView.rawValue])
            txtPassword.placeholder = "Enter a password"
            break
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    override func didClickedNext() {
        switch statusView {
        case .fromPhone:
            toolBarGO.showCircularProgress(isShow: true)
            APIRequests.sendRequest(type: .LoginWithPhone(phoneNumber, txtPassword.text!), successHandler: { (data) in
                DispatchQueue.main.async {
                    self.toolBarGO.showCircularProgress(isShow: false)
                   if data != nil {
                    self.lblWarning.isHidden = true
                        self.processResponseForAuthenticate(data: data)
                    }
                }
            }, failureHandler: { (error) in
                DispatchQueue.main.async {
                    self.toolBarGO.showCircularProgress(isShow: false)
                    self.toolBarGO.changeUIWithValidation(isValid: false, incorrectPassword: true)
                    Helper.showSingleAlert(fromVC: self, title: nil, message: error)
                    self.lblWarning.isHidden = false
                }
            })
            break
        case .fromEmail, .fromSignup:
            toolBarGO.showCircularProgress(isShow: true)
            APIRequests.sendRequest(type: .EnrollCommit(email, txtPassword.text!, phoneNumber, smsCode), successHandler: { (data) in
                DispatchQueue.main.async {
                    self.toolBarGO.showCircularProgress(isShow: false)
                    if data != nil {
                        self.lblWarning.isHidden = true
                        self.processResponseForAuthenticate(data: data)
                    }
                }
            }, failureHandler: { (error) in
                DispatchQueue.main.async {
                    self.toolBarGO.showCircularProgress(isShow: false)
                    self.toolBarGO.changeUIWithValidation(isValid: false, incorrectPassword: true)
                    self.lblWarning.isHidden = false
                    Helper.showSingleAlert(fromVC: self, title: nil, message: error)
                }
            })
            break
        }
    }
    override func checkForGO() {
        if txtPassword.text?.count == 0 {
            self.lblWarning.isHidden = true
        }
        changeNextButtonStatus(enabled: (txtPassword.text?.count)! >= 6)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUIBasedOnStatus() {
        switch statusView {
        case .fromSignup:
            lblTitle.isHidden = true
            constraintTopText.constant = 60
            break
        default:
            break
        }
    }
    func processResponseForAuthenticate(data: [String: AnyObject]?) {
        if data != nil {
            if let dicAuth = data!["auth"] as? [String: AnyObject] {
                SessionManager.shared.token = AuthModel(data: dicAuth)
                AuthModel.saveToDevice(auth: SessionManager.shared.token!)
            }
            if let dicUser = data!["user"] as? [String: AnyObject] {
                SessionManager.shared.user = User(data: dicUser)
                User.SaveToDevice(user: SessionManager.shared.user!)
            }
            if SessionManager.shared.loggedIn {
                switch statusView {
                case .fromPhone, .fromEmail:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "OriginNavigation")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = initialViewController
                    break
                case .fromSignup:
                    performSegue(withIdentifier: SegueIDs.SignupViewController.rawValue, sender: nil)
                     break
                }

            }
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

