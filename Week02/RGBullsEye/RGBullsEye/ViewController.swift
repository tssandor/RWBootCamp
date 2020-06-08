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
  var game = BullsEyeGame(score: 0, round: 0, targetColor: RGB(r: 127, g: 127, b: 127), guessColor: RGB(r: 255, g: 255, b: 255))
  
  @IBAction func aSliderMoved(sender: UISlider) {

    // We update the slider label
    switch sender {
      case redSlider:
        redLabel.text = "R " + String(Int(sender.value.rounded()))
      case greenSlider:
        greenLabel.text = "G " + String(Int(sender.value.rounded()))
      case blueSlider:
        blueLabel.text = "B " + String(Int(sender.value.rounded()))
      default:
        print("This should never appear, something went wrong ;]")
    }
    
    // We update the guess color
    game.guessColor = RGB(r: Int(redSlider.value.rounded()), g: Int(greenSlider.value.rounded()), b: Int(blueSlider.value.rounded()))
    guessLabel.backgroundColor = UIColor(rgbStruct: game.guessColor)
    
  }
  
  @IBAction func showAlert(sender: AnyObject) {
    print(game.targetColor)
    print(game.guessColor)
    let difference = game.guessColor.difference(target: game.targetColor)
    print(difference)
  }
  
  @IBAction func startOver(sender: AnyObject) {
    let newTargetColor = game.createNewTargetColor()
    game.targetColor = newTargetColor
    game.score = 0
    game.round = 0
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetColor)
  }
  
  func updateView() {

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startOver(sender: self)
  }
}

