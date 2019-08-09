//
//  PostComposerTableViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/8/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class PostComposerTableViewController: UITableViewController {

  // MARK: - Outlets

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var textView: UITextView!
  @IBOutlet var shareBarButtonItem: UIBarButtonItem!

  // MARK: - Properties

  var image: UIImage? = UIImage(named: "1")

  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    textView.becomeFirstResponder()
    textView.text = ""
    textView.delegate = self

    imageView.image = image
    shareBarButtonItem.isEnabled = false

    tableView.allowsSelection = false
    tableView.keyboardDismissMode = .onDrag
  }

  // MARK: - Action

  @IBAction func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
    // make sure - image and caption is set
    if let image = image, let caption = textView.text {
      // get current user
      guard let uid = Auth.auth().currentUser?.uid else { fatalError("There is no user logged in, you must not be able to be on this page") }
      let docRef = Firestore.firestore().collection("users").document(uid)
      docRef.getDocument(completion: { (document, error) in
        // get the current user to use it later
        if let user = document.flatMap({ $0.data().flatMap({ (data) in return User(dictionary: data) }) }) {
          // you got the current user
          print("==== CURRENT USER")
          print(user.username)
        } else {
          print("Document does not exist")
        }
      })
      
      // create a new post instance

      // save the post to db

      // go back to the newsfeed
    }
  }

  @IBAction func cancelBarButtonItemTapped(_ sender: UIBarButtonItem) {
    image = nil
    imageView.image = nil
    textView.resignFirstResponder()
    textView.text = ""

    self.tabBarController?.selectedIndex = 0
  }
}

// MARK: - TextView Delegate
extension PostComposerTableViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    shareBarButtonItem.isEnabled = (textView.text != "")
  }
}
