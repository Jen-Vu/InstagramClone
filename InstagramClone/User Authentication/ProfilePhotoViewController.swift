//
//  ProfilePhotoViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/4/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class ProfilePhotoViewController: UIViewController {

  // MARK: - Static Properties

  static let identifier = "showProfilePhotoViewController"

  // MARK: - Outlets

  @IBOutlet var profilePhotoImageView: UIImageView!
  @IBOutlet var addPhotoButton: UIButton!

  // MARK: - Properties

  var imagePickerHelper: ImagePickerHelper?
  var selectedImage: UIImage?
  var email: String?
  var username: String?
  var password: String?

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Actions

  @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
    imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
      guard let unwrappedImage = image else { return }
      self.addPhotoButton.isEnabled = false
      self.selectedImage = unwrappedImage
      self.profilePhotoImageView.image = unwrappedImage
      self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.bounds.width / 2.0
      self.profilePhotoImageView.layer.masksToBounds = true

      // unwrap values
      guard let email = self.email, !email.isEmpty,
        let username = self.username, !username.isEmpty,
        let password = self.password, !password.isEmpty else {
          fatalError("User data wasn't shared")
      }

      // Create a new user using Firebase auth
      Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
        if let error = error {
          print("Error creating new user: \(error.localizedDescription)")
          return
        }

        guard let user = result?.user else { return }

        // create a new user instance to save to firebase database
        let newUser = User(uid: user.uid, username: username, fullName: "", profileImage: self.selectedImage)

        // save user to database
        newUser.save({ (error) in
          if let error = error {
            print("Error saving user data to the database: \(error.localizedDescription)")
            return
          }

          // time to login, show the newsfeed
          Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
              print("Error loggin in: \(error.localizedDescription)")
              return
            }

            // TODO: show the newsfeed
          })
        })
      })
    })
  }

  @IBAction func skipButtonTapped(_ sender: UIButton) {
  }
}
