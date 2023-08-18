//
//  UIView+.swift
//  ThreadApp
//
//  Created by hong on 2023/08/17.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadious: CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

