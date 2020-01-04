//
//  PostDetailViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 04/01/20.
//  Copyright © 2020 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class PostDetailViewController: UITableViewController {

  // MARK: - Properties

  var post: Post?
  var currentUser: User?
  var comments = [Comment]()

  // MARK: - View cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Photo"
    tableView.allowsSelection = false

    fetchComments()
  }

  // MARK: - Methods

  private func fetchComments() {
    guard let post = self.post else {
      fatalError("Could not get the post in \(#file)")
    }

    post.docRef?.collection("comments").addSnapshotListener({ (documentSnapshot, error) in
      guard let documents = documentSnapshot?.documents else {
        print("Error fetching documents: \(error!)")
        return
      }

      print(documents)
    })
  }
}
