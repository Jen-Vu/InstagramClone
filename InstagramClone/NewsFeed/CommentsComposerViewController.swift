//
//  CommentsComposerViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/16/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class CommentsComposerViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var profileImageView: IGImageView!
  @IBOutlet var usernameButton: UIButton!
  @IBOutlet var captionTextView: UITextView!
  @IBOutlet var postBarButtonItem: UIBarButtonItem!

  // MARK: - Properties

  var currentUser: User?
  var post: Post?

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    captionTextView.text = ""
    captionTextView.becomeFirstResponder()
    captionTextView.delegate = self

    if let currentUser = currentUser {
      usernameButton.setTitle(currentUser.username, for: .normal)
      profileImageView.loadImage(from: currentUser.profileImageURL ?? "")
      profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
      profileImageView.clipsToBounds = true
    }
  }

  // MARK: - Actions

  @IBAction func postBarButtonItemDidTap(_ sender: UIBarButtonItem) {
    guard let currentUser = self.currentUser, let post = self.post else {
      fatalError("There is no logged in user or post selected")
    }

    if let caption = captionTextView.text {
      let newComment = Comment(postUID: post.uid, from: currentUser, caption: caption)
      newComment.save { (error) in
        if let error = error {
          print("Error saving comment, \(error)")
        }
      }
      post.comments.append(newComment)
      navigationController?.popViewController(animated: true)
    }
  }
}

// MARK: - UITextView Delegate

extension CommentsComposerViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    postBarButtonItem.isEnabled = textView.text != ""
  }
}
