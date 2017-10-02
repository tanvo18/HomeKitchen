//
//  OrderInfoViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/15/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import ObjectMapper


class OrderInfoViewController: UIViewController {
  
  // MARK: IBOutlet
  
  @IBOutlet weak var timeTextField: UITextField!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  // For Calendar
  @IBOutlet weak var monthLabel: UILabel!
  
  let reuseableCell = "Cell"
  // Save index of tableview cell
  var position = 0
  let datePicker = UIDatePicker()
  // Items which customer ordered
  var orderedItems: [OrderItem] = []
  // Message for notification not nil required
  var message: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Create datePicker for timeTextField
    createDatePicker()
    // Tapping dateLabel
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapDateLabel))
    dateLabel.isUserInteractionEnabled = true
    dateLabel.addGestureRecognizer(tap)
    // TableView Delegate
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ContactInfoTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Set current date and time
    dateLabel.text = setCurrentDate()
    timeTextField.text = setCurrentTime()
    settingForNavigationBar()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: Tableview Delegate
extension OrderInfoViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
extension OrderInfoViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Helper.user.contactInformations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ContactInfoTableViewCell
    if Helper.user.contactInformations.count > 0 {
      let contact = Helper.user.contactInformations[indexPath.row]
      cell.configureWithItem(contact: contact)
      cell.radioButton.tag = indexPath.row
      cell.radioButton.addTarget(self, action: #selector(self.didTouchRadioButton), for: .touchUpInside)
      return cell
    } else {
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    position = indexPath.row
    performSegue(withIdentifier: "showEdit", sender: self)
  }
}


extension OrderInfoViewController {
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    
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

// MARK: Function
extension OrderInfoViewController {
  // Unhide calendar when tap date label
  func tapDateLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showCalendar", sender: self)
  }
  
  // Check all textfield not empty
  func checkNotNil() -> Bool {
    if  timeTextField.text!.isEmpty {
      self.message = "Time is required"
      return false
    }
    if dateLabel.text! == "date" {
      self.message = "Date is required"
      return false
    }
    if Helper.user.contactInformations.isEmpty {
      self.message = "You have to add contact"
      return false
    }
    
    if !isContactChosen() {
      self.message = "You have to choose a contact"
      return false
    }
    
    return true
  }
  
  // Check is there any contact chosen, avoid customer didn't choose any contact
  func isContactChosen() -> Bool {
    for contact in Helper.user.contactInformations {
      if contact.isChosen == true {
        return true
      }
    }
    return false
  }
  
  // Click radio Button
  func didTouchRadioButton(sender: UIButton) {
    position = sender.tag
    let contacts = Helper.user.contactInformations
    for (index,contact) in contacts.enumerated() {
      if index == position {
        contact.isChosen = true
      }
      else {
        contact.isChosen = false
      }
    }
    tableView.reloadData()
  }
  
  func chosenContact() -> ContactInfo {
    var chosenContact: ContactInfo = ContactInfo()
    for contact in Helper.user.contactInformations {
      if contact.isChosen {
        chosenContact = contact
      }
    }
    return chosenContact
  }
  
  func setCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let result = formatter.string(from: date)
    return result
  }
  
  func setCurrentTime() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    let timeString = formatter.string(from: date)
    return timeString
  }
  
  func settingForNavigationBar() {
    // Set title for back button in navigation bar
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    navigationItem.title = "Order Information"
  }
}

// MARK: IBAction
extension OrderInfoViewController {
  
  @IBAction func didTouchButtonCheckout(_ sender: Any) {
    if checkNotNil() {
      if Helper.orderInfo.status == "in_cart" {
        NetworkingService.sharedInstance.updateOrder(id: Helper.orderInfo.id, contact: chosenContact(), orderDate: setCurrentDate(), deliveryDate: dateLabel.text!, deliveryTime: timeTextField.text!, status: "pending", orderedItems: orderedItems) { [unowned self] (error) in
          if error != nil {
            print(error!)
          } else {
            let alert = UIAlertController(title: "Notification", message: "Order successfully.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
              // Go to HomeScreen
              self.performSegue(withIdentifier: "showHomeScreen", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
          }
        }
      } else {
        NetworkingService.sharedInstance.sendOrder(contact: chosenContact(), orderDate: setCurrentDate(), deliveryDate: dateLabel.text!, deliveryTime: timeTextField.text!, status: "pending", kitchenId: Helper.kitchenId, orderedItems: orderedItems) { [unowned self] (error) in
          if error != nil {
            print(error!)
          } else {
            let alert = UIAlertController(title: "Notification", message: "Order successfully.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
              // Go to HomeScreen
              self.performSegue(withIdentifier: "showHomeScreen", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
            
          }
          
        }
        
      }
    } else {
      let alert = UIAlertController(title: "Error", message: self.message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func didTouchButtonAdd(_ sender: Any) {
    self.performSegue(withIdentifier: "showAddContact", sender: self)
  }
  
  @IBAction func unwindToOrderInfoController(segue:UIStoryboardSegue) {
    if segue.source is CalendarViewController {
      if let senderVC = segue.source as? CalendarViewController {
        dateLabel.text = senderVC.datePicking
      }
    } else if segue.source is EditContactViewController {
      tableView.reloadData()
    } else if segue.source is AddNewContactViewController {
      if let senderVC = segue.source as? AddNewContactViewController {
        let name = senderVC.nameTextField.text!
        let phoneNumber = senderVC.phoneTextField.text!
        let address = senderVC.addressTextField.text!
        let contact = ContactInfo(name: name, phoneNumber: phoneNumber, address: address)
        Helper.user.contactInformations.append(contact)
        // Reload tableview
        tableView.reloadData()
      }
    }
  }
}

extension OrderInfoViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showEdit" {
      if let destination = segue.destination as? EditContactViewController {
        destination.contact = Helper.user.contactInformations[position]
      }
    } else if segue.identifier == "showCalendar" {
      if let destination = segue.destination as? CalendarViewController {
        destination.sourceViewController = "OrderInfoViewController"
      }
    }
  }
}

