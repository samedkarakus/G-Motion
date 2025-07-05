//
//  LoginViewController.swift
//  G-Motion
//
//  Created by Samed Karakuş on 3.07.2025.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAppData()
    }


    func loadAppData() {
        DispatchQueue.global().async {
            sleep(2)
            DispatchQueue.main.async {
                self.navigateToSignUp()
            }
        }
    }

    func navigateToSignUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signUpVC.modalPresentationStyle = .fullScreen
            self.present(signUpVC, animated: true, completion: nil)
        }
    }
}


