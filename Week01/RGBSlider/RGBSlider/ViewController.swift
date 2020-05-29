//
//  ViewController.swift
//  RGBSlider
//
//  Created by TSS on 2020/5/29.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var slider1Max: Int = 255
  var slider2Max: Int = 255
  var slider3Max: Int = 255
  
  var areWeInHSBMode: Bool = false
  
  @IBOutlet weak var slider1: UISlider!
  @IBOutlet weak var slider2: UISlider!
  @IBOutlet weak var slider3: UISlider!
  @IBOutlet weak var sliderValueLabel1: UILabel!
  @IBOutlet weak var sliderValueLabel2: UILabel!
  @IBOutlet weak var sliderValueLabel3: UILabel!
  @IBOutlet weak var sliderNameLabel1: UILabel!
  @IBOutlet weak var sliderNameLabel2: UILabel!
  @IBOutlet weak var sliderNameLabel3: UILabel!
  @IBOutlet weak var colorNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reset()
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    if let sliderMoved = self.view.viewWithTag(sender.tag) as? UISlider
    {
      switch sender.tag {
      // tags 1001, 1002, 1003 are slider1, slider2, slider3
      case 1001:
        sliderValueLabel1.text = String(Int(sliderMoved.value.rounded()))
      case 1002:
        sliderValueLabel2.text = String(Int(sliderMoved.value.rounded()))
      case 1003:
        sliderValueLabel3.text = String(Int(sliderMoved.value.rounded()))
      default:
        print("This should never appear, something went wrong ;]")
      }
    }
  }
  
  @IBAction func setColor() {
    let alert = UIAlertController(title: "Looks terrible ;]", message: nil, preferredStyle: .alert)
    alert.addTextField { (textField) in
        textField.placeholder = "Give this terrible color a name!"
    }
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      let colorName = alert.textFields![0] as UITextField
      self.changeBgColor(colorName: colorName.text!)
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func reset() {
    slider1.value = 0.0
    sliderValueChanged(slider1)
    slider2.value = 0.0
    sliderValueChanged(slider2)
    slider3.value = 0.0
    sliderValueChanged(slider3)
    colorNameLabel.text = "Default white background"
    view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
  }
  
  func changeBgColor(colorName: String) {
    let colorParameter1 = CGFloat(slider1.value.rounded())/CGFloat(slider1Max)
    let colorParameter2 = CGFloat(slider2.value.rounded())/CGFloat(slider2Max)
    let colorParameter3 = CGFloat(slider3.value.rounded())/CGFloat(slider3Max)
    var newBgColor: UIColor
    if !areWeInHSBMode {
      newBgColor = UIColor(cgColor: CGColor(srgbRed: colorParameter1, green: colorParameter2, blue: colorParameter3, alpha: 1.0))
    } else {
      newBgColor = UIColor(hue: colorParameter1, saturation: colorParameter2, brightness: colorParameter3, alpha: 1.0)
    }
    view.backgroundColor = newBgColor
    
    // This one space string seems to be needed. If the string is empty the Label disappears and the UISegmentedControl is using autolayout aligned to the label. There's likely a better way to do this :]
    if colorName == "" {
      colorNameLabel.text = " "
    } else {
      colorNameLabel.text = colorName
    }
  }
  
  @IBAction func modeChanged(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 1 {
      areWeInHSBMode = true
    } else {
      areWeInHSBMode = false
    }
    toggleRGBvsHSB()
  }
  
  func toggleRGBvsHSB() {
    if areWeInHSBMode {
      slider1Max = 360
      slider2Max = 100
      slider3Max = 100
      slider1.maximumValue = Float(slider1Max)
      slider2.maximumValue = Float(slider2Max)
      slider3.maximumValue = Float(slider3Max)
      sliderNameLabel1.text = "Hue"
      sliderNameLabel2.text = "Saturation"
      sliderNameLabel3.text = "Brightness"
      reset()
    } else {
      slider1Max = 255
      slider2Max = 255
      slider3Max = 255
      slider1.maximumValue = Float(slider1Max)
      slider2.maximumValue = Float(slider2Max)
      slider3.maximumValue = Float(slider3Max)
      sliderNameLabel1.text = "Red"
      sliderNameLabel2.text = "Green"
      sliderNameLabel3.text = "Blue"
      reset()
    }
  }
  
}
