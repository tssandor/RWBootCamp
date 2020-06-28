//
//  ViewController.swift
//  Birdie-Final
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class BirdieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableview: UITableView!
  
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
    let alert = UIAlertController(title: "Add text post", message: nil, preferredStyle: .alert)
    alert.addTextField { (textField) in
        textField.placeholder = "Username"
    }
    alert.addTextField { (textField) in
        textField.placeholder = "Post"
    }
    let action = UIAlertAction(title: "Add", style: .default, handler: {
      action in
        self.insertNewPost(TextPost(textBody: alert.textFields![1].text!, userName: alert.textFields![0].text!, timestamp: Date()))
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func didPressCreateImagePostButton(_ sender: Any) {

  }

  func insertNewPost(_ newPost: MediaPost) {
    MediaPostsHandler.shared.addTextPost(textPost: newPost as! TextPost)
    let indexPath = IndexPath(row: MediaPostsHandler.shared.mediaPosts.count - 1, section: 0)
    self.tableview.insertRows(at: [indexPath], with: .automatic)
    self.tableview.reloadData()
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
    
    print(currentPost)

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
    // This should never execute
    return MediaPostsHandler.shared.mediaPosts[0]
  }

  
}



