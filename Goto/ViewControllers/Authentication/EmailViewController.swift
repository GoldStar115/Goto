//
//  EmailViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class EmailViewController: BaseAuthenticationViewController {
    var phoneNumber = ""
    var smsCode = ""

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.becomeFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.emailView.rawValue])
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didClickedNext() {
        toolBarGO.showCircularProgress(isShow: true)
        APIRequests.sendRequest(type: .EnrollValidateEmail(txtEmail.text!), successHandler: { (data) in
            DispatchQueue.main.async {
                if let exists = data!["exists"] as? Bool {
                    if exists {
                        if let first_name = data!["first_name"] as? String {
                            self.performSegue(withIdentifier: SegueIDs.PasswordViewController.rawValue, sender: ["first_name": first_name])
                        } else {
                            self.performSegue(withIdentifier: SegueIDs.PasswordViewController.rawValue, sender: ["first_name": ""])
                        }

                    } else {
                        self.performSegue(withIdentifier: SegueIDs.PasswordViewController.rawValue, sender: nil)
                    }

                } else {
                }
                self.toolBarGO.showCircularProgress(isShow: false)

            }
        }, failureHandler: { (error) in
            DispatchQueue.main.async {
                self.toolBarGO.showCircularProgress(isShow: false)
                Helper.showSingleAlert(fromVC: self, title: nil, message: error)
            }
        })
    }
    override func clickedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    override func checkForGO() {
        changeNextButtonStatus(enabled: Helper.validateEmail(candidate: txtEmail.text))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueIDs.PasswordViewController.rawValue {
            if let vc = segue.destination as? PasswordViewController {
                vc.email = self.txtEmail.text!
                vc.phoneNumber = phoneNumber
                if let dicData = sender as? [String: String], let first_name = dicData["first_name"] {
                    vc.statusView = .fromEmail
                    vc.firstName = first_name
                } else {
                    vc.statusView = .fromSignup
                    vc.smsCode = smsCode
                }
            }
        }
    }

}

