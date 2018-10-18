//
//  BaseAuthenticationViewController.swift
//  Goto
//
//  Created by Admin on 15/01/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BaseAuthenticationViewController: UIViewController {
    
    /// Tool bar related
    var toolBarGO: AuthenticationToolBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        NotificationCenter.default.addObserver(self, selector: #selector(clickedBackButton), name: Notification.Name.CustomKeys.clickedBackButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedToolBarObject(notification:)), name: Notification.Name.CustomKeys.asignForToolBar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didClickedNext), name: Notification.Name.CustomKeys.clickedGoButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomKeys.clickedBackButton, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomKeys.asignForToolBar, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomKeys.clickedGoButton, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func changeNextButtonStatus(enabled: Bool, needForGO: Bool? = nil) {
        toolBarGO.btnGO.isEnabled = enabled
        if needForGO != nil {
            toolBarGO.btnGO.isEnabled = enabled || needForGO!
        }
        toolBarGO.changeUIWithValidation(isValid: enabled, needForGo: needForGO)
    }
    @objc func didClickedNext() {
        
    }
    func checkForGO() {
        
    }
    @objc func clickedBackButton() {
        
    }
    @objc func receivedToolBarObject(notification: NSNotification) {
        if let toolBar = notification.object as? AuthenticationToolBarView {
            toolBarGO = toolBar
            checkForGO()
            toolBarGO.showOtherButtons(show: self.isKind(of: PasswordViewController.self))
        }
    }
    @objc func textFieldDidChange(notification: NSNotification) {
        checkForGO()
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

