//
//  RoundedButton.swift
//  Set
//
//  Created by Eric Groom on 1/16/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import UIKit

extension UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

}
