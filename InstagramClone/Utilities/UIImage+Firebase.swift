//
//  UIImage+Firebase.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/5/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

extension UIImage {

  // MARK: - Methods

  func uploadToFirebase(path: String, completion: @escaping (URL?, Error?) -> Void) {
    guard let imageData = self.jpegData(compressionQuality: 0.5) else {
      debugPrint("Could not convert image to data")
      return
    }
    let ref = Storage.storage().reference().child(path)
    ref.putData(imageData, metadata: nil) { (metadata, error) in
      if let error = error {
        debugPrint("Error saving image: \(error.localizedDescription)")
        completion(nil, error)
      }

      // Get the URL
      ref.downloadURL(completion: { (url, error) in
        completion(url, error)
      })
    }
  }
}
