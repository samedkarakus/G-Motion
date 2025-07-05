//
//  PhoneFormatter.swift
//  G-Motion
//
//  Created by Samed Karakuş on 5.07.2025.
//

import Foundation

struct PhoneFormatter {

    static func format(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        var result = ""
        let prefix = digits.prefix(10)

        for (index, char) in prefix.enumerated() {
            switch index {
            case 0:
                result += "(" + String(char)
            case 2:
                result += String(char) + ") "
            case 5, 7:
                result += String(char) + " "
            default:
                result += String(char)
            }
        }

        return result
    }

    static func sanitizedE164(from formatted: String) -> String {
        let digits = formatted.filter { $0.isNumber }
        guard digits.count == 10 else { return "" }
        return "+90" + digits
    }
}
