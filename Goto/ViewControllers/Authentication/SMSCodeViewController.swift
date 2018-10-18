//
//  SMSCodeViewController.swift
//  Goto
//
//  Created by Admin on 12/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SMSCodeViewController: BaseAuthenticationViewController {
    var phoneNumber = ""

    @IBOutlet weak var txtSMSCode: VSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtSMSCode.setFormatting("XXX - XXX", replacementChar: "X")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSMSCode.becomeFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.authenticationViewChanged, object: nil, userInfo: ["type" : TypeAutenticationView.smsView.rawValue])
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didClickedNext() {
        toolBarGO.showCircularProgress(isShow: true)
        APIRequests.sendRequest(type: .EnrollValidateCode(phoneNumber, txtSMSCode.text!), successHandler: { (data) in
            DispatchQueue.main.async {
                self.toolBarGO.showCircularProgress(isShow: false)
                if let exists = data!["exists"] as? Bool {
                    if exists {
                        self.performSegue(withIdentifier: SegueIDs.EmailViewController.rawValue, sender: nil)
                    } else {
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
        navigationController?.popViewController(animated: true)
    }
    override func checkForGO() {
        changeNextButtonStatus(enabled: (txtSMSCode.text?.count)! == 6)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueIDs.EmailViewController.rawValue {
            if let vc = segue.destination as? EmailViewController {
                vc.phoneNumber = phoneNumber
                vc.smsCode = txtSMSCode.text!
            }
        }
    }


}

