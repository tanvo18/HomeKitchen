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
  
  var contact: ContactInfo = ContactInfo()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initDataTextField()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func initDataTextField() {
    nameTextField.text = contact.name
    phoneTextField.text = contact.phoneNumber
    addressTextField.text = contact.address
  }
  
  func checkNotNil() -> Bool {
    if  nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || addressTextField.text!.isEmpty {
      return false
    } else {
      return true
    }
  }
  
  @IBAction func didTouchEditButton(_ sender: Any) {
    if checkNotNil() {
      contact.name = nameTextField.text!
      contact.phoneNumber = phoneTextField.text!
      contact.address = addressTextField.text!
      
      let birthday = Helper.user.birthday
      let gender = Helper.user.gender
      let name = Helper.user.name
      let phoneNumber = Helper.user.phoneNumber
      NetworkingService.sharedInstance.editContactInfo(birthday: birthday, gender: gender, name: name, phoneNumber: phoneNumber, contactInfo: contact) { [unowned self] (error) in
        if error != nil {
          print(error!)
        } else {
          let alert = UIAlertController(title: "Notification", message: "Edit successfully.", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            // Go to OrderInfo Screen
            self.performSegue(withIdentifier: "unwindFromEdit", sender: self)
          }))
          self.present(alert, animated: true, completion: nil)
        }
      
      }
      
    } else {
      let message = "All field are required"
      let title = "error"
      self.alert(title: title, message: message)
    }
  }
}
