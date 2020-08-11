//
//  ViewController.swift
//  RandomAnimations
//
//  Created by TSS on 2020/8/10.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var buttonOnLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonOnRightConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonOnTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var animatedRectangle: UIView!

  var animator: UIViewPropertyAnimator?
  let buttonStackOpenConstraint: CGFloat = 40
  let buttonStackClosedConstraint: CGFloat = -60
  var isButtonStackOpen: Bool = true
  var shouldWeAnimateTheButtonStack: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRectangle()
    animationManager()
  }
  
  func setupRectangle() {
    // setting up the initial view
    let quarterTheScreenWidth = animatedRectangle.superview!.frame.size.width / 4
    animatedRectangle.frame.size = CGSize(width: quarterTheScreenWidth, height: quarterTheScreenWidth)
    animatedRectangle.center = animatedRectangle.superview!.center
    animatedRectangle.translatesAutoresizingMaskIntoConstraints = false
  }

  func animationManager() {
    // arranging the buttons
    isButtonStackOpen.toggle()
    buttonOnLeftConstraint.constant = isButtonStackOpen ? buttonStackOpenConstraint : buttonStackClosedConstraint
    buttonOnRightConstraint.constant = isButtonStackOpen ? buttonStackOpenConstraint : buttonStackClosedConstraint
    buttonOnTopConstraint.constant = isButtonStackOpen ? buttonStackOpenConstraint : buttonStackClosedConstraint
    
    if shouldWeAnimateTheButtonStack {
      print("Bouncing the button stack :]")
      UIView.animate(
        withDuration: 0.5, delay: 0,
        // Big bounce :]
        usingSpringWithDamping: isButtonStackOpen ? 0.3 : 1,
        initialSpringVelocity: 10,
        animations: { self.view.layoutIfNeeded() }
      )
    } else {
      self.view.layoutIfNeeded()
      // next time we should animate it, so setting it here
      shouldWeAnimateTheButtonStack.toggle()
    }
  }
  
  func setAnimationTime() {
    if animator == nil {
      animator = UIViewPropertyAnimator(duration: TimeInterval.random(in: 0.5...2.0), curve: .easeIn)
      animator!.addCompletion({ (_) in
        self.animator = nil
      })
    }
  }
  
  @IBAction func pressedPlay(_ sender: Any) {
    if animator == nil {
      // There's nothing to animate. We call the manager which will close the button stack.
      animationManager()
      return
    }
    // Let's animate!
    animationManager()
    animator?.startAnimation()
  }
  
  // button on the top (merge icon)
  @IBAction func pressedRotate(_ sender: Any) {
    print("Rotating the rectangle")
    setAnimationTime()
    animator?.addAnimations {
      self.animatedRectangle.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
    }
  }
  
  // button on the left (phone)
  @IBAction func pressedMoveRectangle(_ sender: Any) {
    print("Moving the rectangle")
    setAnimationTime()
    animator?.addAnimations {
      // we need to make sure we don't move it outside the screen
      let containerView = self.animatedRectangle.superview!
      let maximumX = containerView.frame.size.width
      let maximumY = containerView.frame.size.height
      let halfOfTheRectangleOffset = self.animatedRectangle.frame.size.width/2
      let randomX = CGFloat.random(in: halfOfTheRectangleOffset...maximumX-halfOfTheRectangleOffset)
      let randomY = CGFloat.random(in: halfOfTheRectangleOffset...maximumY-halfOfTheRectangleOffset)
      self.animatedRectangle.center = CGPoint(x: randomX, y: randomY)
    }
  }
  
  // button on the right (github)
  @IBAction func pressedScaleRectangle(_ sender: Any) {
    print("Scaling the rectangle")
    setAnimationTime()
    animator?.addAnimations {
      let randomSize = CGFloat.random(in: 0.3...1)
      self.animatedRectangle.transform = CGAffineTransform(scaleX: randomSize, y: randomSize)
    }
  }
}

// https://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1/28075467
extension CGFloat {
    static var random: CGFloat {
           return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
