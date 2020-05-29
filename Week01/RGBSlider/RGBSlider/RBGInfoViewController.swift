//
//  RBGInfoViewController.swift
//  RGBSlider
//
//  Created by TSS on 2020/5/29.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit
import WebKit

class RBGInfoViewController: UIViewController {

  @IBOutlet weak var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let url = URL(string: "https://en.wikipedia.org/wiki/RGB_color_model")
    let request = URLRequest(url: url!)
    webView.load(request)
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
}
