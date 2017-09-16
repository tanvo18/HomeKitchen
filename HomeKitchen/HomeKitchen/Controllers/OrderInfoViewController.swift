//
//  OrderInfoViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/15/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class OrderInfoViewController: UIViewController {
  
  // MARK: IBOutlet
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var phoneTextField: UITextField!
  
  @IBOutlet weak var dateTextField: UITextField!
  
  @IBOutlet weak var timeTextField: UITextField!
  
  let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Create datePicker for timeTextField
    createDatePicker()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension OrderInfoViewController {
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .dateAndTime
    
    timeTextField.inputView = datePicker
    
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
    
  }
  
  func doneClicked() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    timeTextField.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
}
