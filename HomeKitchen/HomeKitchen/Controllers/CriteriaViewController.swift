//
//  CriteriaViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 11/6/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class CriteriaViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var criterias: [String] = ["Thành phố","Kiểu","Đánh giá"]
  var selectedCriteria: String = ""
  let reuseableCell = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CriteriaTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    // Hide Foot view
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    // Adjust navigation bar
    self.settingForNavigationBar(title: "Chọn loại")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: Tableview Delegate
extension CriteriaViewController: UITableViewDelegate {
}

// MARK: Tableview Datasource
extension CriteriaViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return criterias.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! CriteriaTableViewCell
    cell.criteriaLabel.text = criterias[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCriteria = criterias[indexPath.row]
    print("====criteria \(selectedCriteria)")
    performSegue(withIdentifier: "unwindToSearchViewController", sender: self)
  }
}
