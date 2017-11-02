//
//  SuggestionDetailViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SuggestionDetailViewController: UIViewController {
  
  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var acceptedButton: UIButton!
  @IBOutlet weak var declinedButton: UIButton!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
  
  let reuseableCell = "Cell"
  var heightOfRows: CGFloat = 0
  var heightForOneRow: CGFloat = 70
  
  var suggestion: Suggestion = Suggestion()
  var suggestionId: Int = 0
  var isAccepted: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Setup for label
    deliveryTimeLabel.text = suggestion.deliveryTime
    deliveryDateLabel.text = suggestion.deliveryDate
    totalPriceLabel.text = "\(suggestion.totalPrice)"
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "SuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    // Hide button if user is chef
    if Helper.role == "chef" {
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    }
    self.settingForNavigationBar(title: "Chi tiết đề nghị")
    
    // Hide button if status of suggestion != pending
    if suggestion.status != "pending" {
      acceptedButton.isHidden = true
      declinedButton.isHidden = true
    }
    
    // Calculate height of tableview
    heightOfRows = CGFloat(suggestion.suggestItems.count) * heightForOneRow
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

// MARK: TableView Delegate
extension SuggestionDetailViewController: UITableViewDelegate {
}

// MARK: TableView DataSource
extension SuggestionDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suggestion.suggestItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! SuggestionTableViewCell
    cell.configureWithItem(item: suggestion.suggestItems[indexPath.row])
    // Hide separator of last cell
    if indexPath.row == suggestion.suggestItems.count - 1 {
      cell.separatorView.isHidden = true
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightForOneRow
  }
}

// MARK: IBAction
extension SuggestionDetailViewController {
  @IBAction func didTouchAcceptedButton(_ sender: Any) {
    suggestionId = suggestion.id
    isAccepted = true
    NetworkingService.sharedInstance.responseSuggestion(suggestionId: suggestionId, isAccepted: isAccepted) {
      (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Gửi thất bại")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
  
  @IBAction func didTouchDeclinedButton(_ sender: Any) {
    suggestionId = suggestion.id
    isAccepted = false
    NetworkingService.sharedInstance.responseSuggestion(suggestionId: suggestionId, isAccepted: isAccepted) {
      (message,error) in
      if error != nil {
        print(error!)
        self.alertError(message: "Gửi thất bại")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        })
        self.alertWithAction(message: "Thành công", action: ok)
      }
    }
  }
}
