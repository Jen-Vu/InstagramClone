//
//  Comment.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 03/01/20.
//  Copyright © 2020 Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import Firebase

class Comment {

  var uid: String
  var postUID: String
  var createdAt: Double
  var from: User
  var caption: String

  let db = Firestore.firestore()
  var docRef: DocumentReference?

  init(postUID: String, from: User, caption: String) {
    self.postUID = postUID
    self.from = from
    self.caption = caption
    self.createdAt = Date().timeIntervalSince1970

    docRef = db.collection("posts").document(postUID).collection("comments").document()
    self.uid = docRef!.documentID
  }

  init(dictionary: [String : Any]) {
    self.uid = dictionary["uid"] as? String ?? ""
    self.createdAt = dictionary["createdAt"] as? Double ?? 0.0
    self.caption = dictionary["caption"] as? String ?? ""
    //self.docRef = db.collection("posts").document(self.uid)

    guard let fromDictionary = dictionary["from"] as? [String : Any] else { fatalError("There is no user on this comment") }
    from = User(dictionary: fromDictionary)

    postUID = dictionary["postUID"] as? String ?? ""
    docRef = db.collection("posts").document(postUID).collection("comments").document(self.uid)
  }

  func dictionary() -> [String : Any] {
    return [
      "postUID" : postUID,
      "uid" : uid,
      "createdAt" : createdAt,
      "from" : from.dictionary(),
      "caption" : caption
    ]
  }
}

// MARK: - Firebase

extension Comment {

  func save(_ completion: @escaping (Error?) -> Void) {
    docRef?.setData(self.dictionary(), completion: { (error) in
      debugPrint("Finish saving")
      completion(error)
    })
  }
}
