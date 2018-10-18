//
//  AuthenticationHomeViewController.swift
//  Goto
//
//  Created by Adrian Rusin on 1/23/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AuthenticationHomeViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var constraintHeightView: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var constraintBottomToolBar: NSLayoutConstraint!
    @IBOutlet weak var toolBarGO: AuthenticationToolBarView!

    private let heightTitleRect: CGFloat = 120
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        constraintHeightView.constant = heightTitleRect

        toolBarGO.initializeUI()
        toolBarGO.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationViewChanged(notification:)), name: Notification.Name.CustomKeys.authenticationViewChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        toolBarGO.showCircularProgress(isShow: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomKeys.authenticationViewChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.clickedBackButton, object: nil, userInfo: nil)
    }
    
    @objc func authenticationViewChanged(notification: Notification) {
        btnBack.setImage(#imageLiteral(resourceName: "icon_back"), for: .normal)
        toolBarGO.showCircularProgress(isShow: false)
        
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.asignForToolBar, object: toolBarGO, userInfo: nil)
        if let typeValue = notification.userInfo!["type"] as? Int, let type = TypeAutenticationView(rawValue: typeValue) {
            switch type {
            case .phoneView:
                lblTitle.text = "Enter your mobile number"
                break
            case .countryView:
                btnBack.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
                lblTitle.text = "Select a Country"
                break
            case .passwordView:
                if let name = notification.userInfo!["name"] as? String, name.count > 0 {
                    lblTitle.text = "Welcome back, " + name
                } else {
                    lblTitle.text = "Create Account"
                }
                break
            case .smsView:
                lblTitle.text = "Enter verification code"
                break
            case .emailView:
                lblTitle.text = "What's your email?"
                break
            case .signupView:
                lblTitle.text = "Create Account"
                break
            case .cardView:
                lblTitle.text = "Create Account"
                break
            default:
                break
            }
        }
    }
    func keyboardChangedNotification(isShow:Bool, duration: TimeInterval, frameKeyboard: CGRect) {
        constraintBottomToolBar.constant = frameKeyboard.size.height
        UIView.animate(withDuration: duration, animations: {
            self.toolBarGO.alpha = frameKeyboard.size.height > 0 ? 1 : 0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
        })
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segue_container" {
            if let vc = (segue.destination as! UINavigationController).viewControllers.first as? PhoneNumberViewController {
                vc.delegate = self
                vc.toolBarGO = toolBarGO
            }
        }
    }
    // MARK: - Keyboard Notifications
    @objc internal func keyboardWillShow(_ notification : Notification?) -> Void {
        if let info = notification?.userInfo, let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval, let kbFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            Helper.keyboardHeight = kbFrame.size.height
            keyboardChangedNotification(isShow: true, duration: duration, frameKeyboard: kbFrame)
        }
    }
    @objc internal func keyboardWillHide(_ notification : Notification?) -> Void {
        if let info = notification?.userInfo, let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            keyboardChangedNotification(isShow: false, duration: duration, frameKeyboard: CGRect.zero)
        }
    }

}
extension AuthenticationHomeViewController : PhoneNumberViewControllerDelegate {
    func changeContentView(isExtend: Bool) {
        var topSpace: CGFloat = 0
        if #available(iOS 11.0, *) {
            if view.safeAreaInsets.top > 20 {
                topSpace = view.safeAreaInsets.top + 20
            }
        } else {
            
        }
        constraintHeightView.constant = isExtend ? view.frame.size.height - topSpace - heightTitleRect : heightTitleRect
        
        UIView.animate(withDuration: 0.3, animations: {
            self.btnBack.alpha = isExtend ? 1 : 0
            self.lblTitle.alpha = isExtend ? 1 : 0
            self.view.layoutIfNeeded()
        }) { (isDone) in
        }

    }
}
extension AuthenticationHomeViewController : AuthenticationToolBarViewDelegate {
    func didGoClicked() {
        NotificationCenter.default.post(name: NSNotification.Name.CustomKeys.clickedGoButton, object: nil, userInfo: nil)
    }
}
