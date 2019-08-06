//
//  NewsFeedTableViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/6/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    observeUserLogin()
  }

  // MARK: - Methods

  private func observeUserLogin() {
    // check if the user is logged in or not
    Auth.auth().addStateDidChangeListener { (auth, user) in
      if let user = user {
        // the user is logged in
        // download user data from db
        let ref = Firestore.firestore().collection("users").document(user.uid)
        ref.getDocument(completion: { (document, error) in
          // get the current user to use it later
          if let user = document.flatMap({
            $0.data().flatMap({ (data) in
              return User(dictionary: data)
            })
          }) {
            print("User: \(user)")
          } else {
            print("Document does not exist")
          }
        })
      } else {
        // user isn't logged in yet
        self.performSegue(withIdentifier: "ShowWelcome", sender: nil)
      }
    }
  }
}
