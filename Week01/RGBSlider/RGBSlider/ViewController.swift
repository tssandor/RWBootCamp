//
//  ViewController.swift
//  RGBSlider
//
//  Created by TSS on 2020/5/29.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var slider1: UISlider!
  @IBOutlet weak var slider2: UISlider!
  @IBOutlet weak var slider3: UISlider!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func setColor() {
    print("R: \(slider1.value), G: \(slider2.value), B: \(slider3.value)")
  }

  @IBAction func reset() {
    slider1.value = 0.0
    slider2.value = 0.0
    slider3.value = 0.0
  }
  
}

