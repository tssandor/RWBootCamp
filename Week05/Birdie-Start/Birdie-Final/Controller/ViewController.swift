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
//  @IBOutlet weak var avatar: UIImage!
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath)
    
//    if let avatar = cell.viewWithTag(1001) as? UIImage {
//      avatar.
//    }
    
    return cell
  }

  
}



