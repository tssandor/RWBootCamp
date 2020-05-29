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
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var colorNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    if let sliderMoved = self.view.viewWithTag(sender.tag) as? UISlider
    {
      switch sender.tag {
      case 1001:
        label1.text = String(Int(sliderMoved.value.rounded()))
      case 1002:
        label2.text = String(Int(sliderMoved.value.rounded()))
      case 1003:
        label3.text = String(Int(sliderMoved.value.rounded()))
      default:
        print("This should never appear, something went wrong. The sender wasn't any of the sliders...")
      }
    }
    print(sender.tag)
  }
  
  @IBAction func setColor() {
    print("R: \(slider1.value), G: \(slider2.value), B: \(slider3.value)")
  }

  @IBAction func reset() {
    slider1.value = 128.0
    slider2.value = 128.0
    slider3.value = 128.0
    colorNameLabel.text = "Mystery color"
  }
  
  func updateSliderLabels() {
    label1.text = String(slider1.value.rounded())
    label2.text = String(slider2.value.rounded())
    label3.text = String(slider3.value.rounded())
  }
  
}

