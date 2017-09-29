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
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func didTouchButtonAdd(_ sender: Any) {
    if checkNotNil() {
      performSegue(withIdentifier: "unwindToOrderInfoController", sender: self)
    }
  }
  
  func checkNotNil() -> Bool {
    if  nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || addressTextField.text!.isEmpty {
      return false
    } else {
      return true
    }
  }
  
}
