//
//  CreateKitchenViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/8/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class CreateKitchenViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var districtLabel: UILabel!
  let reuseableCreateCell = "CreateCell"
  let reuseableTimeCell = "TimeCell"
  let data = [["Kitchen's name", "Bussiness type", "Street address","Phone number"],["Opening time"]]
  let headerTitles = ["Required information", "More information"]
  let sectionOnePlaceHolder = ["Kitchen's name", "Bussiness type", "Street address","Phone number"]
  let datePicker = UIDatePicker()
  var openingTextField: UITextField = UITextField()
  var closingTextField: UITextField = UITextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CreateKitchenTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCreateCell)
    tableView.register(UINib(nibName: "CustomTimeTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableTimeCell)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
    // Tapping districtLabel
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapDistrictLabel))
    districtLabel.isUserInteractionEnabled = true
    districtLabel.addGestureRecognizer(tap)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension CreateKitchenViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension CreateKitchenViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 0 {
      let timeCell = tableView.dequeueReusableCell(withIdentifier: reuseableTimeCell) as! CustomTimeTableViewCell
      openingTextField = timeCell.openingTextField
      closingTextField = timeCell.closingTextField
      createPickerForOpeningTF(timeTextField: openingTextField)
      createPickerForClosingTF(timeTextField: closingTextField)
      return timeCell
    } else {
      let createKitchenCell = tableView.dequeueReusableCell(withIdentifier: reuseableCreateCell) as! CreateKitchenTableViewCell
      // Set number type for phone number textfield
      if indexPath.row == 3 {
        createKitchenCell.textFieldCell.keyboardType = .numberPad
      }
      createKitchenCell.configureWithItem(title: sectionOnePlaceHolder[indexPath.row])
      return createKitchenCell
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section < headerTitles.count {
      return headerTitles[section]
    }
    return nil
  }
}

// MARK: Function
extension CreateKitchenViewController {
  func createPickerForOpeningTF(timeTextField: UITextField) {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    timeTextField.inputView = datePicker
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTouchOpeningDoneButton))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
  }
  
  func didTouchOpeningDoneButton() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    openingTextField.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  func createPickerForClosingTF(timeTextField: UITextField) {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    timeTextField.inputView = datePicker
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTouchClosingDoneButton))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
  }
  
  func didTouchClosingDoneButton() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    closingTextField.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  func tapDistrictLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showLocation", sender: self)
  }
}

// MARK: IBAction
extension CreateKitchenViewController {
  @IBAction func unwindToCreateKitchenController(segue:UIStoryboardSegue) {
    if segue.source is LocationViewController {
      if let senderVC = segue.source as? LocationViewController {
        districtLabel.text = senderVC.selectedLocation
      }
    }
  }
}

extension CreateKitchenViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showLocation" {
      if let destination = segue.destination as? LocationViewController {
        destination.locations = Helper.districtLocations
      }
    }
  }
}
