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

import Foundation

struct BullsEyeGame {  // might be class?
  var score: Int
  var round: Int
  var targetColor: RGB
  var guessColor: RGB
  
  func createNewTargetColor() -> RGB {
    let r = Int.random(in: 1...255)
    let g = Int.random(in: 1...255)
    let b = Int.random(in: 1...255)
    let newTargetColor = RGB(r: r, g: g, b: b)
    return newTargetColor
  }
  
  func calculateScore(withDifference difference: Double) -> Int {
    var score = Int((100 - difference * 100).rounded())
    if score == 100 {
      // BULL'S EYE
      score = 1000
    }
    return score
  }
}
