//
//  uiUpdate.swift
//  G-Motion
//
//  Created by Samed Karakuş on 5.07.2025.
//

import Foundation
import UIKit

func addPaddingToLeading(to textField: UITextField) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    textField.leftView = paddingView
    textField.leftViewMode = .always
}

func modalLineUpdate(to modalLine: UIView) {
    modalLine.layer.cornerRadius = 2
    modalLine.backgroundColor = UIColor(white: 1, alpha: 0.25)
}
