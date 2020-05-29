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
    reset()
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    if let sliderMoved = self.view.viewWithTag(sender.tag) as? UISlider
    {
      switch sender.tag {
      // tags 1001, 1002, 1003 are slider1, slider2, slider3
      case 1001:
        label1.text = String(Int(sliderMoved.value.rounded()))
      case 1002:
        label2.text = String(Int(sliderMoved.value.rounded()))
      case 1003:
        label3.text = String(Int(sliderMoved.value.rounded()))
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
    colorNameLabel.text = "Mystery color"
    view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
  }
  
  func changeBgColor(colorName: String) {
    let color1 = CGFloat(slider1.value.rounded())/255
    let color2 = CGFloat(slider2.value.rounded())/255
    let color3 = CGFloat(slider3.value.rounded())/255
    let newBgColor = CGColor(srgbRed: color1, green: color2, blue: color3, alpha: 1.0)
    colorNameLabel.text = colorName
    view.backgroundColor = UIColor(cgColor: newBgColor)
  }
}

