/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var rgb = RGB()
  var game = BullsEyeGame(score: 0, round: 1, targetColor: RGB(r: 127, g: 127, b: 127), guessColor: RGB(r: 127, g: 127, b: 127))
  
  @IBAction func aSliderMoved(sender: UISlider) {
    
    var differenceToTarget = 0
    // We update the slider label
    switch sender {
      case redSlider:
        redLabel.text = "R " + String(Int(sender.value.rounded()))
        differenceToTarget = abs(game.targetColor.r - game.guessColor.r)
      case greenSlider:
        greenLabel.text = "G " + String(Int(sender.value.rounded()))
        differenceToTarget = abs(game.targetColor.g - game.guessColor.g)
      case blueSlider:
        blueLabel.text = "B " + String(Int(sender.value.rounded()))
        differenceToTarget = abs(game.targetColor.b - game.guessColor.b)
      default:
        print("This should never appear, something went wrong ;]")
    }
    
    // We update the guess color
    game.guessColor = RGB(r: Int(redSlider.value.rounded()), g: Int(greenSlider.value.rounded()), b: Int(blueSlider.value.rounded()))
    guessLabel.backgroundColor = UIColor(rgbStruct: game.guessColor)
    
    // We implement the hint feature
//    sender.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(differenceToTarget)/100.0)
    updateHintOnSliders(onSlider: sender, withDifference: Float(differenceToTarget))
    
  }
  
  @IBAction func showAlert(sender: AnyObject) {
  
    // Determine and update score
    let difference = game.guessColor.difference(target: game.targetColor)
    let scoreInThisRound = game.calculateScore(withDifference: difference)
    game.score = game.score + scoreInThisRound
        
    // Compose alert message
    var title = "Round \(game.round):"
    if scoreInThisRound == 1000 {
      title = title + " THAT'S A BULL'S EYE!"
    }

    // Update round
    game.round += 1
     
    // Show alert
    let message = "You scored \(scoreInThisRound) points"
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.updateLabels()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func startOver(sender: AnyObject) {
    
    // We generate a new target color
    game.targetColor = game.createNewTargetColor()
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetColor)
    // This is not needed, but helpful if you want a bull's eye ;]
    print(game.targetColor)
    
    // Reset the sliders and the guess color bg
    game.guessColor = RGB(r: 127, g: 127, b: 127)
    redSlider.value = Float(game.guessColor.r)
    greenSlider.value = Float(game.guessColor.g)
    blueSlider.value = Float(game.guessColor.b)
    updateHintOnSliders(onSlider: redSlider, withDifference: Float(abs(game.targetColor.r - game.guessColor.r)))
    updateHintOnSliders(onSlider: greenSlider, withDifference: Float(abs(game.targetColor.g - game.guessColor.g)))
    updateHintOnSliders(onSlider: blueSlider, withDifference: Float(abs(game.targetColor.b - game.guessColor.b)))
    redLabel.text = "R 127"
    greenLabel.text = "G 127"
    blueLabel.text = "B 127"
    guessLabel.backgroundColor = UIColor(rgbStruct: game.guessColor)
    
    // Reset the round & score
    game.score = 0
    game.round = 1
    updateLabels()
  }
  
  func updateLabels() {
    scoreLabel.text = "Score: " + String(game.score)
    roundLabel.text = "Round: " + String(game.round)
  }
  
  func updateHintOnSliders(onSlider: UISlider, withDifference: Float) {
    onSlider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(withDifference)/100.0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startOver(sender: self)
  }
}

