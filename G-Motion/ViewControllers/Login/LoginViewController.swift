//
//  LoginViewController.swift
//  G-Motion
//
//  Created by Samed Karakuş on 3.07.2025.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let countryButton = UIButton(type: .system)
    private let dropdownTableView = UITableView()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields(to: phoneTextField)
        setupTextFields(to: passwordTextField)
        setupCountryButton()
        setupDropdown()
        phoneTextField.text = PhoneFormatter.format(phoneTextField.text ?? "")
        addPaddingToLeading(to: passwordTextField)
        
        phoneTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneTextField else { return true }

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        textField.text = PhoneFormatter.format(updatedText)
        return false
    }

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "PhoneNumberViewController") as? PhoneNumberViewController {
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true, completion: nil)
        }
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
        
        phoneTextField.leftView = countryButton
        phoneTextField.leftViewMode = .always
    }

    private func setupDropdown() {
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dropdownTableView.frame = CGRect(x: phoneTextField.frame.minX,
                                         y: phoneTextField.frame.maxY + 8,
                                         width: phoneTextField.frame.width,
                                         height: 0)
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.inputStroke.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.clipsToBounds = true
        dropdownTableView.rowHeight = 45
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
}
