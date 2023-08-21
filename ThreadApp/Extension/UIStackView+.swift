//
//  UIStackView+.swift
//  ThreadApp
//
//  Created by hong on 2023/08/19.
//

import UIKit

extension UIStackView {
    @IBInspectable
    var layoutMarginTop: CGFloat {
        get {
            self.layoutMargins.top
        }
        set {
            setLayoutMargin(
                top: newValue,
                bottom: self.layoutMargins.bottom,
                left: self.layoutMargins.left,
                right: self.layoutMargins.right
            )
        }
    }
    @IBInspectable
    var layoutMarginBottom: CGFloat {
        get {
            self.layoutMargins.bottom
        }
        set {
            setLayoutMargin(
                top: self.layoutMargins.top,
                bottom: newValue,
                left: self.layoutMargins.left,
                right: self.layoutMargins.right
            )
        }
    }
    @IBInspectable
    var layoutMarginLeft: CGFloat {
        get {
            self.layoutMargins.left
        }
        set {
            setLayoutMargin(
                top: self.layoutMargins.top,
                bottom: self.layoutMargins.bottom,
                left: newValue,
                right: self.layoutMargins.right
            )
        }
    }
    @IBInspectable
    var layoutMarginRight: CGFloat {
        get {
            self.layoutMargins.right
        }
        set {
            setLayoutMargin(
                top: self.layoutMargins.top,
                bottom: self.layoutMargins.bottom,
                left: self.layoutMargins.left,
                right: newValue
            )
        }
    }
    
    func setLayoutMargin(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.layoutMargins = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.isLayoutMarginsRelativeArrangement = true
    }
}
