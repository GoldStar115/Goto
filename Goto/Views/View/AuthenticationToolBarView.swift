//
//  AuthenticationToolBarView.swift
//  Goto
//
//  Created by Adrian Rusin on 1/23/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
@objc protocol AuthenticationToolBarViewDelegate {
    @objc optional func didGoClicked()
}

class AuthenticationToolBarView: UIView {
    var delegate: AuthenticationToolBarViewDelegate?

    @IBOutlet weak var btnGO: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnDontHaveAccount: UIButton!
    @IBOutlet weak var circleProgress: RPCircularProgress!

    func initializeUI() {
        circleProgress.thicknessRatio = 0.1
        circleProgress.indeterminateDuration = 1
    }
    @IBAction func btnGo(_ sender: Any) {
        delegate?.didGoClicked!()
    }
    @IBAction func onForgotPassword(_ sender: Any) {
    }
    @IBAction func onDontHaveAccount(_ sender: Any) {
    }
    func showCircularProgress(isShow: Bool) {
        btnGO.isHidden = isShow
        circleProgress.isHidden = !isShow
        circleProgress.progressTintColor = .black
        if isShow {
            circleProgress.enableIndeterminate()
        }
    }
    func showOtherButtons(show: Bool) {
        btnDontHaveAccount.isHidden = !show
        btnForgotPassword.isHidden = !show

    }
    func changeUIWithValidation(isValid: Bool, incorrectPassword: Bool? = nil, needForGo: Bool? = nil) {
        backgroundColor = isValid ? .validColor : .invalidColor
        btnGO.backgroundColor = isValid ? .validColor : .invalidColor
        btnGO.setTitleColor(isValid ? .black : .white, for: .normal)
        if incorrectPassword != nil, incorrectPassword! {
            backgroundColor = .invalidColor
            btnGO.backgroundColor = .validColor
            btnGO.setTitleColor(.black, for: .normal)
        }
        if needForGo != nil {
//            backgroundColor = needForGo! ? .validColor : .invalidColor
//            btnGO.backgroundColor = needForGo! ? .validColor : .invalidColor
//            btnGO.setTitleColor(needForGo! ? .black : .white, for: .normal)
        }
        if btnForgotPassword != nil, btnDontHaveAccount != nil, incorrectPassword != nil {
            btnForgotPassword.isHidden = false
            btnDontHaveAccount.isHidden = false
            if isValid, !incorrectPassword! {
                btnForgotPassword.isHidden = true
                btnDontHaveAccount.isHidden = true
            }

        }
    }
    func changeForGOButton(isValid: Bool, needForGo: Bool) {
        backgroundColor = isValid ? .validColor : .invalidColor
        btnGO.isEnabled = needForGo
        btnGO.backgroundColor = isValid ? .validColor : .invalidColor
        btnGO.setTitleColor(isValid ? .black : .white, for: .normal)

    }
}
