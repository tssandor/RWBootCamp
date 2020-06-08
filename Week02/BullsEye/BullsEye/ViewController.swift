//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var currentGame = BullsEyeGame(currentValue: 50, targetValue: Int.random(in: 1...100), score: 0, round: 1)
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startNewGame()
  }

  @IBAction func showAlert() {
    
    let thisRoundsResult = currentGame.calculatePoints()
    
    // Show alert
    let message = "You scored \(thisRoundsResult.points) points"
    let alert = UIAlertController(title: thisRoundsResult.title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.startNewRound()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    let roundedValue = slider.value.rounded()
    currentGame.currentValue = Int(roundedValue)
  }
  
  func startNewRound() {
    currentGame = BullsEyeGame(currentValue: 50, targetValue: Int.random(in: 1...100), score: currentGame.score, round: currentGame.round + 1)
    slider.value = Float(currentGame.currentValue)
    updateLabels()
  }
  
  func updateLabels() {
    targetLabel.text = String(currentGame.targetValue)
    scoreLabel.text = String(currentGame.score)
    roundLabel.text = String(currentGame.round)
  }
  
  @IBAction func startNewGame() {
    currentGame.score = 0
    currentGame.round = 0
    startNewRound()
  }
  
}



