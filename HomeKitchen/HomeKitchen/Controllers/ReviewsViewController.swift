//
//  ReviewsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/30/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var reviews: [Review] = []
  let reuseableCell = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    self.settingForNavigationBar(title: "Danh sách đánh giá")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

// MARK: tableView Delegate
extension ReviewsViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension ReviewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ReviewsTableViewCell
    cell.backgroundColor = .gray
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
}

