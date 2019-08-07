//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/6/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Actions

  @IBAction func menuTapped(_ sender: UIBarButtonItem) {
    let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action) in
      do {
        try Auth.auth().signOut()
        self.tabBarController?.selectedIndex = 0 // go to newsfeed
      } catch let error {
        print("Error loggin out \(error.localizedDescription)")
      }
    }))

    present(ac, animated: true)
  }
}
