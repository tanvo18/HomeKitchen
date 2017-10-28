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
  
  let reuseableCell = "Cell"
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
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension SuggestionDetailViewController: UITableViewDelegate {
}

extension SuggestionDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suggestion.suggestItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! SuggestionTableViewCell
    cell.configureWithItem(item: suggestion.suggestItems[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
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
        self.alertError(message: "Request cannot be done")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        })
        self.alertWithAction(message: "Accept Successfully", action: ok)
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
        self.alertError(message: "Request cannot be done")
      } else {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          // Go to List order screen
          self.performSegue(withIdentifier: "showListOrder", sender: self)
        })
        self.alertWithAction(message: "Decline Successfully", action: ok)
      }
    }
  }
}
