//
//  PhoneInputViewInterface.swift
//  G-Motion
//
//  Created by Samed Karakuş on 5.07.2025.
//

import Foundation
import UIKit

func setupTextFields(to textFields: UITextField) {
    textFields.layer.cornerRadius = 5
    textFields.layer.borderWidth = 1
    textFields.layer.borderColor = UIColor.inputStroke.cgColor
    textFields.translatesAutoresizingMaskIntoConstraints = false
    textFields.heightAnchor.constraint(equalToConstant: 45).isActive = true
}
