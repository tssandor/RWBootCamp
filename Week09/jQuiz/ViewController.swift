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
    downloadHeaderImage()
    getNewQuizQuestion()
    
    self.scoreLabel.text = "\(self.points)"

    if SoundManager.shared.isSoundEnabled == false {
      soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
    } else {
      soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
    }
    SoundManager.shared.playSound()
  }

  func downloadHeaderImage() {
    Networking.sharedInstance.getHeaderImage(completion: { (headerImage) in
      if headerImage != nil {
        DispatchQueue.main.async {
          self.logoImageView.image = headerImage
        }
      }
    })
  }
  
  func getNewQuizQuestion() {
    Networking.sharedInstance.getQuestion(completion: { (categoryId) in
      guard let id = categoryId else {
        return
      }
      Networking.sharedInstance.getMoreAnswersForCategory(categoryID: id) { (clues) in
        DispatchQueue.main.async {
          var fourClues: [Clue] = []
          for i in 0...3 {
            fourClues.append(clues[i])
          }
          self.clues = fourClues
          self.refreshTheView()
        }
      }
    })
  }
  
  func refreshTheView() {
    scoreLabel.text = "\(self.points)"
    
    categoryLabel.text = clues[0].category.title
    let randomAnswer = clues.randomElement()
    clueLabel.text = randomAnswer?.question
    tableView.reloadData()
  }
  
  func updateTheScore(selectedAnswer: Clue) {
    if selectedAnswer.question == clueLabel.text {
      points = points + 1
      getNewQuizQuestion()
    } else {
      getNewQuizQuestion()
    }
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "guessCell", for: indexPath)
      // Clues in the JSON come with apostrophes escaped -> \'
      // This looks ugly so we correct this here.
      // Also, sometimes they come with HTML tags like <i>, we also get rid of those.
      cell.textLabel?.attributedText = clues[indexPath.row].answer.replacingOccurrences(of: "\\", with: "").htmlToAttributedString
      cell.textLabel?.font = .systemFont(ofSize: 16.0)
      return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      updateTheScore(selectedAnswer: clues[indexPath.row])
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
