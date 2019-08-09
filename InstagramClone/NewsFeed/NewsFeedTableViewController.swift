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

  // MARK: - Properties

  var currentUser: User?
  var imagePickerHelper: ImagePickerHelper?

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    observeUserLogin()

    tabBarController?.delegate = self
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
          if let user = document.flatMap({ $0.data().flatMap({ (data) in return User(dictionary: data) }) }) {
            self.currentUser = user
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

// MARK: - UITabBarControllerDelegate

extension NewsFeedTableViewController: UITabBarControllerDelegate {

  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == 1 {
      imagePickerHelper = ImagePickerHelper(viewController: self, cancelAction: false, completion: { (image) in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postComposerNav = storyboard.instantiateViewController(withIdentifier: "PostComposerNavigationController") as? UINavigationController else {
          print("***** Error: could not get UINavigationController of PostComposerTableViewController")
          return
        }

        guard let postComposerVC = postComposerNav.viewControllers.first as? PostComposerTableViewController else {
          print("***** Error: could not get PostComposerTableViewController")
          return
        }
        
        postComposerVC.image = image
        self.present(postComposerNav, animated: true)
      })
      
      return false
    }

    return true
  }
}
