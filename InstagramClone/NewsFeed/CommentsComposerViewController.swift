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
    
  }
}

// MARK: - UITextView Delegate

extension CommentsComposerViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    postBarButtonItem.isEnabled = textView.text != ""
  }
}
