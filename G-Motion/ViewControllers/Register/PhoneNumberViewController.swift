//
//  PhoneNumberViewController.swift
//  G-Motion
//
//  Created by Samed Karakuş on 5.07.2025.
//

import UIKit
import FirebaseAuth

class PhoneNumberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private let countryButton = UIButton(type: .system)
    private let dropdownTableView = UITableView()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields(to: phoneNumberTextField)
        setupCountryButton()
        setupDropdown()
        phoneNumberTextField.text = PhoneFormatter.format(phoneNumberTextField.text ?? "")
        
        phoneNumberTextField.delegate = self
    }
    
    @IBAction func sendCodeButtonTapped(_ sender: UIButton) {
        guard let formattedPhone = phoneNumberTextField.text, !formattedPhone.isEmpty else {
            showAlert(message: "Telefon numarası girin.")
            return
        }

        let e164Phone = PhoneFormatter.sanitizedE164(from: formattedPhone)

        guard e164Phone.count == 13 else {
            showAlert(message: "Geçerli bir telefon numarası girin.")
            return
        }

        PhoneAuthProvider.provider().verifyPhoneNumber(e164Phone, uiDelegate: nil) { verificationID, error in
            print("Callback geldi")
            
            if let error = error {
                print("Firebase Error: \(error.localizedDescription)")
                return
            }

            print("Kod başarıyla gönderildi. ID: \(verificationID ?? "")")

            if let error = error {
                self.showAlert(message: "Kod gönderilemedi: \(error.localizedDescription)")
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CodeVerificationViewController") as! CodeVerificationViewController
            vc.phoneNumber = e164Phone
            self.present(vc, animated: true, completion: nil)
            print("Gönderilen telefon numarası (E164 format): \(e164Phone)")
        }
    }


    func showAlert(message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneNumberTextField else { return true }

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let formatted = PhoneFormatter.format(updatedText)
        
        textField.text = formatted
        return false
    }

    
    private func setupCountryButton() {
        guard let country = viewModel.selectedCountry else { return }
        
        var config = UIButton.Configuration.plain()
        let font = UIFont.systemFont(ofSize: 15)
        let attributedTitle = AttributedString("\(country.flag) \(country.code)", attributes: AttributeContainer([.font: font]))
        config.attributedTitle = attributedTitle
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
        
        countryButton.configuration = config
        countryButton.sizeToFit()
        countryButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        
        phoneNumberTextField.leftView = countryButton
        phoneNumberTextField.leftViewMode = .always
    }

    private func setupDropdown() {
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dropdownTableView.frame = CGRect(x: phoneNumberTextField.frame.minX,
                                         y: phoneNumberTextField.frame.maxY + 8,
                                         width: phoneNumberTextField.frame.width,
                                         height: 0)
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.inputStroke.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.clipsToBounds = true
        dropdownTableView.rowHeight = 50
        view.addSubview(dropdownTableView)
    }

    @objc private func toggleDropdown() {
        let newHeight: CGFloat = dropdownTableView.frame.height == 0 ? 200 : 0
        UIView.animate(withDuration: 0.3) {
            self.dropdownTableView.frame.size.height = newHeight
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = viewModel.filteredCountries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(country.flag) \(country.name) (\(country.code))"
        cell.backgroundColor = UIColor.appBackground
        cell.selectionStyle = .none
        
        if country.code == viewModel.selectedCountry?.code {
            cell.textLabel?.textColor = .black
            cell.backgroundColor = UIColor.white
        } else {
            cell.textLabel?.textColor = .white
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCountry = viewModel.filteredCountries[indexPath.row]
        setupCountryButton()
        toggleDropdown()
        tableView.reloadData()
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true, completion: nil)
        }
    }
}
