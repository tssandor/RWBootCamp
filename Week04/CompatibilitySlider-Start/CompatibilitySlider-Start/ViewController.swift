//
//  ViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var compatibilityItemLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var questionLabel: UILabel!

  var compatibilityItems = ["Cats", "Dogs", "Debugging for hours", "Gym", "Cold weather", "Reading"]
  var currentItemIndex: Int = -1

  var person1 = Person(id: 1, items: [:])
  var person2 = Person(id: 2, items: [:])
  var currentPerson: Person?

  override func viewDidLoad() {
    super.viewDidLoad()
    startGame()
  }
  
  func startGame() {
    questionLabel.text = "User 1, how do you feel about..."
    currentPerson = person1
    askAQuestion()
  }

  @IBAction func didPressNextItemButton(_ sender: Any) {
    saveValue()
    askAQuestion()
  }

  func saveValue() {
    let currentItem = compatibilityItems[currentItemIndex]
    currentPerson!.items.updateValue(slider.value, forKey: currentItem)
    slider.value = 2.5
  }

  func checkIfStillQuestionsLeft() -> Bool {
    currentItemIndex < compatibilityItems.count ? true : false
  }
    
  func askAQuestion() {
    currentItemIndex += 1
    // Let's check if we have any questions left!
    if !checkIfStillQuestionsLeft() {
      if currentPerson == person2 {
        // No more questions and we are already at person2, so let's evaluate
        evaluateCompatibility()
      } else {
        // No more questions for person1, let's switch to person2!
        currentPerson = person2
        currentItemIndex = -1
        questionLabel.text = "User 2, how do you feel about..."
        askAQuestion()
      }
    } else {
      // There are still questions left!
      compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
    }
  }
  
  func evaluateCompatibility() {
    let message = "You two are \(calculateCompatibility()) compatible"
    let alert = UIAlertController(title: "The results are in!", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Restart game", style: .default, handler: {
      action in
      self.startGame()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
    
  func calculateCompatibility() -> String {
    // If diff 0.0 is 100% and 5.0 is 0%, calculate match percentage
    var percentagesForAllItems: [Double] = []

    for (key, person1Rating) in person1.items {
        let person2Rating = person2.items[key] ?? 0
        let difference = abs(person1Rating - person2Rating)/5.0
        percentagesForAllItems.append(Double(difference))
    }

    let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
    let matchPercentage = sumOfAllPercentages/Double(compatibilityItems.count)
    print(matchPercentage, "%")
    let matchString = 100 - (matchPercentage * 100).rounded()
    return "\(matchString)%"
  }

}

