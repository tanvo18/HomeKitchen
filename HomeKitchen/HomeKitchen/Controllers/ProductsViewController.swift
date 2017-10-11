//
//  ProductsViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 10/11/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let reuseable = "Cell"
  var products: [Product] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseable)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    settingRightButtonItem()
    self.settingForNavigationBar(title: "Kitchen's Products")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
// MARK: tableView Delegate
extension ProductsViewController: UITableViewDelegate {
  
}

// MARK: tableView Datasource
extension ProductsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseable) as! ProductsTableViewCell
    cell.configureWithItem(product: products[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
  }
}

// MARK: Function
extension ProductsViewController {
  func settingRightButtonItem() {
    let rightButtonItem = UIBarButtonItem.init(
      title: "",
      style: .done,
      target: self,
      action: #selector(rightButtonAction(sender:))
    )
    rightButtonItem.image = UIImage(named: "barbutton-plus")
    self.navigationItem.rightBarButtonItem = rightButtonItem
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: CGFloat(170/255.0), green: CGFloat(151/255.0), blue: CGFloat(88/255.0), alpha: 1.0)
  }
  
  func rightButtonAction(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showCreateProduct", sender: self)
  }
}


