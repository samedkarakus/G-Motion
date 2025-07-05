//
//  LoginViewModel.swift
//  G-Motion
//
//  Created by Samed Karakuş on 3.07.2025.
//

import Foundation

class LoginViewModel {
    
    private(set) var allCountries: [Country] = [
        Country(name: "Turkey", code: "+90", flag: "🇹🇷"),
        Country(name: "Germany", code: "+49", flag: "🇩🇪"),
        Country(name: "Kenya", code: "+254", flag: "🇰🇪"),
        Country(name: "Nigeria", code: "+234", flag: "🇳🇬"),
        Country(name: "South Africa", code: "+27", flag: "🇿🇦"),
        Country(name: "Georgia", code: "+995", flag: "🇬🇪"),
    ]

    
    var filteredCountries: [Country]
    var selectedCountry: Country?
    
    init() {
        self.filteredCountries = allCountries
        self.selectedCountry = allCountries.first(where: { $0.code == "+90" })
    }
    
    func filterCountries(with query: String) {
        if query.isEmpty {
            filteredCountries = allCountries
        } else {
            filteredCountries = allCountries.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
    }
    
    func formatPhoneNumber(_ input: String) -> String {
        let digits = input.filter { $0.isWholeNumber }
        let maxDigits = 10
        let limitedDigits = String(digits.prefix(maxDigits))
        
        let mask = [3, 3, 2, 2]
        var formattedText = ""
        var index = limitedDigits.startIndex
        
        for length in mask {
            let endIndex = limitedDigits.index(index, offsetBy: length, limitedBy: limitedDigits.endIndex) ?? limitedDigits.endIndex
            let substring = limitedDigits[index..<endIndex]
            if !substring.isEmpty {
                if !formattedText.isEmpty {
                    formattedText += " "
                }
                formattedText += substring
            }
            index = endIndex
            if index == limitedDigits.endIndex {
                break
            }
        }
        
        return formattedText
    }
}

