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
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryTimeTextField: UITextField!
  
  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
  
  let reuseableCell = "Cell"
  var heightOfRows: CGFloat = 0
  var heightForOneRow: CGFloat = 80
  
  var index: Int = 0
  var totalPrice: Int = 0
  // Information from post detail
  var postItems: [PostItem] = []
  var postId: Int = 0
  var deliveryTimeOfPost: String = ""
  var deliveryDateOfPost: String = ""
  let datePicker = UIDatePicker()
  
  var answerDetails: [AnswerDetail] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CreateAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Trả lời yêu cầu")
    // init data for date and time
    deliveryDateLabel.text = deliveryDateOfPost
    deliveryTimeTextField.text = deliveryTimeOfPost
    // Tab outside to close keyboard
    let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tapOutside)
    // Tapping dateLabel
    let tapLable: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapDateLabel))
    deliveryDateLabel.isUserInteractionEnabled = true
    deliveryDateLabel.addGestureRecognizer(tapLable)
    // Create picker for time
    createDatePicker()
    // Calculate height of tableview
    heightOfRows = CGFloat(postItems.count) * heightForOneRow
  }
  
  override func updateViewConstraints() {
    print("====heightOfRows Update: \(heightOfRows)")
    super.updateViewConstraints()
    // Update height of view inside scrollView
    let extraHeight = heightOfRows - tableHeightConstraint.constant
    if extraHeight > 0 {
      // Need to add more height for view
      viewHeightConstraint.constant += heightOfRows - tableHeightConstraint.constant
    }
    print("====constraintHeightView After \(viewHeightConstraint.constant)")
    tableHeightConstraint.constant = heightOfRows
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForOneRow
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
  
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    // using Great Britain for 24 hour system
    datePicker.locale = Locale(identifier: "en_GB")
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
    // Change 12 hour system to 24 hour system
    let dateAsString = dateFormatter.string(from: datePicker.date)
    dateFormatter.dateFormat = "h:mm a"
    let date = dateFormatter.date(from: dateAsString)
    dateFormatter.dateFormat = "HH:mm"
    let date24 = dateFormatter.string(from: date!)
    deliveryTimeTextField.text = date24
    self.view.endEditing(true)
  }
  
  func tapDateLabel(sender:UITapGestureRecognizer) {
    performSegue(withIdentifier: "showCalendarView", sender: self)
  }
  
  func addPostItemToAnswers() {
    for item in postItems {
      let answerDetail = AnswerDetail(postItemId: item.id, itemPrice: item.price)
      self.answerDetails.append(answerDetail)
    }
  }
}

// MARK: IBAction
extension CreateAnswerViewController {
  @IBAction func unwindToCreateAnswerViewController(segue:UIStoryboardSegue) {
    if segue.source is CalendarViewController {
      if let senderVC = segue.source as? CalendarViewController {
        deliveryDateLabel.text = senderVC.datePicking
      }
    }
  }
  
  @IBAction func didTouchSendButton(_ sender: Any) {
    // Add Item before send
    addPostItemToAnswers()
    
    guard let deliveryTime = deliveryTimeTextField.text, let deliveryDate = deliveryDateLabel.text else {
      return
    }
    NetworkingService.sharedInstance.sendAnswer(postId: postId, deliveryDate: deliveryDate, deliveryTime: deliveryTime, answerDetails: answerDetails) {
      [unowned self] (error) in
      if error != nil {
        self.alertError(message: "Gửi thất bại")
        print(error!)
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showListPost", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
}

extension CreateAnswerViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCalendarView" {
      if let destination = segue.destination as? CalendarViewController {
        destination.sourceViewController = "CreateAnswerViewController"
      }
    }
  }
}
