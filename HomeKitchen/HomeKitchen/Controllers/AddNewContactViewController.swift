//
//  AddNewContactViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/23/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AddNewContactViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var phoneTextField: UITextField!
  
  @IBOutlet weak var addressTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: Function
extension AddNewContactViewController {
  func checkNotNil() -> Bool {
    if  nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || addressTextField.text!.isEmpty {
      return false
    } else {
      return true
    }
  }
}

// MARK: IBAction
extension AddNewContactViewController {
  @IBAction func didTouchButtonAdd(_ sender: Any) {
    if checkNotNil() {
      performSegue(withIdentifier: "unwindToOrderInfoController", sender: self)
    } else {
      let title = "Message"
      let message = "All fields are required"
      self.alert(title: title, message: message)
    }
  }
}
