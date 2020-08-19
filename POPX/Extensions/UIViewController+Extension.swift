//
//  UIViewController+Extension.swift
//  POPX
//
//  Created by Adham Albanna on 8/6/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
