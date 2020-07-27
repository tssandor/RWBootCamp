//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var soundButton: UIButton!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var clueLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scoreLabel: UILabel!

  var clues: [Clue] = []
  var correctAnswerClue: Clue?
  var points: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    
    self.scoreLabel.text = "\(self.points)"

    if SoundManager.shared.isSoundEnabled == false {
      soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
    } else {
      soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
    }

    SoundManager.shared.playSound()

    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    
    guard let url = URL(string:"http://www.jservice.io/api/random") else {
      return
    }
    
    let task = session.dataTask(with: url) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
        return
      }
      guard let data = data else {
        return
      }
      if let result = String(data: data, encoding: .utf8) {
        let decoder = JSONDecoder()
        guard let response = try? decoder.decode([Clue].self, from: data) else {
          return
        }
        let singleResponse = response[0]
        print(singleResponse)
        DispatchQueue.main.async {
          self.clues.append(response[0])
          print(self.clues)
          self.categoryLabel.text = self.clues[0].category.title
          self.clueLabel.text = self.clues[0].question
        }
      }
    }
    task.resume()
  // end of viewdidload
  }

  @IBAction func didPressVolumeButton(_ sender: Any) {
    SoundManager.shared.toggleSoundPreference()
    if SoundManager.shared.isSoundEnabled == false {
        soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
    } else {
        soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
    }
  }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
