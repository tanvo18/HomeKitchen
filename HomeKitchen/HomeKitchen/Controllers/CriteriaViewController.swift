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
  
  // parse from KitchenViewController or
  var criterias: [String] = []
  var selectedCriteria: String = ""
  
  
  let reuseableCell = "Cell"
  var sourceViewController = ""
  
  var data = [["Thành phố","Đánh giá"],["Ăn chay","Bánh","Ăn vặt","Cơm văn phòng","Đồ nướng","Đặc sản miền Bắc","Đặc sản miền Trung","Đặc sản miền Nam"]]
  let headerTitles = ["Tìm theo thành phố hoặc đánh giá", "Tìm theo kiểu bếp"]
  
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
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! CriteriaTableViewCell
      cell.criteriaLabel.text = data[indexPath.section][indexPath.row]
      return cell
    } else  {
      let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! CriteriaTableViewCell
      cell.criteriaLabel.text = data[indexPath.section][indexPath.row]
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section < headerTitles.count {
      return headerTitles[section]
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCriteria = data[indexPath.section][indexPath.row]
    print("====selected \(selectedCriteria)")
    if sourceViewController == "KitchenViewController" {
      performSegue(withIdentifier: "unwindToKitchenViewController", sender: self)
    }
  }
}
