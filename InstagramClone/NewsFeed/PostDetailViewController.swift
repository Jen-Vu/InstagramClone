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

      documents
        .map { Comment(dictionary: $0.data()) }
        .forEach {
          self.comments.insert($0, at: 0)

          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
      }

      print("**** COMMENTS: \(self.comments)")
    })
  }
}

// MARK: - Table view delegates

extension PostDetailViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count + 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
      fatalError("Could not dequeue tableview cell in \(#file)")
    }

    if indexPath.row == 0 {
      // post caption
      cell.post = self.post
    } else {
      // comment
      cell.comment = self.comments[indexPath.row - 1]
    }

    return cell
  }
}
