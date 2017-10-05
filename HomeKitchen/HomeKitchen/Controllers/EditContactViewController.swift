//
//  EditContactViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/26/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
  // MARK: IBOutlet
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var phoneTextField: UITextField!
  
  @IBOutlet weak var addressTextField: UITextField!
  
  var contact: ContactInfo?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initDataTextField()
    settingForNavigationBar()
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension EditContactViewController {
  func initDataTextField() {
    nameTextField.text = contact?.name
    phoneTextField.text = contact?.phoneNumber
    addressTextField.text = contact?.address
  }
  
  func checkNotNil() -> Bool {
    if  nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || addressTextField.text!.isEmpty {
      return false
    } else {
      return true
    }
  }
  
  func settingForNavigationBar() {
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    navigationItem.title = "Edit Contanct"
  }
  
}

// MARK: IBAction
extension EditContactViewController {
  @IBAction func didTouchEditButton(_ sender: Any) {
    if checkNotNil() {
      contact?.name = nameTextField.text!
      contact?.phoneNumber = phoneTextField.text!
      contact?.address = addressTextField.text!
      
      let birthday = Helper.user.birthday
      let gender = Helper.user.gender
      let name = Helper.user.name
      let phoneNumber = Helper.user.phoneNumber
      NetworkingService.sharedInstance.editContactInfo(birthday: birthday, gender: gender, name: name, phoneNumber: phoneNumber, contactInfo: contact!) { [unowned self] (message,error) in
        if error != nil {
          print(error!)
          self.alertError(message: "Cannot Edit")
        } else {
          self.performSegue(withIdentifier: "unwindToOrderInfoController", sender: self)
        }
      }
      
    } else {
      let message = "All field are required"
      let title = "error"
      self.alert(title: title, message: message)
    }
  }
}
