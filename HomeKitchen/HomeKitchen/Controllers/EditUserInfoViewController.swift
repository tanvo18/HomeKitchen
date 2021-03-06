//
//  EditUserInfoViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/29/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import Cosmos

class EditUserInfoViewController: UIViewController {
  // MARK: IBOutlet
  @IBOutlet weak var radButtonMale: UIButton!
  @IBOutlet weak var radButtonFemale: UIButton!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var birthdayTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  
  var radMaleStatus: Bool = true
  // Right button in navigation bar
  var rightButtonItem: UIBarButtonItem = UIBarButtonItem()
  let datePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Navigation bar
    self.settingForNavigationBar(title: "Thông tin tài khoản")
    settingRightButtonItem()
    // Assign data
    parseDataForTextField()
    // Date picker
    createDatePicker()
    // Init Menu Button
    let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.didTouchMenuButton))
    self.navigationItem.leftBarButtonItem  = menuButton
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: Function
extension EditUserInfoViewController {
  func parseImageToRadButton() {
    if radMaleStatus {
      radButtonMale.setImage(UIImage(named: "rad-button-check"), for: .normal)
      radButtonFemale.setImage(UIImage(named: "rad-button-uncheck"), for: .normal)
    } else {
      radButtonMale.setImage(UIImage(named: "rad-button-uncheck"), for: .normal)
      radButtonFemale.setImage(UIImage(named: "rad-button-check"), for: .normal)
    }
  }
  
  func parseDataForTextField() {
    if Helper.user.gender == 1 {
      radMaleStatus = true
    } else {
      radMaleStatus = false
    }
    parseImageToRadButton()
    if Helper.user.name != "anonymous" {
      nameTextField.text = Helper.user.name
    }
    
    // Because birthday get from server has format dd/MM/yyyy so we must convert to yyyy-MM-dd to match when send to server
    // Server is not consistence in date format
    if Helper.user.birthday != "" {
      let stringDate: String = convertDay(stringDate: Helper.user.birthday)
      birthdayTextField.text = stringDate
    }
    phoneTextField.text = Helper.user.phoneNumber
  }
  
  func convertDay(stringDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let dateFromString: Date = dateFormatter.date(from: stringDate)!
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let convertStringDate = dateFormatter.string(from: dateFromString)
    return convertStringDate
  }
  
  func settingRightButtonItem() {
    self.rightButtonItem = UIBarButtonItem.init(
      title: "Sửa",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    if checkNotNil() {
      guard let birthday = birthdayTextField.text, let name = nameTextField.text, let phoneNumber = phoneTextField.text else {
        return
      }
      // Check gender
      var gender: Int = 0
      if radMaleStatus {
        gender = 1
      } else {
        gender = 0
      }
      
      NetworkingService.sharedInstance.editUserInfo(birthday: birthday, gender: gender, name: name, phoneNumber: phoneNumber, contactInfos: Helper.user.contactInformations) {
        [unowned self] (message,error) in
        if error != nil {
          self.alertError(message: "Gửi thất bại")
        } else {
          let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            // Update new info data for Helper.user
            Helper.user.birthday = birthday
            Helper.user.gender = gender
            Helper.user.name = name
            Helper.user.phoneNumber = phoneNumber
          })
          self.alertWithAction(message: "Thành công", action: ok)
        }
      }
    } else {
      self.alertError(message: "Bạn phải nhập tất cả các trường")
    }
    
  }
  
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .date
    // using Great Britain for 24 hour system
    datePicker.locale = Locale(identifier: "en_GB")
    birthdayTextField.inputView = datePicker
    
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    birthdayTextField.inputAccessoryView = toolbar
    
  }
  
  func doneClicked() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateAsString = dateFormatter.string(from: datePicker.date)
    print("====string \(dateAsString)")
    birthdayTextField.text = dateAsString
    self.view.endEditing(true)
  }
  
  func checkNotNil() -> Bool {
    if nameTextField.text!.isEmpty || birthdayTextField.text!.isEmpty || phoneTextField.text!.isEmpty {
      return false
    }  else {
      return true
    }
  }
  
  func didTouchMenuButton(_ sender: Any) {
    sideMenuManager?.toggleSideMenuView()
  }
}

// MARK: IBAction
extension EditUserInfoViewController {
  @IBAction func didTouchRadButtonMale(_ sender: Any) {
    if radMaleStatus == false {
      radMaleStatus = true
      parseImageToRadButton()
    }
  }
  
  @IBAction func didTouchRadButtonFemale(_ sender: Any) {
    if radMaleStatus {
      radMaleStatus = false
      parseImageToRadButton()
    }
  }
}
