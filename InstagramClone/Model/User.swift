//
//  User.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/5/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class User {

  // MARK: - Properties

  var uid: String
  var username: String
  var fullName: String

  var profileImage: UIImage?
  var profileImageURL: String?

  var follows = [User]()
  var followedBy = [User]()

  init(uid: String, username: String, fullName: String, profileImage: UIImage?) {
    self.uid = uid
    self.username = username
    self.fullName = fullName
    self.profileImage = profileImage
  }

  func dictionary() -> [String : Any] {
    return [
      "uid" : uid,
      "username" : username,
      "fullName" : fullName,
      "profileImageURL" : profileImageURL ?? ""
    ]
  }
}

// MARK: - User+Firebase

extension User {

  // MARK: - Methods

  func save(_ completion: @escaping (Error?) -> Void) {
    // create the reference to users database
    let ref = Firestore.firestore().collection("users").document(uid)

    // save profile image if available
    guard let profileImage = self.profileImage else { return }
    profileImage.uploadToFirebase(path: "profileImages/\(uid)") { (url, error) in
      if let error = error {
        debugPrint("Error uploading profile image: \(error.localizedDescription)")
        return
      }

      // get the profile image download url
      guard let imageURL = url else { return }
      self.profileImageURL = imageURL.absoluteString

      // save the user data to the datbase
      ref.setData(self.dictionary(), completion: { (error) in
        debugPrint("Finish saving")
        completion(error)
      })
    }
  }
}
