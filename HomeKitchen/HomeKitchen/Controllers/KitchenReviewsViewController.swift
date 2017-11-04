//
//  KitchenReviewsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 11/4/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class KitchenReviewsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var reviews: [Review] = []
  let reuseableCell = "Cell"
  // Right button in navigation bar
  var rightButtonItem: UIBarButtonItem = UIBarButtonItem()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    self.settingForNavigationBar(title: "Danh sách đánh giá")
    // Right item button
    settingRightButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension KitchenReviewsViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension KitchenReviewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ReviewsTableViewCell
    cell.configureWithReview(review: reviews[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
  
}

// MARK: Function
extension KitchenReviewsViewController {
  func settingRightButtonItem() {
    self.rightButtonItem = UIBarButtonItem.init(
      title: "Đánh giá",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showCreateReview", sender: self)
  }
}

extension KitchenReviewsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCreateReview" {
      if let destination = segue.destination as? CreateReviewViewController {
        destination.sourceViewController = "KitchenReviewsViewController"
      }
    }
  }
}
