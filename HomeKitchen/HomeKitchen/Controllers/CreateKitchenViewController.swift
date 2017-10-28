//
//  CreateKitchenViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/8/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class CreateKitchenViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var districtLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  // MARK: UITextField
  var openingTimeTextField: UITextField!
  var closingTimeTextField: UITextField!
  var kitchenNameTF: UITextField!
  var typeTF: UITextField!
  var streetAddressTF: UITextField!
  var phoneNumberTF: UITextField!
  
  let reuseableCreateCell = "CreateCell"
  let reuseableTimeCell = "TimeCell"
  let data = [["Kitchen's name", "Bussiness type", "Street address","Phone number"],["Opening time"]]
  let headerTitles = ["Thông tin bắt buộc", "Thông tin thêm"]
  let sectionOnePlaceHolder = ["Tên bếp", "Kiểu bếp", "Địa chỉ","Số điện thoại"]
  
  let datePicker = UIDatePicker()
  
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
    // Navigation bar
    self.settingForNavigationBar(title: "Tạo bếp")
    settingRightButtonItem()
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
      openingTimeTextField = timeCell.openingTextField
      closingTimeTextField = timeCell.closingTextField
      createPickerForOpeningTF(timeTextField: openingTimeTextField)
      createPickerForClosingTF(timeTextField: closingTimeTextField)
      // Set image for imageViewCell section 2
      timeCell.imageViewCell.image = UIImage(named: Helper.createKitchenCellSection2[indexPath.row])
      return timeCell
    } else {
      let createKitchenCell = tableView.dequeueReusableCell(withIdentifier: reuseableCreateCell) as! CreateKitchenTableViewCell
      // Set image for imageViewCell section 1
      createKitchenCell.imageViewCell.image = UIImage(named: Helper.createKitchenCellSection1[indexPath.row])
      if indexPath.row == 0 {
        kitchenNameTF = createKitchenCell.textFieldCell
      } else if indexPath.row == 1 {
        typeTF = createKitchenCell.textFieldCell
      } else if indexPath.row == 2 {
        streetAddressTF = createKitchenCell.textFieldCell
      } else if indexPath.row == 3 {
         // Set number type for phone number textfield
        createKitchenCell.textFieldCell.keyboardType = .numberPad
        phoneNumberTF = createKitchenCell.textFieldCell
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
    // using Great Britain for 24 hour system
    datePicker.locale = Locale(identifier: "en_GB")
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
    // Change 12 hour system to 24 hour system
    let dateAsString = dateFormatter.string(from: datePicker.date)
    dateFormatter.dateFormat = "h:mm a"
    let date = dateFormatter.date(from: dateAsString)
    
    dateFormatter.dateFormat = "HH:mm"
    let date24 = dateFormatter.string(from: date!)
    openingTimeTextField.text = date24
    self.view.endEditing(true)
  }
  
  func createPickerForClosingTF(timeTextField: UITextField) {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    // using Great Britain for 24 hour system
    datePicker.locale = Locale(identifier: "en_GB")
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
    // Change 12 hour system to 24 hour system
    let dateAsString = dateFormatter.string(from: datePicker.date)
    dateFormatter.dateFormat = "h:mm a"
    let date = dateFormatter.date(from: dateAsString)
    
    dateFormatter.dateFormat = "HH:mm"
    let date24 = dateFormatter.string(from: date!)
    closingTimeTextField.text = date24
    self.view.endEditing(true)
  }
  
  func tapDistrictLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showLocation", sender: self)
  }
  
  func settingRightButtonItem() {
    let rightButtonItem = UIBarButtonItem.init(
      title: "Gửi",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: CGFloat(170/255.0), green: CGFloat(151/255.0), blue: CGFloat(88/255.0), alpha: 1.0)
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    if checkNotNil() {
      let today = setCurrentDate()
      let defaultImageUrl = Helper.defaultImageUrl
      let address = Address(city: cityLabel.text!, district: districtLabel.text!, address: streetAddressTF.text!, phoneNumber: phoneNumberTF.text!)
      guard let openingTime = openingTimeTextField.text,let closingTime = closingTimeTextField.text, let kitchenName = kitchenNameTF.text, let type = typeTF.text else {
        return
      }
      
      NetworkingService.sharedInstance.createKitchen(openingTime: openingTime , closingTime: closingTime, kitchenName: kitchenName, imageUrl: defaultImageUrl, type: type, createdDate: today, address: address) {
        [unowned self] (message,error) in
        if error != nil {
          print(error!)
          self.alertError(message: "Cannot create kitchen")
        } else {
          let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            // Go to Home Screen
            self.performSegue(withIdentifier: "showHomeScreen", sender: self)
          })
          self.alertWithAction(message: "Create Successfully", action: ok)
        }
      }
    } else {
      self.alert(title: "Error", message: "All fields are required")
    }
  }
  
  func setCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let result = formatter.string(from: date)
    return result
  }
  
  func checkNotNil() -> Bool {
    if  kitchenNameTF.text!.isEmpty || typeTF.text!.isEmpty || streetAddressTF.text!.isEmpty || phoneNumberTF.text!.isEmpty{
      return false
    } else if districtLabel.text! == "Select District" {
      return false
    } else {
      return true
    }
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
        destination.viewcontroller = "CreateKitchenViewController"
      }
    }
  }
}
