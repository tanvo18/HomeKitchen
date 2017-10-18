//
//  AnswerViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/17/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var acceptedButton: UIButton!
  @IBOutlet weak var declinedButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var post: Post!
  var answer: Answer!
  var postItem: [PostItem] = []
  let reuseableCell = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Get first element in answers
    answer = post.answers[0]
    // Get postItem from post
    postItem = post.postItems
    // get date and time
    timeLabel.text = post.deliveryTime
    dateLabel.text = post.deliveryDate
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
    self.settingForNavigationBar(title: "Answer Screen")
    // Matching
    matchingAnswerDetailWithPostItem()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension AnswerViewController: UITableViewDelegate {
}

// MARK: tableView Datasource
extension AnswerViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return answer.answerDetails.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! AnswerTableViewCell
    cell.configureWithItem(answerDetail: answer.answerDetails[indexPath.row])
    return cell
  }
  
}

// MARK: Function
extension AnswerViewController {
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
extension AnswerViewController {
  @IBAction func didTouchAcceptedButton(_ sender: Any) {
    NetworkingService.sharedInstance.responseAnswer(answerId: answer.id, isAccepted: true, acceptedDate: setCurrentDate()) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Cannot accept")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showListPost", sender: self)
        })
        self.alertWithAction(message: "Accept Successfully", action: ok)
      }
    }
  }
  
  @IBAction func didTouchDeclinedButton(_ sender: Any) {
    NetworkingService.sharedInstance.responseAnswer(answerId: answer.id, isAccepted: false, acceptedDate: setCurrentDate()) {
      [unowned self] (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Cannot accept")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          self.performSegue(withIdentifier: "showListPost", sender: self)
        })
        self.alertWithAction(message: "Accept Successfully", action: ok)
      }
    }
  }
}


