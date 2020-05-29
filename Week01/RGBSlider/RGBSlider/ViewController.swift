//
//  ViewController.swift
//  RGBSlider
//
//  Created by TSS on 2020/5/29.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var usingLightColorLabels: Bool = false
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
    //let message = "Give this terrible color a name!"
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
    areWeInHSBMode = false
    toggleRGBvsHSB()
  }
  
  func changeBgColor(colorName: String) {
    let color1 = CGFloat(slider1.value.rounded())/CGFloat(slider1Max)
    let color2 = CGFloat(slider2.value.rounded())/CGFloat(slider2Max)
    let color3 = CGFloat(slider3.value.rounded())/CGFloat(slider3Max)
    let newBgColor = CGColor(srgbRed: color1, green: color2, blue: color3, alpha: 1.0)
    colorNameLabel.text = colorName
    view.backgroundColor = UIColor(cgColor: newBgColor)
  }
  
  func toggleRGBvsHSB() {
    
  }
  
}

