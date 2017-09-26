//
//  SuggestionViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/26/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var deliveryTimeLabel: UILabel!
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  let reuseableCell = "Cell"
  var suggestions: [Suggestion] = []
  var suggestion: Suggestion = Suggestion()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if !suggestions.isEmpty {
      suggestion = suggestions[0]
      // Setup for label
      deliveryTimeLabel.text = suggestion.deliveryTime
      deliveryDateLabel.text = suggestion.deliveryDate
    }
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "SuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension SuggestionViewController: UITableViewDelegate {
}

extension SuggestionViewController: UITableViewDataSource {
  
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
