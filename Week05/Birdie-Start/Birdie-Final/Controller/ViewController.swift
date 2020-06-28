//
//  ViewController.swift
//  Birdie-Final
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class BirdieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var tableview: UITableView!
  var imagePostImage: UIImage!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setUpTableView()
  }

  func setUpTableView() {
    tableview.delegate = self
    tableview.dataSource = self
    MediaPostsHandler.shared.getPosts()
  }

  @IBAction func didPressCreateTextPostButton(_ sender: Any) {
    getPostDataFromUser(isThisAnImagePost: false)
  }

  @IBAction func didPressCreateImagePostButton(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func getPostDataFromUser(isThisAnImagePost: Bool) {
    let alert = UIAlertController(title: "Add text post", message: nil, preferredStyle: .alert)
    alert.addTextField { (textField) in
        textField.placeholder = "Username"
    }
    alert.addTextField { (textField) in
        textField.placeholder = "Post"
    }
    let action = UIAlertAction(title: "Add", style: .default, handler: {
      action in
      if isThisAnImagePost {
        self.insertNewPost(ImagePost(textBody: alert.textFields![1].text!, userName: alert.textFields![0].text!, timestamp: Date(), image: self.imagePostImage))
      } else {
        self.insertNewPost(TextPost(textBody: alert.textFields![1].text!, userName: alert.textFields![0].text!, timestamp: Date()))
      }
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func insertNewPost(_ newPost: MediaPost) {
    if newPost is TextPost {
      MediaPostsHandler.shared.addTextPost(textPost: newPost as! TextPost)
    } else {
      MediaPostsHandler.shared.addImagePost(imagePost: newPost as! ImagePost)
    }
    let indexPath = IndexPath(row: MediaPostsHandler.shared.mediaPosts.count - 1, section: 0)
    self.tableview.insertRows(at: [indexPath], with: .automatic)
    self.tableview.reloadData()
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    imagePostImage = image
    getPostDataFromUser(isThisAnImagePost: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MediaPostsHandler.shared.mediaPosts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Need to initialize it as "something"
    var cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath)
    
    // I decided to make this a function to make sure currentPost is available outside the if scope.
    // This results in cleaner code, as we don't need set up labels inside the "if TextPost else ImagePost" statements.
    // This is bascially the MVVM logic, although I did not put it into a separate file
    let currentPost = queryDataForCurrentCell(atIndex: indexPath.row)

    if currentPost is TextPost {
      cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath)
    } else if currentPost is ImagePost {
      cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostCell", for: indexPath)
    }

    if let username = cell.viewWithTag(1001) as? UILabel {
      username.text = currentPost.userName
    }
    if let postdate = cell.viewWithTag(1002) as? UILabel {
      let dateFormatter = DateFormatter()
      let date = currentPost.timestamp
      dateFormatter.dateFormat = "dd MMM, HH:mm"
      postdate.text = dateFormatter.string(from: date)
    }
    if let posttext = cell.viewWithTag(1003) as? UILabel {
      posttext.text = currentPost.textBody ?? ""
    }
    if currentPost is ImagePost {
      let currentImagePost = currentPost as? ImagePost
      if let postImage = cell.viewWithTag(2001) as? UIImageView {
        postImage.image = currentImagePost?.image
      }
    }
    
    return cell
  }
  
  func queryDataForCurrentCell(atIndex: Int) -> MediaPost {
    if let post = MediaPostsHandler.shared.mediaPosts[atIndex] as? TextPost {
      return post
    } else if let post = MediaPostsHandler.shared.mediaPosts[atIndex] as? ImagePost {
      return post
    }
    // This should never execute.
    // Also, question! Is there a better way to handle returns in this case, where both return cases are in an if statement,
    // so if I don't add a default here (which will never execute), Xcode complains?
    return MediaPostsHandler.shared.mediaPosts[0]
  }
  
}



