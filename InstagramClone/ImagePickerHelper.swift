//
//  ImagePickerHelper.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/4/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerHelper: NSObject {

  // MARK: - Properties

  weak var viewController: UIViewController?
  var completion: ((UIImage?) -> Void)

  // MARK: - Lifecycle

  init(viewController: UIViewController, completion: @escaping ((UIImage?) -> Void)) {
    self.viewController = viewController
    self.completion = completion
    super.init()

    self.showPhotoSourceSelection()
  }

  // MARK: - Methods

  private func showPhotoSourceSelection() {
    let ac = UIAlertController(title: "Pick New Photo", message: "Would you like to open photos library or camera", preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.showImagePicker(sourceType: .camera)
      }
    }))
    ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
      self.showImagePicker(sourceType: .photoLibrary)
    }))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    viewController?.present(ac, animated: true)
  }

  private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.mediaTypes = [kUTTypeImage as String]
    imagePicker.delegate = self

    viewController?.present(imagePicker, animated: true)
  }
}

// MARK: - UIImagePickerController Delegate

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    viewController?.dismiss(animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { fatalError("Could not get the picture") }
    viewController?.dismiss(animated: true)
    completion(image)
  }
}
