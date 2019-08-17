//
//  NewsFeedTableViewController.swift
//  InstagramClone
//
//  Created by Juan Francisco Dorado Torres on 8/6/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

  // MARK: - Properties

  var currentUser: User?
  var imagePickerHelper: ImagePickerHelper?
  var posts: [Post]? = []

  struct Storyboard {
    static let postCell = "PostTableViewCell"
    static let postHeaderCell = "PostHeaderTableViewCell"
    static let postHeaderHeight: CGFloat = 56.0
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.delegate = self

    observeUserLogin()
    fetchPosts()
  }

  // MARK: - Methods

  private func observeUserLogin() {
    // check if the user is logged in or not
    Auth.auth().addStateDidChangeListener { (auth, user) in
      if let user = user {
        // the user is logged in
        // download user data from db
        let ref = Firestore.firestore().collection("users").document(user.uid)
        ref.getDocument(completion: { (document, error) in
          // get the current user to use it later
          if let user = document.flatMap({ $0.data().flatMap({ (data) in return User(dictionary: data) }) }) {
            self.currentUser = user
          } else {
            print("Document does not exist")
          }
        })
      } else {
        // user isn't logged in yet
        self.performSegue(withIdentifier: "ShowWelcome", sender: nil)
      }
    }
  }

  private func fetchPosts() {
    let db = Firestore.firestore()
    db.collection("posts").addSnapshotListener { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents else {
        print("Error fetching documents: \(error!)")
        return
      }

      documents.map { Post(dictionary: $0.data()) }
        .forEach {
          self.posts?.insert($0, at: 0)

          DispatchQueue.main.async {
            self.tableView.reloadData()
          }

          print($0.uid)
      }
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowCommentsComposer",
      let post = sender as? Post,
      let vc = segue.destination as? CommentsComposerViewController {
      vc.currentUser = currentUser
    }
  }
}

// MARK: - Tableview Delegates

extension NewsFeedTableViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    if let posts = posts {
      return posts.count
    }

    return 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if posts != nil {
      return 1
    }

    return 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as? PostTableViewCell else { fatalError("Could not load \(Storyboard.postCell)") }
    cell.post = posts?[indexPath.section]
    cell.selectionStyle = .none
    return cell
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postHeaderCell) as? PostHeaderTableViewCell else { fatalError("Could not load \(Storyboard.postHeaderCell)") }
    cell.post = posts?[section]
    cell.backgroundColor = .white
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Storyboard.postHeaderHeight
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedPost = posts?[indexPath.row] else { return }
    performSegue(withIdentifier: "ShowCommentsComposer", sender: selectedPost)
  }
}

// MARK: - UITabBarControllerDelegate

extension NewsFeedTableViewController: UITabBarControllerDelegate {

  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == 1 {
      imagePickerHelper = ImagePickerHelper(viewController: self, cancelAction: false, completion: { (image) in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postComposerNav = storyboard.instantiateViewController(withIdentifier: "PostComposerNavigationController") as? UINavigationController else {
          print("***** Error: could not get UINavigationController of PostComposerTableViewController")
          return
        }

        guard let postComposerVC = postComposerNav.viewControllers.first as? PostComposerTableViewController else {
          print("***** Error: could not get PostComposerTableViewController")
          return
        }
        
        postComposerVC.image = image
        self.present(postComposerNav, animated: true)
      })
      
      return false
    }

    return true
  }
}
