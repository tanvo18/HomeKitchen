//
//  CreateAnswerViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class CreateAnswerViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var totalLabel: UILabel!
  
  var index: Int = 0
  var totalPrice: Int = 0
  let reuseableCell = "Cell"
  // Information from post detail
  var postItems: [PostItem] = []
  var id: Int = 0
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CreateAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Create Answer")
    // init data for date and time
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: tableView Delegate
extension CreateAnswerViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension CreateAnswerViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! CreateAnswerTableViewCell
    cell.configureWithItem(postItem: postItems[indexPath.row])
    // Handle textfield in row
    cell.priceTextField.tag = indexPath.row
    cell.priceTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    return cell
  }
}

// MARK: Function
extension CreateAnswerViewController {
  // Catching price textfield change number
  func textFieldDidChange(textField: UITextField) {
    index = textField.tag
    if !textField.text!.isEmpty {
      postItems[index].price = Int(textField.text!)!
      calculateToTalPrice()
    }
  }
  
  func calculateToTalPrice() {
    totalPrice = 0
    for item in postItems {
      totalPrice += item.quantity * item.price
    }
    totalLabel.text = "\(totalPrice)"
  }
  
//  func createDatePicker() {
//    // Format the display of datepicker
//    datePicker.datePickerMode = .time
//    
//    deliveryTimeTextField.inputView = datePicker
//    
//    // Create a toolbar
//    let toolbar = UIToolbar()
//    toolbar.sizeToFit()
//    // Add a done button on this toolbar
//    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
//    toolbar.setItems([doneButton], animated: true)
//    deliveryTimeTextField.inputAccessoryView = toolbar
//    
//  }
//  
//  func doneClicked() {
//    // Format the date displays on textfield
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .none
//    dateFormatter.timeStyle = .short
//    
//    deliveryTimeTextField.text = dateFormatter.string(from: datePicker.date)
//    self.view.endEditing(true)
//  }
}
