//
//  PostTableViewCell.swift
//  InstagramNewsFeedUI
//
//  Created by Juan Francisco Dorado Torres on 8/9/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

  // MARK: - Outlets
  @IBOutlet var postImageView: IGImageView!
  @IBOutlet var numberOfLikesButton: UIButton!
  @IBOutlet var timeAgoLabel: UILabel!
  @IBOutlet var postCaptionLabel: UILabel!

  // MARK: - Properties

  var post: Post? {
    didSet {
      if let post = post {
        updateUI(post)
      }
    }
  }

  // MARK: - Methods

  private func updateUI(_ post: Post) {
    postCaptionLabel.text = post.caption
    numberOfLikesButton.setTitle("♥︎ 18 Likes", for: .normal)

    if let postImageURL = post.imageDownloadURL {
      postImageView.loadImage(from: postImageURL)
    }
  }
}
