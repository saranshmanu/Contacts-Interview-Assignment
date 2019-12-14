//
//  ViewControllerExtension.swift
//  Contacts
//
//  Created by Saransh Mittal on 13/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
