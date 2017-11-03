//
//  SuggestionsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/20/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let reuseableCell = "Cell"
  var suggestions: [Suggestion] = []
  var index: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: Disable sidemenu
    sideMenuManager?.sideMenuController()?.sideMenu?.disabled = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "SuggestionsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    self.settingForNavigationBar(title: "Danh sách đề nghị")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension SuggestionsViewController: UITableViewDelegate {
}

extension SuggestionsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suggestions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! SuggestionsTableViewCell
    cell.configureWithItem(suggestion: suggestions[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    index = indexPath.row
    performSegue(withIdentifier: "showSuggestionDetail", sender: self)
  }
}

extension SuggestionsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSuggestionDetail" {
      if let destination = segue.destination as? SuggestionDetailViewController {
        destination.suggestion = suggestions[index]
      }
    }
  }
}
