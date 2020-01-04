//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 04/01/20.
//  Copyright © 2020 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

  // MARK: - Outlets

  @IBOutlet weak var profileImageView: IGImageView!
  @IBOutlet weak var usernameButton: UIButton!
  @IBOutlet weak var captionLabel: UILabel!

  // MARK: - Properties

  var post: Post? {
    didSet {
      self.updateUI()
    }
  }
  var comment: Comment? {
    didSet {
      self.updateUI()
    }
  }

  // MARK: - Methods

  private func updateUI() {
    if let post = self.post {
      usernameButton.setTitle(post.createdBy.username, for: .normal)
      captionLabel.text = post.caption
      if let profileImageDownloadURL = post.createdBy.profileImageURL {
        profileImageView.loadImage(from: profileImageDownloadURL)
      }
    } else if let comment = comment {
      usernameButton.setTitle(comment.createdBy.username, for: .normal)
      captionLabel.text = comment.caption
      if let profileImageDownloadURL = comment.createdBy.profileImageURL {
        profileImageView.loadImage(from: profileImageDownloadURL)
      }
    }
  }
}
