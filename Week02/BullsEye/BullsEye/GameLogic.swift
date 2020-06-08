//
//  GameLogic.swift
//  BullsEye
//
//  Created by TSS on 2020/6/8.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

struct BullsEyeGame {
  var currentValue = 0
  var targetValue = 0
  var score = 0
  var round = 0
  
  // I decided to branch out a few internal methods to make it more readable
  func calculateDifference() -> Int {
    abs(targetValue - currentValue)
  }
  
  // Returns the new points (adds extra if needed). I separated this from changing the title of the alert so it's more modular.
  func addExtraPoints(toThisMuchPoints points: Int, whenDifferenceIs difference: Int) -> Int {
    if difference == 0 {
      return(points + 100)
    } else if difference == 1 {
      return(points + 50)
    } else {
      return points
    }
  }
  
  // Determines the title of the alert
  func determineTitle(whenDifferenceIs difference: Int) -> String {
    if difference == 0 {
      return("Perfect!")
    } else if difference < 5 {
      return("You almost had it!")
    } else if difference < 10 {
      return("Pretty good!")
    } else {
      return("Not even close...")
    }
  }
  
  // We return the points (Int) and the title we should use on the alert (String)
  mutating func calculatePoints() -> (points: Int, title: String) {
    
    let difference = calculateDifference()
    var points = 100 - difference
    points = addExtraPoints(toThisMuchPoints: points, whenDifferenceIs: difference)
    score += points
    
    let title = determineTitle(whenDifferenceIs: difference)
    
    return(points, title)
  }
  
}

