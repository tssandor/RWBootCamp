//
//  ViewController.swift
//  ComparisonShopper
//
//  Created by Jay Strawn on 6/15/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Left
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var priceLabelLeft: UILabel!
    @IBOutlet weak var roomLabelLeft: UILabel!

    // Right
    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var priceLabelRight: UILabel!
    @IBOutlet weak var roomLabelRight: UILabel!

    var house1: House?
    var house2: House?

    override func viewDidLoad() {
        super.viewDidLoad()

        // *****
        // To follow my debugging process, start reading at line 48!
        // *****

        house1 = House(address: nil, price: "$12,000", bedrooms: "3 bedrooms")
        // We now initialized house1 properly! We had to do it before we set up the left view. Go to line 53!
      
        setUpLeftSideUI()
        setUpRightSideUI()
      
        // Why are these declared as optionals? We declare it so we know it exists!
        // house1?.price = "$12,000"
        // house1?.bedrooms = "3 bedrooms"
        // Now jump to line 35 :]
    }

    func setUpLeftSideUI() {
      // Found with a breakpoint and a po that the whole house1 object is nil (so not just one property)
      // Looks like we never even initialized it correctly!
      // So let's take a look at that in line 41
      
      
      // OK so now house1 is initialized properly.
      // The problem is we are force-unwrapping the properties and they can be nil (in fact the address is now nil)
      // So we need to handle this case. I can steal the code snippet from setUpRightSideUI, but I don't like the look of it :]
      // It handles the case where house2 is nil but not directly the case when a proprerty is nil.
      // Let's make it prettier with nil coalescing!
      // I'll just comment out this old code here as a memento.
//        titleLabelLeft.text = house1!.address!
//        priceLabelLeft.text = house1!.price!
//        roomLabelLeft.text = house1!.bedrooms!
      if house1 == nil {
          titleLabelLeft.alpha = 0
          imageViewLeft.alpha = 0
          priceLabelLeft.alpha = 0
          roomLabelLeft.alpha = 0
      } else {
          titleLabelLeft.text! = house1?.address ?? "Address unknown"
          priceLabelLeft.text! = house1?.price ?? "Price unknown"
          // Oh well roomLabelLeft was not connected, so fixed that. Was easy to spot since the circle next to it was empty
          // in the IBOutlet declarations list :]
          roomLabelLeft.text! = house1?.bedrooms ?? "Size unknown"
      }
    }

    func setUpRightSideUI() {
        if house2 == nil {
            titleLabelRight.alpha = 0
            imageViewRight.alpha = 0
            priceLabelRight.alpha = 0
            roomLabelRight.alpha = 0
        } else {
            // Alright let's see what's going on here. The alertview sets house2 up CORRECTLY
            // as you can test with po.house2
            // If you test it further, you can also see the label text is set up correctly, e.g., po priceLabelRight.text
            // This is not a logic issue, it must be a display issue.
            // Hah wait!! It must be the alpha! So we already called setUpRightSideUI() once in viewDidLoad()
            // We've set the alpha to 0 and never corrected it! So it's there, just fully transparent :]
            // Let's fix this.
          
            // This was indeed the issue! Now, I could just delete setUpRightSideUI() from viewDidLoad() but
            // I think this is a better solution. Don't want to mess with the app structure, a developer
            // working on it later might not understand why we only set up one half of the screen :]
            titleLabelRight.text! = house2?.address ?? "Address unknown"
            priceLabelRight.text! = house2?.price ?? "Price unknown"
            roomLabelRight.text! = house2?.bedrooms ?? "Size unknown"
            titleLabelRight.alpha = 1
            imageViewRight.alpha = 1
            priceLabelRight.alpha = 1
            roomLabelRight.alpha = 1
        }
    }
  
    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "address"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "price"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "bedrooms"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            var house = House()
            house.address = alert.textFields?[0].text
            house.price = alert.textFields?[1].text
            house.bedrooms = alert.textFields?[2].text
            self.house2 = house
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

struct House {
    var address: String?
    var price: String?
    var bedrooms: String?
}

