//
//  ProductReviewsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 11/4/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ProductReviewsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var reviews: [Review] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  let reuseableCell = "Cell"
  // Right button in navigation bar
  var rightButtonItem: UIBarButtonItem = UIBarButtonItem()
  // Parse from order viewcontroller
  var productId: Int = 0
  let productReviewDataModel: ProductReviewDataModel = ProductReviewDataModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ProductReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseableCell)
    self.settingForNavigationBar(title: "Đánh giá sản phẩm")
    // Right item button
    settingRightButtonItem()
    getProductReviews()
    // self-sizing tableview row
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: tableView Delegate
extension ProductReviewsViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension ProductReviewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell) as! ProductReviewsTableViewCell
    cell.configureWithReview(review: reviews[indexPath.row])
    return cell
  }
  
}

// MARK: Function
extension ProductReviewsViewController {
  func settingRightButtonItem() {
    self.rightButtonItem = UIBarButtonItem.init(
      title: "Đánh giá",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    self.navigationItem.rightBarButtonItem = rightButtonItem
  }
  
  func getProductReviews() {
    productReviewDataModel.getProductReviews(productId: productId) {
      [unowned self] (productReviews,error) in
      if error != nil {
        print(error!)
      } else {
        self.reviews = productReviews
      }
    }
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showCreateReview", sender: self)
  }
}

extension ProductReviewsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCreateReview" {
      if let destination = segue.destination as? CreateReviewViewController {
        destination.sourceViewController = "ProductReviewsViewController"
        destination.productId = productId
      }
    }
  }
}
