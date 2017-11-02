//
//  AnswerDetailViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswerDetailViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var acceptedButton: UIButton!
  @IBOutlet weak var declinedButton: UIButton!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
  
  var answer: Answer!
  var postItem: [PostItem] = []
  var deliveryTime: String = ""
  var deliveryDate: String = ""
  
  let reuseableCell = "Cell"
  var heightOfRows: CGFloat = 0
  var heightForOneRow: CGFloat = 80
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Hide buttons with chef
    if Helper.role == "chef" {
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Chi tiết yêu cầu")
    // Matching
    matchingAnswerDetailWithPostItem()
    timeLabel.text = deliveryTime
    dateLabel.text = deliveryDate
    totalPriceLabel.text = "\(answer.totalPrice)"
    // Hide button accept and decline if status != pending
    if answer.status != "pending" {
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    }
    
    // Calculate height of tableview
    heightOfRows = CGFloat(answer.answerDetails.count) * heightForOneRow
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
extension AnswerDetailViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension AnswerDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return answer.answerDetails.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! AnswerTableViewCell
    cell.configureWithItem(answerDetail: answer.answerDetails[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForOneRow
  }
  
}

// MARK: Function
extension AnswerDetailViewController {
  func matchingAnswerDetailWithPostItem() {
    for detail in answer.answerDetails {
      for item in postItem {
        if detail.postItemId == item.id {
          detail.productName = item.productName
          detail.quantity = item.quantity
        }
      }
    }
  }
  
  func setCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let result = formatter.string(from: date)
    return result
  }
}

// MARK: IBAction
extension AnswerDetailViewController {
  @IBAction func didTouchAcceptedButton(_ sender: Any) {
    NetworkingService.sharedInstance.responseAnswer(answerId: answer.id, isAccepted: true, acceptedDate: setCurrentDate()) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Gửi thất bại")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showListPost", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
  
  @IBAction func didTouchDeclinedButton(_ sender: Any) {
    NetworkingService.sharedInstance.responseAnswer(answerId: answer.id, isAccepted: false, acceptedDate: setCurrentDate()) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Gửi thất bại")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showListPost", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
}

