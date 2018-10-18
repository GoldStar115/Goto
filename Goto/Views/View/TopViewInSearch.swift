//
//  TopViewInSearch.swift
//  Goto
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TopViewInSearch: UIView {
    @IBOutlet weak var constraintWidthText: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightText: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomButton: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomText: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomTaggle: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomImageHint: NSLayoutConstraint!
    @IBOutlet weak var constraintTopImageHint: NSLayoutConstraint!

    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var imgSearchHint: UIImageView!
    @IBOutlet weak var taggleCircle: UIView!
    @IBOutlet weak var taggleBar: UIView!

    func changeViewElements(isExpand:Bool, widthScreen: CGFloat, animate: Bool = true) {
        constraintHeightText.constant = isExpand ? 30 : 50
        constraintWidthText.constant = widthScreen - (isExpand ? 80 : 60)
        constraintBottomButton.constant = isExpand ? 40 : 35
        constraintBottomText.constant = isExpand ? 5 : 0
        constraintBottomTaggle.constant = isExpand ? 18 : 23
        constraintBottomImageHint.constant = isExpand ? -2 : 0
        constraintTopImageHint.constant = isExpand ? -2 : 0

        if !animate {
            btnCurrentLocation.alpha = isExpand ? 1 : 0
            taggleCircle.alpha = isExpand ? 1 : 0
            taggleBar.alpha = isExpand ? 1 : 0
            txtSearch.isHidden = true
            imgSearchHint.isHidden = false
            
           return
        }
        txtSearch.isHidden = true
        imgSearchHint.isHidden = false
        viewSearchBar.backgroundColor = isExpand ? UIColor(white: 200.0 / 255.0, alpha: 0.6) : .white
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.btnCurrentLocation.alpha = isExpand ? 1 : 0
            self.taggleCircle.alpha = isExpand ? 1 : 0
            self.taggleBar.alpha = isExpand ? 1 : 0
        }) { (isDone) in
            self.txtSearch.isHidden = false
            self.imgSearchHint.isHidden = true
        }

    }
}

