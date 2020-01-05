//
//  PostTableViewCell.swift
//  InstagramNewsFeedUI
//
//  Created by Juan Francisco Dorado Torres on 8/9/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate: class {

  func commentDidTap(post: Post)
}

class PostTableViewCell: UITableViewCell {

  // MARK: - Outlets
  @IBOutlet var postImageView: IGImageView!
  @IBOutlet var numberOfLikesButton: UIButton!
  @IBOutlet var timeAgoLabel: UILabel!
  @IBOutlet var postCaptionLabel: UILabel!
  @IBOutlet var likesButton: UIButton!

  // MARK: - Properties

  weak var delegate: PostTableViewCellDelegate?
  var currentUser: User?

  var post: Post? {
    didSet {
      if let post = post {
        updateUI(post)
      }
    }
  }

  // MARK: - Actions

  @IBAction func commentButtonDidTap(_ sender: UIButton) {
    guard let post = self.post else {
      fatalError("There is no post selection in \(#file)")
    }
    delegate?.commentDidTap(post: post)
  }

  @IBAction func likeButtonDidTap(_ sender: UIButton) {
    guard let post = self.post, let currentUser = self.currentUser else { fatalError("Post or User could not be loaded in \(#file)") }
    if post.likes.contains(currentUser) {
      // unlike
    } else {
      // like
      post.likeBy(currentUser)
    }

    updateLikesUI()
  }

  // MARK: - Methods

  private func updateUI(_ post: Post) {
    postCaptionLabel.text = post.caption
    updateLikesUI()

    if let postImageURL = post.imageDownloadURL {
      postImageView.loadImage(from: postImageURL)
    }
  }

  private func updateLikesUI() {
    guard let post = self.post, let currentUser = self.currentUser else { fatalError("Post or User could not be loaded in \(#file)") }
    if post.likes.contains(currentUser) {
      likesButton.setImage(UIImage(named: "icon-like-filled"), for: .normal)
    } else {
      likesButton.setImage(UIImage(named: "icon-like"), for: .normal)
    }

    numberOfLikesButton.setTitle("♥︎ \(post.likes.count) likes", for: .normal)
  }
}
