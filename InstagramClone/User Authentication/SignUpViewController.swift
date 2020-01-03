//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/6/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var usernameTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var createNewAccountButton: UIButton!

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    emailTextField.delegate = self
    usernameTextField.delegate = self
    passwordTextField.delegate = self

    emailTextField.applyRoundedCorners()
    usernameTextField.applyRoundedCorners()
    passwordTextField.applyRoundedCorners()
  }

  // MARK: - Actions

  @IBAction func createNewAccountButtonTapped(_ sender: UIButton) {
    createNewAccount()
  }

  @IBAction func loginButtonDidTapped(_ sender: UIButton) {
  }

  // MARK: - Methods

  func createNewAccount() {
    guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
    if username.count >= 6 && email.count >= 6 && password.count >= 6 {
      let accountDict = ["username" : username, "email" : email, "password" : password]
      performSegue(withIdentifier: ProfilePhotoViewController.identifier, sender: accountDict)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ProfilePhotoViewController.identifier {
      guard let profilePhotoVC = segue.destination as? ProfilePhotoViewController else { fatalError("Could not load 'ProfilePhotoViewController'") }
      guard let accountDict = sender as? [String : String] else { fatalError("Could not cast accountDict") }
      profilePhotoVC.email = accountDict["email"]
      profilePhotoVC.username = accountDict["username"]
      profilePhotoVC.password = accountDict["password"]
    }
  }
}

// MARK: - TextField Delegate

extension SignUpViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      usernameTextField.becomeFirstResponder()
    } else if textField == usernameTextField {
      passwordTextField.becomeFirstResponder()
    } else if textInputMode == passwordTextField {
      passwordTextField.resignFirstResponder()
      createNewAccount()
    }

    return true
  }
}

// MARK: - UITextField Extension

extension UITextField {

  func applyRoundedCorners() {
    self.layer.cornerRadius = 5.0
    self.layer.borderColor = UIColor(white: 0, alpha: 0.15).cgColor
    self.layer.borderWidth = 1.0
    self.layer.masksToBounds = true
  }
}
