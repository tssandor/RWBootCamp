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
  
//  @IBOutlet weak var username: UILabel!
//  @IBOutlet weak var postDate: UILabel!
//  @IBOutlet weak var postText: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setUpTableView()
  }

  func setUpTableView() {
    tableview.delegate = self
    tableview.dataSource = self
    MediaPostsHandler.shared.getPosts()
    // Set delegates, register custom cells, set up datasource, etc.
  }

  @IBAction func didPressCreateTextPostButton(_ sender: Any) {

  }

  @IBAction func didPressCreateImagePostButton(_ sender: Any) {

  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let x = MediaPostsHandler.shared.mediaPosts.count
    return x
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath)
    var itsATextPost = true
    
    // I decided to make this a function to make sure currentPost is available outside the if scope.
    // This results in cleaner code, as we don't need set up labels inside the if statements.
    let currentPost = queryDataForCurrentCell(atIndex: indexPath.row)

    if currentPost is TextPost {
      cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath)
      itsATextPost = true
    } else if currentPost is ImagePost {
      cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostCell", for: indexPath)
      itsATextPost = false
    }
    
    print(currentPost)

    if let username = cell.viewWithTag(1001) as? UILabel {
      username.text = currentPost.userName
    }
    if let posttext = cell.viewWithTag(1003) as? UILabel {
      posttext.text = currentPost.textBody!
    }
    if !itsATextPost {
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



