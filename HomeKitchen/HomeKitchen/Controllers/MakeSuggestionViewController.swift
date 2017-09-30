//
//  MakeSuggestionViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/27/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import ObjectMapper

class MakeSuggestionViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let reuseableCell = "Cell"
  var orderInfo: OrderInfo = OrderInfo()
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  @IBOutlet weak var totalLabel: UILabel!
  
  @IBOutlet weak var deliveryTimeTextField: UITextField!
  
  var index: Int = 0
  var totalPrice: Int = 0
  
  let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "MakeSuggestionViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    deliveryDateLabel.text = orderInfo.deliveryDate
    deliveryTimeTextField.text = orderInfo.deliveryTime
    totalLabel.text = "\(orderInfo.totalAmount)"
    // Create datePicker for timeTextField
    createDatePicker()
    // Tapping dateLabel
    let tapLable: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapDateLabel))
    deliveryDateLabel.isUserInteractionEnabled = true
    deliveryDateLabel.addGestureRecognizer(tapLable)
    
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: Tableview Delegate
extension MakeSuggestionViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
extension MakeSuggestionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderInfo.products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! MakeSuggestionViewCell
    cell.configureWithItem(orderItem: orderInfo.products[indexPath.row])
    // Handle textfield in row
    cell.priceTextField.tag = indexPath.row
    cell.priceTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}

extension MakeSuggestionViewController {
  // Catching price textfield change number
  func textFieldDidChange(textField: UITextField) {
    index = textField.tag
    if !textField.text!.isEmpty {
      if let productPrice = orderInfo.products[index].product?.price {
        // Calculate price of all quantity of product again
        orderInfo.products[index].orderItemPrice = productPrice * orderInfo.products[index].quantity
      }
      calculateToTalPrice()
    }
  }
  
  func calculateToTalPrice() {
    totalPrice = 0
    for item in orderInfo.products {
      totalPrice += item.quantity * item.product!.price
    }
    totalLabel.text = "\(totalPrice)"
  }
  
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    
    deliveryTimeTextField.inputView = datePicker
    
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    deliveryTimeTextField.inputAccessoryView = toolbar
    
  }
  
  func doneClicked() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    deliveryTimeTextField.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  func tapDateLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showCalendarView", sender: self)
  }
  
  override func dismissKeyboard() {
    view.endEditing(true)
  }
  
}

// MARK: IBAction
extension MakeSuggestionViewController {
  @IBAction func didTouchSendButton(_ sender: Any) {
    print("====json \(orderInfo.products.toJSON())")
    NetworkingService.sharedInstance.sendSuggestion(orderId: orderInfo.id, deliveryTime: deliveryTimeTextField.text!, deliveryDate: deliveryDateLabel.text!, totalPrice: totalPrice, products: orderInfo.products) {(error) in
      if error != nil {
        print(error!)
      } else {
        let alert = UIAlertController(title: "Notification", message: "Order successfully.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func unwindToMakeSuggestionController(segue:UIStoryboardSegue) {
    if segue.source is CalendarViewController {
      if let senderVC = segue.source as? CalendarViewController {
        deliveryDateLabel.text = senderVC.datePicking
      }
    }
  }
}

extension MakeSuggestionViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCalendarView" {
      if let destination = segue.destination as? CalendarViewController {
        destination.sourceViewController = "MakeSuggestionViewController"
      }
    }
  }
}
