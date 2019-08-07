//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/6/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.delegate = self
    passwordTextField.delegate = self
    emailTextField.applyRoundedCorners()
    passwordTextField.applyRoundedCorners()
  }

  // MARK: - Actions

  @IBAction func loginButtonTapped(_ sender: UIButton) {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    login()
  }

  // MARK: - Methods

  private func login() {
    guard let email = emailTextField.text, !email.isEmpty,
      let password = passwordTextField.text, !password.isEmpty else {
        return
    }
    Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
      if let error = error {
        print("Error loggin in: \(error.localizedDescription)")
        self.showAlert(title: "Ooops!", message: error.localizedDescription, buttonTitle: "OK!")
        return
      }

      self.dismiss(animated: true)
    })
  }

  private func showAlert(title: String, message: String, buttonTitle: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: buttonTitle, style: .default))
    present(ac, animated: true)
  }
}

// MARK: - TextField Delegate

extension LoginViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textInputMode == passwordTextField {
      passwordTextField.resignFirstResponder()
      login()
    }

    return true
  }
}
