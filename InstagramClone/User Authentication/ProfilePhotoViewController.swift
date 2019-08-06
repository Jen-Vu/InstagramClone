//
//  ProfilePhotoViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/4/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: UIViewController {

  // MARK: - Static Properties

  static let identifier = "showProfilePhotoViewController"

  // MARK: - Outlets

  @IBOutlet var profilePhotoImageView: UIImageView!
  @IBOutlet var addPhotoButton: UIButton!

  // MARK: - Properties

  var imagePickerHelper: ImagePickerHelper?
  var selectedImage: UIImage?
  var email: String?
  var username: String?
  var password: String?

  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Actions

  @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
    imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
      self.selectedImage = image
      self.profilePhotoImageView.image = image
      self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.bounds.width / 2.0
      self.profilePhotoImageView.layer.masksToBounds = true
    })
  }

  @IBAction func skipButtonTapped(_ sender: UIButton) {
  }
}
