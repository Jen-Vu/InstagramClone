//
//  IGImageView.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/16/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class IGImageView: UIImageView {

  func loadImage(from urlString: String) {
    self.image = nil
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch Image: \(error)")
      }

      guard let imageData = data else { return }
      let downloadedImage = UIImage(data: imageData)

      DispatchQueue.main.async {
        self.image = downloadedImage
      }
    }.resume()
  }
}
