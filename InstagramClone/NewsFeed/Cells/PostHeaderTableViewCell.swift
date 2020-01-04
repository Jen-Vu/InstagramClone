//
//  PostHeaderTableViewCell.swift
//  InstagramNewsFeedUI
//
//  Created by Juan Francisco Dorado Torres on 8/9/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class PostHeaderTableViewCell: UITableViewCell {

  // MARK: - Outlets

  @IBOutlet var profileImageView: IGImageView!
  @IBOutlet var usernameButton: UIButton!
  @IBOutlet var followButton: UIButton!

  // MARK: - Properties

  var post: Post? {
    didSet {
      if post != nil {
        updateUI()
      }
    }
  }

  // MARK: - Methods

  private func updateUI() {
    if let profileImageURL = post?.createdBy.profileImageURL {
      profileImageView.loadImage(from: profileImageURL)
    }

    profileImageView.image = post?.createdBy.profileImage
    profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
    profileImageView.layer.masksToBounds = true

    followButton.layer.borderWidth = 1.0
    followButton.layer.cornerRadius = 2.0
    followButton.layer.borderColor = followButton.tintColor.cgColor
    followButton.layer.masksToBounds = true
  }
}
