//
//  CodeVerificationViewController.swift
//  G-Motion
//
//  Created by Samed Karakuş on 5.07.2025.
//

import UIKit
import FirebaseAuth

class CodeVerificationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var digit1: UITextField!
    @IBOutlet weak var digit2: UITextField!
    @IBOutlet weak var digit3: UITextField!
    @IBOutlet weak var digit4: UITextField!
    @IBOutlet weak var digit5: UITextField!
    @IBOutlet weak var digit6: UITextField!
    @IBOutlet weak var modalLineView: UIView!
    
    var phoneNumber: String?
    private var attemptCount = 0
    private let maxAttempts = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        [digit1, digit2, digit3, digit4, digit5, digit6].forEach { textField in
            if let tf = textField {
                setupTextFields(to: tf)
                tf.delegate = self
                tf.keyboardType = .numberPad
                tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
        }
        digit1.becomeFirstResponder()
        modalLineUpdate(to: modalLineView)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.count <= 1 else {
            textField.text = String(textField.text?.prefix(1) ?? "")
            return
        }

        switch textField {
        case digit1: if text.count == 1 { digit2.becomeFirstResponder() }
        case digit2: if text.count == 1 { digit3.becomeFirstResponder() }
        case digit3: if text.count == 1 { digit4.becomeFirstResponder() }
        case digit4: if text.count == 1 { digit5.becomeFirstResponder() }
        case digit5: if text.count == 1 { digit6.becomeFirstResponder() }
        case digit6:
            if allDigitsFilled() {
                let code = getCode()
                verifyCode(code)
            }
        default: break
        }
    }

    func allDigitsFilled() -> Bool {
        return [digit1, digit2, digit3, digit4, digit5, digit6].allSatisfy { $0?.text?.count == 1 }
    }

    func getCode() -> String {
        return [digit1, digit2, digit3, digit4, digit5, digit6].compactMap { $0?.text }.joined()
    }

    func verifyCode(_ code: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            showAlert("Doğrulama bilgisi eksik.")
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                self.attemptCount += 1
                if self.attemptCount >= self.maxAttempts {
                    let alert = UIAlertController(title: "Uyarı", message: "Çok fazla deneme. Lütfen daha sonra tekrar deneyin.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                    
                    self.disableInputs()
                } else {
                    let alert = UIAlertController(title: "Hata", message: "Hatalı kod. Kalan hakkınız: \(self.maxAttempts - self.attemptCount)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                        self.clearAll()
                        self.digit1.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true)
                }
                print("Auth error: \(error.localizedDescription)")
                return
            }

            self.goToMainApp()
        }

    }

    func disableInputs() {
        [digit1, digit2, digit3, digit4, digit5, digit6].forEach { $0?.isEnabled = false }
    }

    func clearAll() {
        [digit1, digit2, digit3, digit4, digit5, digit6].forEach { $0?.text = "" }
    }

    func goToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
